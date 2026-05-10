const fs = require('fs');
const path = require('path');

// ===== HTML: ENCRYPTED PAGE ===== (dengan teks lebih terang)
function encryptedHtml(fileName) {
  return `<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width,initial-scale=1.0">
<title>ENCRYPTED — SILENT HUB</title>
<link href="https://fonts.googleapis.com/css2?family=Share+Tech+Mono&family=Orbitron:wght@700;900&display=swap" rel="stylesheet">
<style>
*{margin:0;padding:0;box-sizing:border-box}
:root{
  --bg:#050505;--card:#090909;--border:#1e1e1e;--border2:#2a2a2a;
  --green:#00cc77;--green2:#00ff99;
  --glow-g:0 0 10px rgba(0,204,119,.55),0 0 22px rgba(0,204,119,.18);
}
body{
  background:var(--bg);
  font-family:'Share Tech Mono',monospace;
  min-height:100vh;overflow:hidden;
  display:flex;align-items:center;justify-content:center;
}
body::before{
  content:'';position:fixed;inset:0;
  background:repeating-linear-gradient(0deg,transparent,transparent 2px,rgba(255,255,255,.012) 2px,rgba(255,255,255,.012) 4px);
  pointer-events:none;z-index:1;
}
body::after{
  content:'';position:fixed;inset:0;
  background-image:
    linear-gradient(rgba(255,255,255,.011) 1px,transparent 1px),
    linear-gradient(90deg,rgba(255,255,255,.011) 1px,transparent 1px);
  background-size:48px 48px;pointer-events:none;z-index:0;
}
.bg{position:fixed;inset:0;z-index:0;background:url('/background.png') center/cover no-repeat;opacity:.06;pointer-events:none}
#pts{position:fixed;inset:0;pointer-events:none;z-index:1}
#pts span{position:absolute;border-radius:50%;animation:rise linear infinite;opacity:0}
@keyframes rise{
  0%{transform:translateY(100vh) scale(0);opacity:0}
  8%,92%{opacity:1}
  100%{transform:translateY(-8vh) scale(1);opacity:0}
}
.vig{position:fixed;inset:0;pointer-events:none;z-index:1;background:radial-gradient(ellipse at center,transparent 45%,rgba(0,0,0,.85) 100%)}

.center{position:relative;z-index:10;width:100%;max-width:700px;padding:1.5rem}

.terminal{
  background:rgba(6,6,6,.98);
  border:1px solid #222;
  border-radius:12px;overflow:hidden;
  box-shadow:0 0 0 1px #111,0 32px 90px rgba(0,0,0,.95);
  animation:termIn .55s cubic-bezier(.16,1,.3,1) both;
}
@keyframes termIn{
  from{opacity:0;transform:translateY(28px) scale(.96)}
  to{opacity:1;transform:none}
}

.t-bar{
  background:#0e0e0e;border-bottom:1px solid #1e1e1e;
  padding:10px 14px;display:flex;align-items:center;gap:7px;position:relative;
}
.dot{width:11px;height:11px;border-radius:50%}
.dot.r{background:#ff5f56}.dot.y{background:#ffbd2e}.dot.g{background:#27c93f}
.t-bar-title{
  position:absolute;left:50%;transform:translateX(-50%);
  font-size:.58rem;color:#aaa; /* lebih terang */
  letter-spacing:2px;
}

.t-hero{
  text-align:center;padding:2rem 1.5rem 1rem;
}
.t-404{
  font-family:'Orbitron',monospace;
  font-size:4.2rem;font-weight:900;
  color:#5a5a7a; /* lebih terang dari sebelumnya */
  letter-spacing:8px;
  animation:flicker 5s infinite;line-height:1;
}
@keyframes flicker{
  0%,93%,95%,97%,100%{opacity:1}
  94%{opacity:.25}96%{opacity:.6}98%{opacity:.35}
}
.t-404-sub{
  font-family:'Orbitron',monospace;
  font-size:.72rem;font-weight:700;
  color:#aaa; /* lebih terang */
  letter-spacing:4px;margin-top:.5rem;
  animation:fadeIn .6s .5s both;
}
@keyframes fadeIn{from{opacity:0}to{opacity:1}}

.glitch-bar{
  height:1px;
  background:linear-gradient(90deg,transparent,#5a5a5a,transparent);
  animation:glitchBar 4s infinite;opacity:.8;
}
@keyframes glitchBar{
  0%,100%{transform:scaleX(0);opacity:0}
  45%,55%{transform:scaleX(1);opacity:.8}
}

.t-body{padding:1.5rem 1.8rem 2rem}
.t-line{
  display:flex;align-items:flex-start;gap:8px;
  margin-bottom:.6rem;opacity:0;
  animation:lineIn .15s ease forwards;
  font-size:.72rem;
}
@keyframes lineIn{to{opacity:1}}
.t-line:nth-child(1){animation-delay:.3s}
.t-line:nth-child(2){animation-delay:1.2s}
.t-line:nth-child(3){animation-delay:2.1s}
.t-line:nth-child(4){animation-delay:3.0s}
.t-line:nth-child(5){animation-delay:3.8s}
.t-line:nth-child(6){animation-delay:4.5s}

.t-arrow{color:#999;flex-shrink:0} /* lebih terang */
.t-typed{
  display:inline-block;overflow:hidden;white-space:nowrap;
  border-right:1px solid transparent;
}
/* semua teks di t-typed menjadi lebih terang */
.t-line:nth-child(1) .t-typed{color:#ccc;animation:lineIn .15s .3s forwards,typ .8s .3s steps(40,end) both,blink .6s .3s step-end 4}
.t-line:nth-child(2) .t-typed{color:#bbb;animation:lineIn .15s 1.2s forwards,typ .6s 1.2s steps(35,end) both,blink .6s 1.2s step-end 3}
.t-line:nth-child(3) .t-typed{color:#ccc;animation:lineIn .15s 2.1s forwards,typ 1.0s 2.1s steps(45,end) both,blink .6s 2.1s step-end 4}
.t-line:nth-child(4) .t-typed{color:#bbb;animation:lineIn .15s 3.0s forwards,typ .7s 3.0s steps(38,end) both,blink .6s 3.0s step-end 3}
.t-line:nth-child(5) .t-typed{color:#aaa;animation:lineIn .15s 3.8s forwards,typ .5s 3.8s steps(30,end) both,blink .6s 3.8s step-end 2}
.t-line:nth-child(6) .t-typed{
  color:#ccc;border-right:1px solid #aaa;
  animation:lineIn .15s 4.5s forwards,typ .8s 4.5s steps(42,end) both,blink .7s 4.5s step-end infinite
}
@keyframes typ{from{width:0}to{width:100%}}
@keyframes blink{50%{border-color:transparent}}

/* highlight line lebih terang */
.t-line.hl .t-typed{color:#00ffaa !important; text-shadow:0 0 4px #00cc77;}
.t-line.hl .t-arrow{color:#00ffaa !important;}

.t-status{
  background:#080808;border-top:1px solid #1e1e1e;
  padding:8px 16px;display:flex;align-items:center;gap:8px;
  font-size:.52rem;color:#aaa;letter-spacing:1.5px;
}
.s-dot-g{
  width:5px;height:5px;border-radius:50%;
  background:var(--green);box-shadow:var(--glow-g);
  animation:blinkG .9s infinite;
}
@keyframes blinkG{50%{opacity:.1;box-shadow:none}}
</style>
</head>
<body>
<div class="bg"></div>
<div class="vig"></div>
<div id="pts"></div>

<div class="center">
  <div class="terminal">

    <div class="t-bar">
      <span class="dot r"></span><span class="dot y"></span><span class="dot g"></span>
      <span class="t-bar-title">silent-hub.js — bash — 80×24</span>
    </div>

    <div class="t-hero">
      <div class="t-404">ENCRYPT</div>
      <div class="t-404-sub">// ACCESS DENIED //</div>
    </div>

    <div class="glitch-bar"></div>

    <div class="t-body">
      <div class="t-line"><span class="t-arrow">&gt;</span><span class="t-typed">Initializing secure environment...</span></div>
      <div class="t-line"><span class="t-arrow">&gt;</span><span class="t-typed">FILE: ${fileName}.lua — STATUS: [██████████] ENCRYPTED</span></div>
      <div class="t-line hl"><span class="t-arrow">&gt;</span><span class="t-typed">ACCESS_LEVEL: UNAUTHORIZED — PERMISSION DENIED</span></div>
      <div class="t-line"><span class="t-arrow">&gt;</span><span class="t-typed">This file is protected by Silent Hub encryption layer.</span></div>
      <div class="t-line"><span class="t-arrow">&gt;</span><span class="t-typed">Direct browser access is not permitted.</span></div>
      <div class="t-line hl"><span class="t-arrow">&gt;</span><span class="t-typed">USE EXECUTOR LOADSTRING TO ACCESS THIS FILE_</span></div>
    </div>

    <div class="t-status">
      <span class="s-dot-g"></span>
      <span>ENCRYPTED</span>
      <span style="margin-left:8px;color:#888">${fileName}.lua</span>
      <span style="margin-left:auto;color:#888">SILENT HUB v2.0</span>
    </div>

  </div>
</div>

<script>
const c=document.getElementById('pts');
for(let i=0;i<38;i++){
  const p=document.createElement('span');
  const sz=Math.random()*2+.6;
  p.style.cssText='width:'+sz+'px;height:'+sz+'px;left:'+(Math.random()*100)+'%;background:#1e1e1e;animation-duration:'+(Math.random()*18+10)+'s;animation-delay:'+(Math.random()*12)+'s;';
  c.appendChild(p);
}
<\/script>
</body>
</html>`;
}

// ===== HTML: NOT FOUND PAGE ===== (dengan teks lebih terang)
function notFoundHtml(fileName) {
  return `<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width,initial-scale=1.0">
<title>404 NOT FOUND — SILENT HUB</title>
<link href="https://fonts.googleapis.com/css2?family=Share+Tech+Mono&family=Orbitron:wght@700;900&display=swap" rel="stylesheet">
<style>
*{margin:0;padding:0;box-sizing:border-box}
:root{
  --bg:#050505;--border:#1e1e1e;
  --red:#cc2233;--red2:#ff3344;
  --glow-r:0 0 10px rgba(204,34,51,.55),0 0 22px rgba(204,34,51,.18);
}
body{background:var(--bg);font-family:'Share Tech Mono',monospace;min-height:100vh;overflow:hidden;display:flex;align-items:center;justify-content:center}
body::before{content:'';position:fixed;inset:0;background:repeating-linear-gradient(0deg,transparent,transparent 2px,rgba(255,255,255,.012) 2px,rgba(255,255,255,.012) 4px);pointer-events:none;z-index:1}
body::after{content:'';position:fixed;inset:0;background-image:linear-gradient(rgba(255,255,255,.011) 1px,transparent 1px),linear-gradient(90deg,rgba(255,255,255,.011) 1px,transparent 1px);background-size:48px 48px;pointer-events:none;z-index:0}
.bg{position:fixed;inset:0;z-index:0;background:url('/background.png') center/cover no-repeat;opacity:.06;pointer-events:none}
.vig{position:fixed;inset:0;pointer-events:none;z-index:1;background:radial-gradient(ellipse at center,transparent 45%,rgba(0,0,0,.85) 100%)}
#pts{position:fixed;inset:0;pointer-events:none;z-index:1}
#pts span{position:absolute;border-radius:50%;animation:rise linear infinite;opacity:0}
@keyframes rise{0%{transform:translateY(100vh) scale(0);opacity:0}8%,92%{opacity:1}100%{transform:translateY(-8vh) scale(1);opacity:0}}

.center{position:relative;z-index:10;width:100%;max-width:700px;padding:1.5rem}
.terminal{background:rgba(6,6,6,.98);border:1px solid #222;border-radius:12px;overflow:hidden;box-shadow:0 0 0 1px #111,0 32px 90px rgba(0,0,0,.95);animation:termIn .55s cubic-bezier(.16,1,.3,1) both}
@keyframes termIn{from{opacity:0;transform:translateY(28px) scale(.96)}to{opacity:1;transform:none}}

.t-bar{background:#0e0e0e;border-bottom:1px solid #1e1e1e;padding:10px 14px;display:flex;align-items:center;gap:7px;position:relative}
.dot{width:11px;height:11px;border-radius:50%}
.dot.r{background:#ff5f56}.dot.y{background:#ffbd2e}.dot.g{background:#27c93f}
.t-bar-title{position:absolute;left:50%;transform:translateX(-50%);font-size:.58rem;color:#aaa;letter-spacing:2px}

.t-hero{text-align:center;padding:2rem 1.5rem 1rem}
.t-404{font-family:'Orbitron',monospace;font-size:5rem;font-weight:900;color:#6a4a5a;letter-spacing:8px;animation:flicker 5s infinite;line-height:1}
@keyframes flicker{0%,93%,95%,97%,100%{opacity:1}94%{opacity:.25}96%{opacity:.6}98%{opacity:.35}}
.t-404-sub{font-family:'Orbitron',monospace;font-size:.72rem;font-weight:700;color:#aaa;letter-spacing:4px;margin-top:.5rem;animation:fadeIn .6s .5s both}
@keyframes fadeIn{from{opacity:0}to{opacity:1}}

.glitch-bar{height:1px;background:linear-gradient(90deg,transparent,rgba(204,34,51,.45),transparent);animation:gb 4s infinite;opacity:.9}
@keyframes gb{0%,100%{transform:scaleX(0);opacity:0}45%,55%{transform:scaleX(1);opacity:.9}}

.t-body{padding:1.5rem 1.8rem 2rem}
.t-line{display:flex;align-items:flex-start;gap:8px;margin-bottom:.6rem;opacity:0;animation:lineIn .15s ease forwards;font-size:.72rem}
@keyframes lineIn{to{opacity:1}}
.t-line:nth-child(1){animation-delay:.3s}
.t-line:nth-child(2){animation-delay:1.2s}
.t-line:nth-child(3){animation-delay:2.1s}
.t-line:nth-child(4){animation-delay:3.0s}
.t-line:nth-child(5){animation-delay:3.8s}

.t-arrow{color:#999;flex-shrink:0}
.t-typed{display:inline-block;overflow:hidden;white-space:nowrap;border-right:1px solid transparent}

/* semua teks di t-typed jadi lebih terang */
.t-line:nth-child(1) .t-typed{color:#ccc;animation:lineIn .15s .3s forwards,typ .8s .3s steps(40,end) both,blink .6s .3s step-end 4}
.t-line:nth-child(2) .t-typed{color:#bbb;animation:lineIn .15s 1.2s forwards,typ .6s 1.2s steps(35,end) both,blink .6s 1.2s step-end 3}
.t-line:nth-child(3) .t-typed{color:#ffaa99;animation:lineIn .15s 2.1s forwards,typ 1.0s 2.1s steps(45,end) both,blink .6s 2.1s step-end 4}
.t-line:nth-child(4) .t-typed{color:#bbb;animation:lineIn .15s 3.0s forwards,typ .7s 3.0s steps(38,end) both,blink .6s 3.0s step-end 3}
.t-line:nth-child(5) .t-typed{color:#ff8899;border-right:1px solid #ff8899;animation:lineIn .15s 3.8s forwards,typ .8s 3.8s steps(42,end) both,blink .7s 3.8s step-end infinite}

.t-line:nth-child(3) .t-arrow,.t-line:nth-child(5) .t-arrow{color:#ff7788}

@keyframes typ{from{width:0}to{width:100%}}
@keyframes blink{50%{border-color:transparent}}

.t-status{background:#080808;border-top:1px solid #1e1e1e;padding:8px 16px;display:flex;align-items:center;gap:8px;font-size:.52rem;color:#aaa;letter-spacing:1.5px}
.s-dot-r{width:5px;height:5px;border-radius:50%;background:var(--red2);box-shadow:var(--glow-r);animation:blinkR .9s infinite}
@keyframes blinkR{50%{opacity:.1;box-shadow:none}}
</style>
</head>
<body>
<div class="bg"></div>
<div class="vig"></div>
<div id="pts"></div>

<div class="center">
  <div class="terminal">
    <div class="t-bar">
      <span class="dot r"></span><span class="dot y"></span><span class="dot g"></span>
      <span class="t-bar-title">silent-hub.js — bash — 80×24</span>
    </div>
    <div class="t-hero">
      <div class="t-404">404</div>
      <div class="t-404-sub">// FILE NOT FOUND //</div>
    </div>
    <div class="glitch-bar"></div>
    <div class="t-body">
      <div class="t-line"><span class="t-arrow">&gt;</span><span class="t-typed">Resolving path in repository...</span></div>
      <div class="t-line"><span class="t-arrow">&gt;</span><span class="t-typed">SCANNING: /scripts/${fileName}.lua</span></div>
      <div class="t-line"><span class="t-arrow">&gt;</span><span class="t-typed">ERROR: FILE NOT FOUND IN REPOSITORY</span></div>
      <div class="t-line"><span class="t-arrow">&gt;</span><span class="t-typed">STATUS: [░░░░░░░░░░] 0% — NOT FOUND</span></div>
      <div class="t-line"><span class="t-arrow">&gt;</span><span class="t-typed">Check URL or contact admin at discord.gg/YxGgy9MYe_</span></div>
    </div>
    <div class="t-status">
      <span class="s-dot-r"></span>
      <span>NOT FOUND</span>
      <span style="margin-left:8px;color:#888">${fileName}.lua</span>
      <span style="margin-left:auto;color:#888">SILENT HUB v2.0</span>
    </div>
  </div>
</div>

<script>
const c=document.getElementById('pts');
for(let i=0;i<38;i++){
  const p=document.createElement('span');
  const sz=Math.random()*2+.6;
  p.style.cssText='width:'+sz+'px;height:'+sz+'px;left:'+(Math.random()*100)+'%;background:#1e1e1e;animation-duration:'+(Math.random()*18+10)+'s;animation-delay:'+(Math.random()*12)+'s;';
  c.appendChild(p);
}
<\/script>
</body>
</html>`;
}

// ===== MAIN HANDLER ===== (tidak berubah)
module.exports = function handler(req, res) {
  const { file } = req.query;

  const safe = (file || '').replace(/[^a-zA-Z0-9_]/g, '');

  if (!safe) {
    return res
      .status(400)
      .setHeader('Content-Type', 'text/html')
      .send(notFoundHtml('undefined'));
  }

  // cari di root (tanpa folder scripts)
  const exts = ['.lua', '.txt', ''];
  let filePath = null;

  for (const ext of exts) {
    const tryPath = path.join(process.cwd(), safe + ext);
    if (fs.existsSync(tryPath)) {
      filePath = tryPath;
      break;
    }
  }

  if (!filePath) {
    return res
      .status(404)
      .setHeader('Content-Type', 'text/html')
      .send(notFoundHtml(safe));
  }

  const accept    = req.headers['accept'] || '';
  const isBrowser = accept.includes('text/html');

  if (isBrowser) {
    return res
      .status(200)
      .setHeader('Content-Type', 'text/html')
      .send(encryptedHtml(safe));
  }

  const content = fs.readFileSync(filePath, 'utf8');
  return res
    .status(200)
    .setHeader('Content-Type', 'text/plain; charset=utf-8')
    .setHeader('Access-Control-Allow-Origin', '*')
    .setHeader('Cache-Control', 'no-cache')
    .send(content);
};
