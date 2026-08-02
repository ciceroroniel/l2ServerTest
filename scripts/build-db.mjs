// ---------------------------------------------------------------------------
// build-db.mjs  (Node >= 18)
// Le todo o datapack (server/game/data) e gera docs/modding/db.js
// com window.L2DB = { items, npcs, recipes, multisell, buylists, skills, enchant, meta }
// + cross-refs (producedBy / usedIn / droppedBy / spoiledBy / soldBy / spawns).
// Uso: node scripts/build-db.mjs
// ---------------------------------------------------------------------------
import fs from 'node:fs';
import path from 'node:path';
import url from 'node:url';

const __dirname = path.dirname(url.fileURLToPath(import.meta.url));
const DATA = path.resolve(__dirname, '..', 'server', 'game', 'data');
const OUT = path.resolve(__dirname, '..', 'docs', 'modding', 'db.js');

// ---- Mini parser XML (suficiente para os XML regulares do datapack) --------
function parseXML(raw) {
  const str = raw
    .replace(/<!--[\s\S]*?-->/g, '')
    .replace(/<\?[\s\S]*?\?>/g, '')
    .replace(/<!\[CDATA\[[\s\S]*?\]\]>/g, '');
  const root = { tag: '#root', attrs: {}, children: [], text: '' };
  const stack = [root];
  let i = 0;
  while (true) {
    const lt = str.indexOf('<', i);
    if (lt === -1) break;
    if (lt > i) {
      const txt = str.slice(i, lt).trim();
      if (txt) stack[stack.length - 1].text += txt;
    }
    const gt = str.indexOf('>', lt);
    if (gt === -1) break;
    let tag = str.slice(lt + 1, gt).trim();
    i = gt + 1;
    if (tag.startsWith('/')) { if (stack.length > 1) stack.pop(); continue; }
    const selfClose = tag.endsWith('/');
    if (selfClose) tag = tag.slice(0, -1).trim();
    const nameMatch = tag.match(/^[\w:.-]+/);
    if (!nameMatch) continue;
    const name = nameMatch[0];
    const attrs = {};
    const attrStr = tag.slice(name.length);
    const re = /([\w:.-]+)\s*=\s*"([^"]*)"/g;
    let m;
    while ((m = re.exec(attrStr))) attrs[m[1]] = m[2];
    const node = { tag: name, attrs, children: [], text: '' };
    stack[stack.length - 1].children.push(node);
    if (!selfClose) stack.push(node);
  }
  return root;
}
const kids = (node, tag) => node.children.filter(c => c.tag === tag);
const kid = (node, tag) => node.children.find(c => c.tag === tag);
function listFiles(dir, recursive = false) {
  if (!fs.existsSync(dir)) return [];
  if (recursive) {
    return fs.readdirSync(dir, { recursive: true })
      .filter(f => f.toString().endsWith('.xml'))
      .map(f => path.join(dir, f.toString()));
  }
  return fs.readdirSync(dir).filter(f => f.endsWith('.xml')).map(f => path.join(dir, f));
}
const readXML = f => parseXML(fs.readFileSync(f, 'utf8'));
const num = v => (v == null ? undefined : (isNaN(+v) ? v : +v));
// caminho relativo (a partir de server/game) usado para localizar o arquivo no datapack
const rel = f => 'data/' + path.relative(DATA, f).split(path.sep).join('/');

// ---- Estruturas de saida ---------------------------------------------------
const items = {};      // id -> item
const npcs = {};       // id -> npc
const recipes = [];    // recipe list
const multisell = {};  // file -> {npcs, entries}
const buylists = {};   // file -> {npcs, items}
const skills = {};     // id -> {name, levels}
const enchant = { scrolls: [], groups: [] };

// indices cross-ref (id -> array)
const producedBy = {};
const usedIn = {};
const droppedBy = {};
const spoiledBy = {};
const soldBy = {};
const npcSpawns = {};
const npcSells = {};
const push = (obj, key, val) => { (obj[key] ||= []).push(val); };

// ---- ITENS ----------------------------------------------------------------
for (const f of listFiles(path.join(DATA, 'stats', 'items'))) {
  const root = readXML(f);
  const fileRel = rel(f);
  const list = kid(root, 'list') || root;
  for (const it of kids(list, 'item')) {
    const id = num(it.attrs.id);
    if (id == null) continue;
    const sets = {};
    for (const s of kids(it, 'set')) sets[s.attrs.name] = s.attrs.val;
    const stats = {};
    const statsNode = kid(it, 'stats');
    if (statsNode) for (const st of kids(statsNode, 'stat')) stats[st.attrs.type] = num(st.text);
    items[id] = {
      id,
      file: fileRel,
      name: it.attrs.name || sets.name || ('item ' + id),
      type: it.attrs.type || 'EtcItem',
      icon: sets.icon || '',
      grade: sets.crystal_type || 'NONE',
      slot: sets.bodypart || '',
      weaponType: sets.weapon_type || '',
      material: sets.material || '',
      weight: num(sets.weight) ?? 0,
      price: num(sets.price) ?? 0,
      enchantable: sets.enchant_enabled === 'true',
      magic: sets.is_magic_weapon === 'true',
      stackable: sets.is_stackable === 'true',
      etcType: sets.etcitem_type || '',
      sets,
      stats,
    };
  }
}

// ---- NPCS (+ drops/spoil) --------------------------------------------------
for (const f of listFiles(path.join(DATA, 'stats', 'npcs'))) {
  const root = readXML(f);
  const fileRel = rel(f);
  const list = kid(root, 'list') || root;
  for (const n of kids(list, 'npc')) {
    const id = num(n.attrs.id);
    if (id == null) continue;
    const acquire = kid(n, 'acquire');
    const statsNode = kid(n, 'stats');
    const vitals = statsNode && kid(statsNode, 'vitals');
    const ai = kid(n, 'ai');
    const npc = {
      id,
      file: fileRel,
      name: n.attrs.name || ('npc ' + id),
      title: n.attrs.title || '',
      level: num(n.attrs.level) ?? 0,
      type: n.attrs.type || 'Npc',
      race: (kid(n, 'race') || {}).text || '',
      sex: (kid(n, 'sex') || {}).text || '',
      exp: acquire ? num(acquire.attrs.exp) : 0,
      sp: acquire ? num(acquire.attrs.sp) : 0,
      hp: vitals ? num(vitals.attrs.hp) : undefined,
      mp: vitals ? num(vitals.attrs.mp) : undefined,
      aggressive: ai ? ai.attrs.isAggressive === 'true' : false,
      aggroRange: ai ? num(ai.attrs.aggroRange) : undefined,
      drops: [],
      spoil: [],
    };
    const dl = kid(n, 'dropLists');
    if (dl) {
      for (const drop of kids(dl, 'drop')) {
        for (const g of kids(drop, 'group')) {
          const gc = num(g.attrs.chance) ?? 0;
          const gitems = kids(g, 'item').map(it => ({
            id: num(it.attrs.id), min: num(it.attrs.min), max: num(it.attrs.max), chance: num(it.attrs.chance),
          }));
          npc.drops.push({ groupChance: gc, items: gitems });
        }
      }
      for (const sp of kids(dl, 'spoil')) {
        for (const it of kids(sp, 'item')) {
          npc.spoil.push({ id: num(it.attrs.id), min: num(it.attrs.min), max: num(it.attrs.max), chance: num(it.attrs.chance) });
        }
      }
    }
    npcs[id] = npc;
  }
}

// ---- RECEITAS --------------------------------------------------------------
{
  const rf = path.join(DATA, 'Recipes.xml');
  if (fs.existsSync(rf)) {
    const root = readXML(rf);
    const list = kid(root, 'list') || root;
    for (const it of kids(list, 'item')) {
      const production = kid(it, 'production');
      recipes.push({
        file: 'data/Recipes.xml',
        recipeId: num(it.attrs.recipeId),
        name: it.attrs.name || '',
        craftLevel: num(it.attrs.craftLevel) ?? 0,
        type: it.attrs.type || 'common',
        successRate: num(it.attrs.successRate) ?? 100,
        ingredients: kids(it, 'ingredient').map(g => ({ id: num(g.attrs.id), count: num(g.attrs.count) })),
        production: production ? { id: num(production.attrs.id), count: num(production.attrs.count) } : null,
      });
    }
  }
}

// ---- MULTISELL -------------------------------------------------------------
for (const f of listFiles(path.join(DATA, 'multisell'))) {
  const fileId = path.basename(f, '.xml');
  const root = readXML(f);
  const list = kid(root, 'list') || root;
  const npcsNode = kid(list, 'npcs');
  const boundNpcs = npcsNode ? kids(npcsNode, 'npc').map(x => num(x.text || x.attrs.id)).filter(Boolean) : [];
  const entries = kids(list, 'item').map(entry => ({
    ingredients: kids(entry, 'ingredient').map(g => ({ id: num(g.attrs.id), count: num(g.attrs.count) })),
    production: kids(entry, 'production').map(g => ({ id: num(g.attrs.id), count: num(g.attrs.count) })),
  }));
  multisell[fileId] = { file: rel(f), npcs: boundNpcs, entries };
}

// ---- BUYLISTS --------------------------------------------------------------
for (const f of listFiles(path.join(DATA, 'buylists'))) {
  const fileId = String(+path.basename(f, '.xml'));
  const root = readXML(f);
  const list = kid(root, 'list') || root;
  const npcsNode = kid(list, 'npcs');
  const boundNpcs = npcsNode ? kids(npcsNode, 'npc').map(x => num(x.text || x.attrs.id)).filter(Boolean) : [];
  const bitems = kids(list, 'item').map(it => ({ id: num(it.attrs.id), price: num(it.attrs.price), count: num(it.attrs.count), restock: num(it.attrs.restock_delay) }));
  buylists[fileId] = { file: rel(f), npcs: boundNpcs, items: bitems };
}

// ---- SKILLS ----------------------------------------------------------------
for (const f of listFiles(path.join(DATA, 'stats', 'skills'))) {
  const root = readXML(f);
  const fileRel = rel(f);
  const list = kid(root, 'list') || root;
  for (const s of kids(list, 'skill')) {
    const id = num(s.attrs.id);
    if (id == null) continue;
    skills[id] = {
      id,
      file: fileRel,
      name: s.attrs.name || ('skill ' + id),
      levels: num(s.attrs.levels) ?? 1,
      operateType: s.attrs.operateType || '',
      magicType: s.attrs.magicLevel ? undefined : undefined,
    };
  }
}

// ---- ENCHANT ---------------------------------------------------------------
{
  const ef = path.join(DATA, 'EnchantItemData.xml');
  if (fs.existsSync(ef)) {
    const root = readXML(ef);
    const list = kid(root, 'list') || root;
    for (const e of kids(list, 'enchant')) enchant.scrolls.push({ ...Object.fromEntries(Object.entries(e.attrs).map(([k, v]) => [k, num(v)])) });
  }
  const gf = path.join(DATA, 'EnchantItemGroups.xml');
  if (fs.existsSync(gf)) {
    const root = readXML(gf);
    const list = kid(root, 'list') || root;
    for (const g of kids(list, 'enchantRateGroup')) {
      enchant.groups.push({ name: g.attrs.name, ranges: kids(g, 'current').map(c => ({ enchant: c.attrs.enchant, chance: num(c.attrs.chance) })) });
    }
  }
}

// ---- SPAWNS ----------------------------------------------------------------
for (const f of listFiles(path.join(DATA, 'spawns'), true)) {
  let root;
  try { root = readXML(f); } catch { continue; }
  const stack = [root];
  const area = path.basename(f, '.xml');
  while (stack.length) {
    const node = stack.pop();
    for (const c of node.children) {
      if (c.tag === 'npc' && c.attrs.id && c.attrs.x != null) {
        const nid = num(c.attrs.id);
        push(npcSpawns, nid, { x: num(c.attrs.x), y: num(c.attrs.y), z: num(c.attrs.z), area });
      }
      stack.push(c);
    }
  }
}

// ---- CROSS-REFS ------------------------------------------------------------
// receitas
for (const r of recipes) {
  if (r.production) push(producedBy, r.production.id, { kind: 'recipe', recipeId: r.recipeId, craftLevel: r.craftLevel, success: r.successRate, ingredients: r.ingredients, count: r.production.count });
  for (const ing of r.ingredients) push(usedIn, ing.id, { kind: 'recipe', product: r.production ? r.production.id : null, count: ing.count, recipeId: r.recipeId });
}
// multisell
for (const [file, ms] of Object.entries(multisell)) {
  for (const e of ms.entries) {
    for (const p of e.production) push(producedBy, p.id, { kind: 'multisell', file, ingredients: e.ingredients, count: p.count, npcs: ms.npcs });
    for (const ing of e.ingredients) push(usedIn, ing.id, { kind: 'multisell', file, product: e.production[0] ? e.production[0].id : null, count: ing.count });
  }
  for (const nid of ms.npcs) push(npcSells, nid, { kind: 'multisell', file });
}
// buylists
for (const [file, bl] of Object.entries(buylists)) {
  for (const it of bl.items) push(soldBy, it.id, { file, price: it.price, npcs: bl.npcs });
  for (const nid of bl.npcs) push(npcSells, nid, { kind: 'buylist', file, count: bl.items.length });
}
// drops / spoil
for (const npc of Object.values(npcs)) {
  for (const g of npc.drops) {
    for (const it of g.items) {
      const eff = Math.round((g.groupChance * it.chance) / 100 * 10000) / 10000;
      push(droppedBy, it.id, { npc: npc.id, chance: eff, min: it.min, max: it.max });
    }
  }
  for (const it of npc.spoil) push(spoiledBy, it.id, { npc: npc.id, chance: it.chance, min: it.min, max: it.max });
}

// ---- Anexa cross-refs aos itens/npcs (com CAP para nao explodir tamanho) ---
const CAP = 250;
const capArr = (arr) => {
  if (!arr) return { list: [], total: 0 };
  const total = arr.length;
  const list = arr.slice().sort((a, b) => (b.chance ?? b.price ?? 0) - (a.chance ?? a.price ?? 0)).slice(0, CAP);
  return { list, total };
};
for (const it of Object.values(items)) {
  it.producedBy = producedBy[it.id] || [];
  const u = capArr(usedIn[it.id]); it.usedIn = u.list; it.usedInTotal = u.total;
  const d = capArr(droppedBy[it.id]); it.droppedBy = d.list; it.droppedByTotal = d.total;
  const s = capArr(spoiledBy[it.id]); it.spoiledBy = s.list; it.spoiledByTotal = s.total;
  const sd = capArr(soldBy[it.id]); it.soldBy = sd.list; it.soldByTotal = sd.total;
}
for (const npc of Object.values(npcs)) {
  const sp = npcSpawns[npc.id] || [];
  npc.spawnCount = sp.length;
  npc.spawns = sp.slice(0, 30);
  npc.sells = npcSells[npc.id] || [];
}

// ---- META + escrita --------------------------------------------------------
const meta = {
  generatedAt: new Date().toISOString(),
  counts: {
    items: Object.keys(items).length,
    npcs: Object.keys(npcs).length,
    recipes: recipes.length,
    multisell: Object.keys(multisell).length,
    buylists: Object.keys(buylists).length,
    skills: Object.keys(skills).length,
    enchantScrolls: enchant.scrolls.length,
  },
};

const DB = { meta, items, npcs, recipes, multisell, buylists, skills, enchant };
const json = JSON.stringify(DB);
fs.writeFileSync(OUT, 'window.L2DB = ' + json + ';\n', 'utf8');
const kb = Math.round(fs.statSync(OUT).size / 1024);
console.log('OK -> ' + OUT + '  (' + kb + ' KB)');
console.log('counts:', JSON.stringify(meta.counts));
