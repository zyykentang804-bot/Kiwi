export default function handler(req, res) {
  const { file } = req.query;
  const safe = (file || '').replace(/[^a-zA-Z0-9_]/g, '');
  const fs = require('fs');
  const path = require('path');
  const filePath = path.join(process.cwd(), 'scripts', safe + '.lua');

  if (!safe || !fs.existsSync(filePath)) {
    // Return HTML 404 page
    res.status(404).setHeader('Content-Type', 'text/html').send(`<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width,initial-scale=1.0">
<title>404 — Encrypted</title>
<link href="https://fonts.googleapis.com/css2?family=Share+Tech+Mono&family=Orbitron:wght@700;900&display=swap" rel="stylesheet">
<style>
*{margin:0;padding:0;box-sizing:border-box}
body{
  background:#050505;
  font-family:'Share Tech Mono',monospace;
  min-height:100vh;overflow:hidden;
  display:flex;align-items:center;justify-content:center;
}

/* background.png full cover */
body::before{
  content:'';position:fixed;inset:0;
  background:url('/background.png') center center / cover no-repeat;
  opacity:.13;pointer-events:none;z-index:0;
}

/* scanlines */
body::after{
  content:'';position:fixed;inset:0;
  background:repeating-linear-gradient(
    0deg,transparent,transparent 2px,
    rgba(255,255,255,.025) 2px,rgba(255,255,255,.025) 4px
  );
  pointer-events:none;z-index:1;
}

/* grid */
.grid-bg{
  position:fixed;inset:0;z-index:0;
  background-image:
    linear-gradient(rgba(255,255,255,.018) 1px,transparent 1px),
    linear-gradient(90deg,rgba(255,255,255,.018) 1px,transparent 1px);
  background-size:44px 44px;
}

/* particles */
#pts{position:fixed;inset:0;pointer-events:none;z-index:1}
#pts span{
  position:absolute;border-radius:50%;
  animation:rise linear infinite;opacity:0;
}
@keyframes rise{
  0%{transform:translateY(100vh);opacity:0}
  10%,90%{opacity:1}
  100%{transform:translateY(-8vh);opacity:0}
}

.center{position:relative;z-index:10;width:100%;max-width:740px;padding:1.5rem}

/* ---- TERMINAL WINDOW ---- */
.terminal{
  background:rgba(6,6,6,.97);
  border:1px solid #1e1e1e;
  border-radius:12px;
  overflow:hidden;
  box-shadow:0 0 0 1px #111,0 28px 80px rgba(0,0,0,.9);
  animation:termIn .6s cubic-bezier(.16,1,.3,1) both;
}
@keyframes termIn{
  from{opacity:0;transform:translateY(30px) scale(.96)}
  to{opacity:1;transform:translateY(0) scale(1)}
}

/* terminal header */
.t-header{
  background:#0c0c0c;
  border-bottom:1px solid #1a1a1a;
  padding:10px 14px;
  display:flex;align-items:center;gap:7px;
  position:relative;
}
.t-dot{width:11px;height:11px;border-radius:50%}
.t-dot.r{background:#ff5f56}.t-dot.y{background:#ffbd2e}.t-dot.g{background:#27c93f}
.t-title-center{
  position:absolute;left:50%;transform:translateX(-50%);
  font-family:'Share Tech Mono',monospace;
  font-size:.6rem;color:#333;letter-spacing:2px;
}
.t-dots-right{margin-left:auto;display:flex;gap:5px}

/* 404 big title */
.err-title{
  font-family:'Orbitron',monospace;
  font-size:5rem;font-weight:900;
  color:#1a1a1a;
  text-align:center;
  padding:2rem 1rem .5rem;
  letter-spacing:8px;
  text-shadow:0 0 60px rgba(255,255,255,.04);
  animation:flicker 4s infinite;
  line-height:1;
}
@keyframes flicker{
  0%,94%,96%,98%,100%{opacity:1}
  95%{opacity:.3}97%{opacity:.7}99%{opacity:.4}
}
.err-sub{
  font-family:'Orbitron',monospace;
  font-size:.75rem;font-weight:700;
  color:#333;text-align:center;
  letter-spacing:4px;margin-bottom:1.8rem;
  animation:fadeIn .8s .4s both;
}
@keyframes fadeIn{from{opacity:0}to{opacity:1}}

/* terminal body */
.t-body{
  padding:1.4rem 1.6rem 1.8rem;
  border-top:1px solid #111;
}

/* typing lines */
.line{
  display:flex;align-items:flex-start;gap:0;
  margin-bottom:.55rem;
  opacity:0;
  animation:lineIn .15s ease forwards;
  white-space:pre-wrap;
  word-break:break-all;
}
@keyframes lineIn{to{opacity:1}}

.prompt{color:#252525;font-size:.72rem;margin-right:0;flex-shrink:0}
.typed{
  font-size:.72rem;line-height:1.7;
  display:inline-block;overflow:hidden;
  white-space:nowrap;
  border-right:2px solid transparent;
}
/* each line has its own typing animation */
.line:nth-child(1) .typed{
  animation:lineIn .15s .3s forwards, typing1 .9s .3s steps(40,end) both, blink .7s .3s step-end 4;
  color:#cc2233;
}
.line:nth-child(2) .typed{
  animation:lineIn .15s 1.4s forwards, typing2 .6s 1.4s steps(35,end) both, blink .7s 1.4s step-end 3;
  color:#444;
}
.line:nth-child(3) .typed{
  animation:lineIn .15s 2.2s forwards, typing3 1.1s 2.2s steps(50,end) both, blink .7s 2.2s step-end 5;
  color:#cc2233;
}
.line:nth-child(4) .typed{
  animation:lineIn .15s 3.5s forwards, typing4 .7s 3.5s steps(40,end) both, blink .7s 3.5s step-end 3;
  color:#444;
}
.line:nth-child(5) .typed{
  animation:lineIn .15s 4.4s forwards, typing5 .5s 4.4s steps(30,end) both, blink .7s 4.4s step-end 2;
  color:#1a1a1a;
}
.line:nth-child(6) .typed{
  animation:lineIn .15s 5.1s forwards, typing6 .9s 5.1s steps(45,end) both, blink .8s 5.1s step-end infinite;
  color:#2a2a2a;
  border-right:2px solid #333;
}

@keyframes blink{50%{border-color:transparent}}

/* typing widths per line */
@keyframes typing1{from{width:0}to{width:100%}}
@keyframes typing2{from{width:0}to{width:100%}}
@keyframes typing3{from{width:0}to{width:100%}}
@keyframes typing4{from{width:0}to{width:100%}}
@keyframes typing5{from{width:0}to{width:100%}}
@keyframes typing6{from{width:0}to{width:100%}}

/* line nth delays */
.line:nth-child(1){animation-delay:.3s}
.line:nth-child(2){animation-delay:1.4s}
.line:nth-child(3){animation-delay:2.2s}
.line:nth-child(4){animation-delay:3.5s}
.line:nth-child(5){animation-delay:4.4s}
.line:nth-child(6){animation-delay:5.1s}

/* status bar bottom */
.t-status{
  background:#080808;border-top:1px solid #111;
  padding:7px 16px;
  display:flex;align-items:center;gap:8px;
  font-size:.52rem;color:#222;letter-spacing:1.5px;
}
.s-dot-r{
  width:6px;height:6px;border-radius:50%;
  background:#cc2233;
  box-shadow:0 0 8px rgba(204,34,51,.7);
  animation:blinkR .9s infinite;
}
@keyframes blinkR{50%{opacity:.1;box-shadow:none}}
.s-dot-g{
  width:6px;height:6px;border-radius:50%;
  background:#00cc77;
  box-shadow:0 0 8px rgba(0,204,119,.7);
  animation:blinkG 1.3s infinite;
}
@keyframes blinkG{50%{opacity:.1;box-shadow:none}}
.t-status span{margin-left:auto;color:#1a1a1a}

/* glitch bar */
.glitch-bar{
  height:2px;
  background:linear-gradient(90deg,transparent,#cc2233,transparent);
  animation:glitchBar 3s infinite;
  opacity:.5;
}
@keyframes glitchBar{
  0%,100%{transform:scaleX(0);opacity:0}
  50%{transform:scaleX(1);opacity:.5}
}
</style>
</head>
<body>
<div class="grid-bg"></div>
<div id="pts"></div>

<div class="center">
  <div class="terminal">

    <!-- header -->
    <div class="t-header">
      <span class="t-dot r"></span>
      <span class="t-dot y"></span>
      <span class="t-dot g"></span>
      <span class="t-title-center">masgal.js — bash — 80×24</span>
      <div class="t-dots-right">
        <span style="width:8px;height:8px;border-radius:50%;background:#1a1a1a;display:inline-block"></span>
        <span style="width:8px;height:8px;border-radius:50%;background:#1a1a1a;display:inline-block"></span>
      </div>
    </div>

    <!-- 404 title -->
    <div class="err-title">404</div>
    <div class="err-sub">// ACCESS DENIED //</div>

    <!-- glitch bar -->
    <div class="glitch-bar"></div>

    <!-- body: typing lines -->
    <div class="t-body">

      <div class="line">
        <span class="prompt">&gt;&nbsp;</span>
        <span class="typed">localhost("masgal.js") = FILE SUDAH TERENCRYPT</span>
      </div>

      <div class="line">
        <span class="prompt">&gt;&nbsp;</span>
        <span class="typed">STATUS: [██████████] 100% — LOCKED</span>
      </div>

      <div class="line">
        <span class="prompt">&gt;&nbsp;</span>
        <span class="typed">localhost("masgal.js") = FILE IS ALREADY ENCRYPTED</span>
      </div>

      <div class="line">
        <span class="prompt">&gt;&nbsp;</span>
        <span class="typed">ACCESS_LEVEL: UNAUTHORIZED — PERMISSION DENIED</span>
      </div>

      <div class="line">
        <span class="prompt">&gt;&nbsp;</span>
        <span class="typed">· · · · · · · · · · · · · · · · · · · ·</span>
      </div>

      <div class="line">
        <span class="prompt">&gt;&nbsp;</span>
        <span class="typed">USE EXECUTOR LOADSTRING TO ACCESS_</span>
      </div>

    </div>

    <!-- status bar -->
    <div class="t-status">
      <span class="s-dot-r"></span>
      <span>ENCRYPTED</span>
      <span class="s-dot-g" style="margin-left:12px"></span>
      <span>masgal.js</span>
      <span>v2.0 — SILENT HUB</span>
    </div>

  </div>
</div>

<script>
// particles
const c = document.getElementById('pts');
for(let i=0;i<40;i++){
  const p = document.createElement('span');
  const sz = Math.random()*2+.8;
  p.style.cssText = \`
    width:\${sz}px;height:\${sz}px;
    left:\${Math.random()*100}%;
    background:\${Math.random()>.5?'#1e1e1e':'#161616'};
    animation-duration:\${Math.random()*18+10}s;
    animation-delay:\${Math.random()*12}s;
  \`;
  c.appendChild(p);
}
</script>
</body>
</html>`);
    return;
  }

  const content = fs.readFileSync(filePath, 'utf8');
  res.status(200)
    .setHeader('Content-Type', 'text/plain')
    .setHeader('Access-Control-Allow-Origin', '*')
    .send(content);
}
