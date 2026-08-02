# ---------------------------------------------------------------------------
# build-docs-html.ps1
# Gera um site HTML autocontido (docs/modding/index.html) a partir dos .md.
# Basta abrir o index.html no navegador. Requer internet (marked/mermaid/hljs via CDN).
# Rode de novo sempre que editar os .md.
# ---------------------------------------------------------------------------

$ErrorActionPreference = 'Stop'
$modDir = Join-Path $PSScriptRoot '..\docs\modding'
$modDir = (Resolve-Path $modDir).Path
$outFile = Join-Path $modDir 'index.html'

# Ordem + titulos + icones da navegacao
$order = @(
    @{ n = '00'; title = 'Inicio / Indice';    icon = 'home' }
    @{ n = '01'; title = 'Arquitetura';         icon = 'sitemap' }
    @{ n = '02'; title = 'Estrutura de Pastas'; icon = 'folder' }
    @{ n = '03'; title = 'Itens';               icon = 'sword' }
    @{ n = '04'; title = 'NPCs e Lojas';        icon = 'store' }
    @{ n = '05'; title = 'Enchant';             icon = 'spark' }
    @{ n = '06'; title = 'Drops e Craft';       icon = 'flask' }
    @{ n = '07'; title = 'Configuracoes';       icon = 'gear' }
    @{ n = '08'; title = 'Codigo-Fonte';        icon = 'code' }
    @{ n = '09'; title = 'Client-Side';         icon = 'monitor' }
    @{ n = '10'; title = 'Receitas Praticas';   icon = 'book' }
)

$navSb = [System.Text.StringBuilder]::new()
$secSb = [System.Text.StringBuilder]::new()
$listSb = [System.Text.StringBuilder]::new()

foreach ($item in $order) {
    $file = Get-ChildItem -Path $modDir -Filter "$($item.n)_*.md" | Select-Object -First 1
    if (-not $file) { Write-Warning "Arquivo $($item.n)_*.md nao encontrado"; continue }
    $docId = "doc-$($item.n)"
    $raw = Get-Content -Path $file.FullName -Raw
    # Protege contra fechamento precoce do <script>
    $raw = $raw.Replace('</script', '<\/script')

    $badge = if ($item.n -eq '00') { 'Comece aqui' } else { $item.n }
    [void]$navSb.AppendLine("      <a class=`"nav-link`" href=`"#$docId`" data-doc=`"$docId`"><span class=`"num`">$badge</span><span class=`"txt`">$($item.title)</span></a>")
    [void]$secSb.AppendLine("<script type=`"text/markdown`" id=`"$docId`">")
    [void]$secSb.AppendLine($raw)
    [void]$secSb.AppendLine("</script>")
    [void]$listSb.AppendLine("    { id: `"$docId`", title: `"$($item.title)`" },")
}

$template = @'
<!DOCTYPE html>
<html lang="pt-BR" data-theme="light">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Guia de Customizacao - L2J Mobius Interlude</title>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/highlight.js/11.9.0/styles/github-dark.min.css">
<style>
  :root{
    --bg:#f7f8fa; --panel:#ffffff; --ink:#1f2430; --muted:#6b7280; --line:#e6e8ec;
    --brand:#7c3aed; --brand2:#4f46e5; --accent:#0ea5e9; --code-bg:#0d1117;
    --shadow:0 1px 3px rgba(16,24,40,.08),0 1px 2px rgba(16,24,40,.04);
    --sidebar:290px;
  }
  [data-theme="dark"]{
    --bg:#0f1115; --panel:#161a22; --ink:#e6e8ee; --muted:#9aa3b2; --line:#242a35;
    --brand:#a78bfa; --brand2:#818cf8; --accent:#38bdf8; --code-bg:#0b0e14;
    --shadow:0 1px 3px rgba(0,0,0,.4);
  }
  *{box-sizing:border-box}
  html,body{margin:0;padding:0}
  body{
    background:var(--bg); color:var(--ink);
    font-family:-apple-system,BlinkMacSystemFont,"Segoe UI",Roboto,Helvetica,Arial,sans-serif;
    line-height:1.65; -webkit-font-smoothing:antialiased;
  }
  a{color:var(--brand2); text-decoration:none}
  a:hover{text-decoration:underline}

  /* Layout */
  .app{display:flex; min-height:100vh}
  .sidebar{
    width:var(--sidebar); flex:0 0 var(--sidebar); position:sticky; top:0; height:100vh;
    background:var(--panel); border-right:1px solid var(--line); display:flex; flex-direction:column;
  }
  .brand{padding:18px 20px 12px; border-bottom:1px solid var(--line)}
  .brand h1{font-size:15px; margin:0; letter-spacing:.2px}
  .brand p{margin:4px 0 0; font-size:12px; color:var(--muted)}
  .search{padding:12px 14px}
  .search input{
    width:100%; padding:9px 12px; border:1px solid var(--line); border-radius:10px;
    background:var(--bg); color:var(--ink); font-size:13px; outline:none;
  }
  .search input:focus{border-color:var(--brand)}
  nav{padding:4px 10px 16px; overflow-y:auto; flex:1}
  .nav-link{
    display:flex; align-items:center; gap:10px; padding:9px 10px; border-radius:10px;
    color:var(--ink); font-size:13.5px; margin:2px 0;
  }
  .nav-link:hover{background:var(--bg); text-decoration:none}
  .nav-link.active{background:linear-gradient(90deg,var(--brand),var(--brand2)); color:#fff}
  .nav-link .num{
    flex:0 0 auto; min-width:22px; height:22px; padding:0 7px; border-radius:7px; font-size:11px;
    display:flex; align-items:center; justify-content:center; background:var(--bg); color:var(--muted);
    border:1px solid var(--line); font-weight:600;
  }
  .nav-link.active .num{background:rgba(255,255,255,.22); color:#fff; border-color:transparent}
  .nav-link .txt{white-space:nowrap; overflow:hidden; text-overflow:ellipsis}

  /* Main */
  .main{flex:1; min-width:0; display:flex; flex-direction:column}
  .topbar{
    position:sticky; top:0; z-index:5; display:flex; align-items:center; gap:12px;
    background:color-mix(in srgb,var(--panel) 85%,transparent); backdrop-filter:blur(8px);
    border-bottom:1px solid var(--line); padding:10px 26px;
  }
  .topbar .crumb{font-size:13px; color:var(--muted); flex:1; min-width:0;
    white-space:nowrap; overflow:hidden; text-overflow:ellipsis}
  .topbar .crumb b{color:var(--ink)}
  .icon-btn{
    border:1px solid var(--line); background:var(--panel); color:var(--ink); cursor:pointer;
    width:36px; height:36px; border-radius:9px; font-size:15px; display:flex; align-items:center; justify-content:center;
  }
  .icon-btn:hover{border-color:var(--brand)}
  .menu-btn{display:none}

  .content{
    max-width:880px; width:100%; margin:0 auto; padding:34px 26px 80px;
  }
  .content h1{font-size:30px; line-height:1.25; margin:.2em 0 .5em; letter-spacing:-.3px}
  .content h2{font-size:22px; margin:1.6em 0 .6em; padding-bottom:.3em; border-bottom:1px solid var(--line)}
  .content h3{font-size:17px; margin:1.4em 0 .5em}
  .content h4{font-size:15px; margin:1.2em 0 .4em; color:var(--muted); text-transform:uppercase; letter-spacing:.4px}
  .content p{margin:.7em 0}
  .content ul,.content ol{padding-left:1.4em}
  .content li{margin:.25em 0}
  .content img{max-width:100%}
  .content hr{border:0; border-top:1px solid var(--line); margin:2em 0}

  /* Anchor on hover */
  .content h2,.content h3{scroll-margin-top:70px; position:relative}
  .content h1{scroll-margin-top:70px}

  /* Tables */
  .content table{border-collapse:collapse; width:100%; margin:1.1em 0; font-size:14px; display:block; overflow-x:auto}
  .content th,.content td{border:1px solid var(--line); padding:8px 11px; text-align:left; vertical-align:top}
  .content thead th{background:var(--bg); font-weight:650}
  .content tbody tr:nth-child(even){background:color-mix(in srgb,var(--bg) 55%,transparent)}

  /* Inline code */
  .content :not(pre)>code{
    background:color-mix(in srgb,var(--brand) 12%,var(--bg)); color:var(--ink);
    padding:.12em .4em; border-radius:6px; font-size:.88em;
    font-family:"SF Mono",SFMono-Regular,ui-monospace,Menlo,Consolas,monospace;
  }
  /* Code blocks */
  .content pre{
    background:var(--code-bg); border:1px solid var(--line); border-radius:12px;
    padding:16px 18px; overflow-x:auto; margin:1.1em 0; box-shadow:var(--shadow);
  }
  .content pre code{font-family:"SF Mono",SFMono-Regular,ui-monospace,Menlo,Consolas,monospace; font-size:13px; line-height:1.6}

  /* Blockquote as callout */
  .content blockquote{
    margin:1.1em 0; padding:12px 16px; border-left:4px solid var(--accent);
    background:color-mix(in srgb,var(--accent) 9%,var(--panel)); border-radius:0 10px 10px 0; color:var(--ink);
  }
  .content blockquote p{margin:.3em 0}

  /* Mermaid */
  .mermaid{margin:1.4em 0; text-align:center; background:var(--panel); border:1px solid var(--line);
    border-radius:12px; padding:16px; overflow-x:auto}

  /* Prev/Next */
  .pager{display:flex; gap:12px; margin-top:44px; padding-top:22px; border-top:1px solid var(--line)}
  .pager a{
    flex:1; padding:14px 16px; border:1px solid var(--line); border-radius:12px; background:var(--panel);
    display:flex; flex-direction:column; gap:2px; box-shadow:var(--shadow);
  }
  .pager a:hover{border-color:var(--brand); text-decoration:none}
  .pager .lbl{font-size:11px; color:var(--muted); text-transform:uppercase; letter-spacing:.5px}
  .pager .ttl{font-size:14px; font-weight:600; color:var(--ink)}
  .pager .next{text-align:right}

  /* Scrollbar */
  ::-webkit-scrollbar{width:10px; height:10px}
  ::-webkit-scrollbar-thumb{background:var(--line); border-radius:8px}

  .backdrop{display:none}
  @media (max-width:860px){
    .sidebar{position:fixed; z-index:30; left:0; top:0; transform:translateX(-100%); transition:transform .25s ease}
    body.nav-open .sidebar{transform:none}
    body.nav-open .backdrop{display:block; position:fixed; inset:0; background:rgba(0,0,0,.4); z-index:20}
    .menu-btn{display:flex}
    .content{padding:24px 16px 70px}
  }
</style>
</head>
<body>
<div class="app">
  <aside class="sidebar" id="sidebar">
    <div class="brand">
      <h1>Guia de Customizacao</h1>
      <p>L2J Mobius - Interlude</p>
    </div>
    <div class="search"><input id="search" type="search" placeholder="Filtrar secoes..." autocomplete="off"></div>
    <nav id="nav">
@@NAV@@
    </nav>
  </aside>

  <div class="backdrop" id="backdrop"></div>

  <div class="main">
    <div class="topbar">
      <button class="icon-btn menu-btn" id="menuBtn" title="Menu">&#9776;</button>
      <div class="crumb"><b id="crumb">Inicio</b></div>
      <button class="icon-btn" id="themeBtn" title="Tema claro/escuro">&#9788;</button>
    </div>
    <article class="content" id="content"></article>
  </div>
</div>

<!-- Conteudo bruto dos .md -->
@@SECTIONS@@

<script src="https://cdn.jsdelivr.net/npm/marked@11.1.1/marked.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/highlight.js/11.9.0/highlight.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/mermaid@10.9.0/dist/mermaid.min.js"></script>
<script>
  const DOCS = [
@@DOCLIST@@
  ];
  const content = document.getElementById('content');
  const crumb = document.getElementById('crumb');

  function slug(s){
    return s.toLowerCase().trim()
      .replace(/[^\p{L}\p{N}\s-]/gu,'')
      .replace(/\s+/g,'-');
  }
  function mermaidTheme(){
    return document.documentElement.getAttribute('data-theme')==='dark' ? 'dark' : 'default';
  }
  if(window.mermaid){ mermaid.initialize({ startOnLoad:false, theme:mermaidTheme(), securityLevel:'loose' }); }
  if(window.marked){ marked.setOptions({ gfm:true, breaks:false }); }

  function parseHash(){
    const h = decodeURIComponent(location.hash.slice(1));
    if(!h) return { id:'doc-00' };
    const p = h.split('::');
    return { id:p[0], anchor:p[1] };
  }

  function render(docId, anchor){
    const el = document.getElementById(docId);
    if(!el){ render('doc-00'); return; }
    content.innerHTML = window.marked ? marked.parse(el.textContent) : '<pre>'+el.textContent+'</pre>';

    // ids nas headings (github-style)
    const used = {};
    content.querySelectorAll('h1,h2,h3,h4').forEach(h=>{
      let id = slug(h.textContent);
      if(used[id]!=null){ used[id]++; id = id + '-' + used[id]; } else { used[id]=0; }
      h.id = id;
    });

    // mermaid
    content.querySelectorAll('pre code.language-mermaid').forEach(c=>{
      const div = document.createElement('div');
      div.className = 'mermaid';
      div.textContent = c.textContent;
      c.closest('pre').replaceWith(div);
    });
    if(window.mermaid){
      try{ mermaid.run({ nodes: content.querySelectorAll('.mermaid') }); }catch(e){}
    }

    // highlight
    if(window.hljs){
      content.querySelectorAll('pre code').forEach(c=>{ try{ hljs.highlightElement(c); }catch(e){} });
    }

    // nav ativa
    document.querySelectorAll('.nav-link').forEach(a=>a.classList.toggle('active', a.dataset.doc===docId));
    const meta = DOCS.find(d=>d.id===docId);
    crumb.textContent = meta ? meta.title : 'Inicio';
    document.title = (meta? meta.title+' - ' : '') + 'Guia L2J Mobius';

    addPager(docId);

    // scroll
    if(anchor){
      const t = document.getElementById(anchor);
      if(t){ t.scrollIntoView(); return; }
    }
    window.scrollTo(0,0);
    document.querySelector('.main').scrollTop = 0;
  }

  function addPager(docId){
    const i = DOCS.findIndex(d=>d.id===docId);
    if(i<0) return;
    const prev = DOCS[i-1], next = DOCS[i+1];
    const wrap = document.createElement('div'); wrap.className='pager';
    if(prev){
      const a=document.createElement('a'); a.href='#'+prev.id;
      a.innerHTML='<span class="lbl">&#8592; Anterior</span><span class="ttl">'+prev.title+'</span>';
      wrap.appendChild(a);
    } else { wrap.appendChild(document.createElement('span')); }
    if(next){
      const a=document.createElement('a'); a.href='#'+next.id; a.className='next';
      a.innerHTML='<span class="lbl">Proximo &#8594;</span><span class="ttl">'+next.title+'</span>';
      wrap.appendChild(a);
    }
    content.appendChild(wrap);
  }

  function go(docId, anchor){
    const h = anchor ? docId+'::'+anchor : docId;
    if(location.hash.slice(1) === h){ const {id,a}=parseHash(); render(docId, anchor); }
    else location.hash = h;
    document.body.classList.remove('nav-open');
  }

  // Navegacao lateral
  document.querySelectorAll('.nav-link').forEach(a=>{
    a.addEventListener('click', e=>{ e.preventDefault(); go(a.dataset.doc); });
  });

  // Links internos entre docs e ancoras
  content.addEventListener('click', e=>{
    const a = e.target.closest('a'); if(!a) return;
    const href = a.getAttribute('href'); if(!href) return;
    let m = href.match(/^(\d{2})_[^#]*\.md(?:#(.*))?$/);
    if(m){ e.preventDefault(); go('doc-'+m[1], m[2] ? decodeURIComponent(m[2]) : null); return; }
    if(href.startsWith('#') && !href.startsWith('#doc-')){
      e.preventDefault();
      const t = document.getElementById(decodeURIComponent(href.slice(1)));
      if(t) t.scrollIntoView();
    }
  });

  // Busca / filtro
  document.getElementById('search').addEventListener('input', e=>{
    const q = e.target.value.toLowerCase();
    document.querySelectorAll('.nav-link').forEach(a=>{
      a.style.display = a.textContent.toLowerCase().includes(q) ? '' : 'none';
    });
  });

  // Tema
  const themeBtn = document.getElementById('themeBtn');
  function applyTheme(t){
    document.documentElement.setAttribute('data-theme', t);
    localStorage.setItem('l2docs-theme', t);
    if(window.mermaid){ mermaid.initialize({ startOnLoad:false, theme:mermaidTheme(), securityLevel:'loose' }); }
    const cur = parseHash(); render(cur.id, cur.anchor);
  }
  themeBtn.addEventListener('click', ()=>{
    applyTheme(document.documentElement.getAttribute('data-theme')==='dark' ? 'light' : 'dark');
  });
  const saved = localStorage.getItem('l2docs-theme');
  if(saved) document.documentElement.setAttribute('data-theme', saved);

  // Menu mobile
  document.getElementById('menuBtn').addEventListener('click', ()=>document.body.classList.toggle('nav-open'));
  document.getElementById('backdrop').addEventListener('click', ()=>document.body.classList.remove('nav-open'));

  // Roteamento
  window.addEventListener('hashchange', ()=>{ const {id,anchor}=parseHash(); render(id,anchor); });
  const init = parseHash(); render(init.id, init.anchor);
</script>
</body>
</html>
'@

$html = $template.Replace('@@NAV@@', $navSb.ToString().TrimEnd())
$html = $html.Replace('@@SECTIONS@@', $secSb.ToString().TrimEnd())
$html = $html.Replace('@@DOCLIST@@', $listSb.ToString().TrimEnd())

Set-Content -Path $outFile -Value $html -Encoding UTF8
Write-Host "OK -> $outFile"
