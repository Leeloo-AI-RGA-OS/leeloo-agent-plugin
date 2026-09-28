# Шаблони частин (повні скелети)

Копіюй скелет цілком, заміняй текст у `[КВАДРАТНИХ ДУЖКАХ]`, підставляй ассети через
`{{asset:…}}` / `{{msgr-bar}}` / `{{logos:…}}`, прибирай непотрібні блоки. Далі —
`python scripts/build_lgt.py`.

Зміст: A · part 1 dark (hero) · B · відмінності part 1 light · C · part N скоуп-скелет ·
D · part N чекліст · E · part N відео-фасад · F · part N відгуки

---

## A. Частина 1 — DARK hero

```html
<!DOCTYPE html>
<html lang="[uk|ru|en]">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<meta name="robots" content="noindex,nofollow">
<title>[Бренд] — [оффер] · Частина 1</title>
<link rel="preconnect" href="https://fonts.googleapis.com"><link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Jost:wght@500;700;800&family=Montserrat:wght@600;700;800&family=Inter:wght@400;500;600;700&family=JetBrains+Mono:wght@500;700&display=swap" rel="stylesheet">
<style>
:root{
  --obsidian:#070A14; --surface:#0E1B3D; --raised:#141A30;
  --glass:rgba(255,255,255,.03); --glass-2:rgba(255,255,255,.055); --glass-hi:rgba(255,255,255,.09);
  --brd:rgba(255,255,255,.10); --brd-soft:rgba(255,255,255,.07);
  --accent:#F7B32B; --accent-2:#FFD24D; --second:#2D5BDF; --second-lt:#6E92F5; --third:#8B5CF6; --ok:#34C7B5;
  --ink-0:#FFFFFF; --ink-1:#EBEBEB; --ink-2:rgba(235,235,235,.6); --ink-3:rgba(235,235,235,.3);
  --f-head:'Montserrat',system-ui,sans-serif; --f-disp:'Jost',system-ui,sans-serif;
  --f-body:'Inter',system-ui,sans-serif; --f-mono:'JetBrains Mono',ui-monospace,monospace;
  --r-pill:100px; --spec:inset 0 1px 0 rgba(255,255,255,.14); --blur:blur(16px) saturate(150%);
  --host-gap:28px;
}
*{margin:0;padding:0;box-sizing:border-box}
html,body{margin:0!important;padding:0!important;background:var(--obsidian)}
html{scroll-behavior:smooth}
body{color:var(--ink-1);font-family:var(--f-body);font-size:16px;line-height:1.55;-webkit-font-smoothing:antialiased;overflow-x:hidden}
.page{position:relative;background:var(--obsidian);min-height:100vh;overflow:hidden;width:100%;margin-top:calc(-1 * var(--host-gap))}
.page::before{content:"";position:absolute;inset:0;z-index:0;pointer-events:none;
  background-image:linear-gradient(rgba(255,255,255,.035) 1px,transparent 1px),linear-gradient(90deg,rgba(255,255,255,.035) 1px,transparent 1px);
  background-size:60px 60px;
  -webkit-mask-image:radial-gradient(120% 80% at 50% 0%,#000 30%,transparent 80%);mask-image:radial-gradient(120% 80% at 50% 0%,#000 30%,transparent 80%)}
.page::after{content:"";position:absolute;inset:0;z-index:0;pointer-events:none;opacity:.5;
  background:
    radial-gradient(40% 26% at 14% 4%, rgba(247,179,43,.16), transparent 70%),   /* accent  */
    radial-gradient(46% 30% at 88% 10%, rgba(45,91,223,.30), transparent 72%),   /* second  */
    radial-gradient(42% 28% at 80% 90%, rgba(139,92,246,.20), transparent 72%);  /* third   */
  filter:blur(40px)}
.noise{position:absolute;inset:0;z-index:0;pointer-events:none;opacity:.15;mix-blend-mode:overlay;
  background-image:url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='160' height='160'%3E%3Cfilter id='n'%3E%3CfeTurbulence type='fractalNoise' baseFrequency='0.85' numOctaves='2'/%3E%3C/filter%3E%3Crect width='100%25' height='100%25' filter='url(%23n)'/%3E%3C/svg%3E")}
h1,h2,h3{font-family:var(--f-head);color:var(--ink-0);letter-spacing:-.04em;line-height:1.04}
img,video{max-width:100%;display:block}
.app{max-width:560px;margin:0 auto;padding:0 14px 14px;position:relative;z-index:1}
.brandbar{display:flex;justify-content:center;padding:calc(var(--host-gap) + 6px) 0 2px}
.brandbar svg,.brandbar img{height:21px;width:auto}
.shell{margin-top:8px;border-radius:1.8rem;padding:16px 16px 18px;position:relative;overflow:hidden;
  background:linear-gradient(180deg,rgba(14,27,61,.5),rgba(10,14,31,.6));
  border:1px solid var(--brd);box-shadow:var(--spec),0 40px 100px -50px rgba(0,0,0,.9);
  backdrop-filter:var(--blur);-webkit-backdrop-filter:var(--blur)}
@supports not (backdrop-filter:blur(1px)){.shell{background:rgba(14,18,38,.95)}}
.shell::before{content:"";position:absolute;top:0;left:10%;right:10%;height:1px;background:linear-gradient(90deg,transparent,rgba(255,255,255,.4),transparent)}
.tag{display:inline-flex;align-items:center;gap:8px;font-family:var(--f-mono);font-size:9px;letter-spacing:.22em;text-transform:uppercase;color:var(--ink-2);
  padding:6px 12px;border-radius:var(--r-pill);background:var(--glass-2);border:1px solid var(--brd-soft);box-shadow:var(--spec)}
.tag .dot{width:6px;height:6px;border-radius:50%;background:var(--accent);box-shadow:0 0 0 4px rgba(247,179,43,.18),0 0 12px rgba(247,179,43,.8);animation:pulse 2s infinite}
@keyframes pulse{0%,100%{opacity:1;transform:scale(1)}50%{opacity:.4;transform:scale(.7)}}
@media(prefers-reduced-motion:reduce){.tag .dot{animation:none}}
h1.hero{font-size:clamp(23px,6.6vw,34px);font-weight:800;line-height:1.1;margin:11px 0 6px;padding-right:.06em}
h1.hero .grad{background:linear-gradient(96deg,var(--accent-2) 0%,#fff 55%,var(--second-lt) 100%);-webkit-background-clip:text;background-clip:text;color:transparent;font-style:italic;font-family:var(--f-disp);
  -webkit-box-decoration-break:clone;box-decoration-break:clone;padding:.02em .16em .04em 0}
h1.hero .tail{font-size:.62em;font-weight:600;color:rgba(235,235,235,.6);font-family:var(--f-body);letter-spacing:0}
h1.hero .tail .num{font-family:var(--f-disp);font-weight:700;white-space:nowrap}
.vwrap{position:relative;margin-top:34px}
.msgr-bar{position:absolute;right:0;bottom:100%;margin-bottom:-1px;z-index:4}
.msgr-bar img{height:24px;width:auto;display:block;filter:drop-shadow(0 3px 8px rgba(0,0,0,.6))}
.vframe{border-radius:1.1rem;overflow:hidden;background:rgba(7,8,16,.7);border:1px solid var(--brd);box-shadow:var(--spec),0 30px 70px -30px rgba(0,0,0,.85)}
.vframe video{width:100%;height:auto;display:block;object-fit:contain}
.vframe img{width:100%;aspect-ratio:16/10;height:auto;display:block;object-fit:cover;background:rgba(255,255,255,.04)}
.vcap{text-align:center;font-family:var(--f-mono);font-size:9px;letter-spacing:.08em;color:var(--ink-3);text-transform:uppercase;margin-top:7px}
.chips{display:flex;gap:8px;flex-wrap:wrap;justify-content:center;margin-top:11px}
.chip{font-size:12.5px;font-weight:600;color:var(--ink-1);padding:8px 16px;border-radius:var(--r-pill);background:var(--glass-2);border:1px solid var(--brd-soft)}
.subproof{margin-top:13px;font-size:11.5px;color:var(--ink-2);line-height:1.4;text-align:center}
.subproof b{color:var(--ink-1)}
.logos{margin-top:10px;overflow:hidden;border-radius:1.1rem;background:rgba(255,255,255,.03);border:1px solid var(--brd-soft);padding:14px 0;
  -webkit-mask-image:linear-gradient(90deg,transparent,#000 8%,#000 92%,transparent);mask-image:linear-gradient(90deg,transparent,#000 8%,#000 92%,transparent)}
.logos-tr{display:flex;align-items:center;width:max-content;animation:lsc 42s linear infinite}
.logos-tr img{height:26px;width:auto;margin:0 18px;object-fit:contain;transition:filter .3s,opacity .3s}
.logos-tr img.mono{filter:brightness(0) invert(.72);opacity:.95}
.logos-tr img.mono:hover{filter:brightness(0) invert(1);opacity:1}
.logos-tr img.orig{filter:none;opacity:1}
@keyframes lsc{from{transform:translateX(0)}to{transform:translateX(-50%)}}
@media(prefers-reduced-motion:reduce){.logos-tr{animation:none;transform:translateX(-50%)}}
.getlist{margin-top:14px}
.getlist .gh{text-align:center;font-size:13.5px;font-weight:700;color:var(--ink-0);line-height:1.35;margin-bottom:9px}
.getlist .gh b{color:var(--accent)}
.getlist ol{list-style:none;display:flex;flex-direction:column;gap:7px}
.getlist li{position:relative;padding-left:28px;font-size:12.5px;color:var(--ink-1);line-height:1.38}
.getlist li b{color:#fff;font-weight:600}
.getlist li .q{color:rgba(235,235,235,.5)}
.getlist li .n{position:absolute;left:0;top:0;width:20px;height:20px;border-radius:50%;display:grid;place-items:center;font-family:var(--f-mono);font-size:10px;font-weight:700;color:#0A0E1F;background:linear-gradient(180deg,var(--accent-2),var(--accent))}
</style>
</head>
<body>
<div class="page">
  <div class="noise"></div>
  <div class="app">
    <div class="brandbar">{{asset:logo.svg|fill=#FFFFFF}}</div>
    <div class="shell">
      <span class="tag"><span class="dot"></span>[КАТЕГОРІЯ ПРОПОЗИЦІЇ, ДО 45 СИМВОЛІВ]</span>
      <h1 class="hero">[Результат за термін],<span class="grad"> [ключова обіцянка 5–9 слів]</span> <span class="tail"><span class="num">[масштаб / ціна]</span>, [гарантія]</span></h1>

      <div class="vwrap">
        <div class="msgr-bar"><img src="{{msgr-bar}}" alt="WhatsApp, Messenger, Instagram, Telegram, Viber, SMS, Apple, Google, Gmail — 24/7/365"></div>
        <div class="vframe">
          <video muted loop playsinline autoplay preload="metadata" poster="[URL_POSTER]" aria-label="[Демо бренду]">
            <source src="[URL_MP4]" type="video/mp4">
          </video>
          <!-- або картинка: <img src="{{asset:hero.webp}}" alt=""> -->
        </div>
      </div>
      <div class="vcap">[Крок 1] → [Крок 2] → [Крок 3] → [Крок 4] → [Результат]</div>

      <div class="chips">
        <span class="chip">[зняття заперечення 1]</span>
        <span class="chip">[зняття заперечення 2]</span>
      </div>

      <div class="subproof">[З РОКУ] перевірено на <b>[N+ клієнтах/проєктах]</b> у [N] містах/країнах, <b>[ще одна цифра]</b></div>
      <div class="logos"><div class="logos-tr">{{logos:l1.png,l2.png,l3.png,l4.png,l5.png,l6.png|mono}}</div></div>

      <div class="getlist">
        <div class="gh">👇 Залишайте заявку, щоб отримати <b>[за 24 години / безкоштовно]</b>:</div>
        <ol>
          <li><span class="n">1</span>[Найцінніше й безкоштовне: <b>що саме</b>] <span class="q">[зазвичай $X]</span></li>
          <li><span class="n">2</span><b>[Друга цінність]</b> <span class="q">[умова/термін]</span></li>
          <li><span class="n">3</span>[Третя цінність — кейси, приклади, бонус]</li>
        </ol>
      </div>
    </div>
  </div>
</div>
<script>document.querySelectorAll('video[autoplay]').forEach(v=>v.play().catch(()=>{}));</script>
</body>
</html>
```

Якщо бренд-акцент не золотий — перерахуй **чотири rgba**, що дублюють `--accent`:
crapка `.tag .dot` (2 тіні), glow-пляма `.page::after` (1-й градієнт), і за потреби
`.getlist li .n` (там `var()` — нічого міняти).

---

## B. Частина 1 — LIGHT: що змінюється відносно A

Заміни блок `:root` і перелічені правила; решта розмітки — та сама.

```css
:root{
  --bg:#F5F6F8; --card:#FFFFFF;
  --ink-0:#0A0E1F; --ink-1:#1D1D1F; --ink-2:#5B6472; --ink-3:#9AA3B2;
  --brd:rgba(10,14,31,.10); --brd-soft:rgba(10,14,31,.06);
  --navy:#0E1B3D; --second:#2D5BDF; --second-lt:#5C82EE; --third:#6B3FA0;
  --accent:#F7B32B; --accent-2:#FFD24D;
  --f-head:'Montserrat',system-ui,sans-serif; --f-disp:'Jost',system-ui,sans-serif;
  --f-body:'Inter',system-ui,sans-serif; --f-mono:'JetBrains Mono',ui-monospace,monospace;
  --r-pill:100px;
  --sh-card:0 1px 2px rgba(16,27,61,.05),0 14px 36px -16px rgba(16,27,61,.18);
  --sh-soft:0 2px 8px rgba(16,27,61,.06),0 36px 70px -34px rgba(16,27,61,.30);
  --host-gap:28px;
}
/* .adaptive-container{top:-60px}  — спосіб B: додавати лише якщо --host-gap:60px не прибрав щілину (див. host-integration.md) */
html,body{margin:0!important;padding:0!important;background:var(--bg)}
.page{position:relative;background:var(--bg);min-height:100vh;overflow:hidden;width:100%;margin-top:calc(-1 * var(--host-gap))}
/* .page::before / ::after / .noise — ВИДАЛИТИ (і <div class="noise"> з розмітки) */
.shell{margin-top:8px;border-radius:1.8rem;padding:16px 16px 18px;position:relative;overflow:hidden;background:var(--card);border:1px solid var(--brd-soft);box-shadow:var(--sh-card)}
.shell::before{content:"";position:absolute;top:0;left:12%;right:12%;height:1px;background:linear-gradient(90deg,transparent,rgba(45,91,223,.28),transparent)}
.tag{/* … */background:#fff;border:1px solid var(--brd);box-shadow:none}
.tag .dot{/* … */box-shadow:0 0 0 4px rgba(247,179,43,.18)}
h1.hero{/* … */line-height:1.08;color:var(--ink-0)}
h1.hero .grad{background:linear-gradient(96deg,var(--second) 0%,var(--third) 55%,var(--navy) 100%);/* решта як у A */}
.rate{display:inline-block;font-family:var(--f-disp);font-weight:800;font-size:clamp(16px,4.8vw,21px);color:var(--navy)}
.msgr-bar img{/* … */filter:drop-shadow(0 4px 10px rgba(16,27,61,.22))}
.vframe{border-radius:1.2rem;overflow:hidden;background:var(--card);border:1px solid var(--brd-soft);box-shadow:var(--sh-soft);padding:8px}
.vframe video,.vframe img{/* … */border-radius:.7rem}
.chip{/* … */background:#fff;border:1px solid var(--brd)}
.subproof b{color:var(--ink-0)}
.logos{/* … */background:#fff}
.logos-tr img{height:26px;width:auto;margin:0 18px;opacity:.95;object-fit:contain}   /* без .mono/.orig */
.getlist .gh b{color:var(--navy)}
.getlist li b{color:var(--ink-0)}
.getlist li .q{color:var(--ink-3)}
.getlist li .n{/* … */box-shadow:0 2px 6px rgba(247,179,43,.35)}
```
Розмітка: лого — `{{asset:logo.svg|fill=#0E1B3D}}`; `.tail` з h1 винести в
`<div class="rate">[масштаб]…</div>` одразу після `</h1>`; `{{logos:…}}` без `|mono`.

---

## C. Частина N — скоуп-скелет (обгортка для будь-якого контенту)

Це «гість» на сторінці: жодного `:root/html/body`, всі класи з префіксом `pN-`,
токени — локальні. Заміни `p2` на потрібний номер скрізь (`p3-`, `p4-`).

```html
<!DOCTYPE html>
<html lang="[uk|ru|en]">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<meta name="robots" content="noindex,nofollow">
<title>[Бренд] — [оффер] · Частина 2</title>
<link rel="preconnect" href="https://fonts.googleapis.com"><link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Jost:wght@500;700;800&family=Montserrat:wght@600;700;800&family=Inter:wght@400;500;600;700&family=JetBrains+Mono:wght@500;700&display=swap" rel="stylesheet">
<style>
.p2-wrap *{margin:0;padding:0;box-sizing:border-box}
.p2-wrap{
  --obsidian:#070A14; --glass-2:rgba(255,255,255,.055); --brd:rgba(255,255,255,.10); --brd-soft:rgba(255,255,255,.07);
  --accent:#F7B32B; --accent-2:#FFD24D; --second-lt:#6E92F5;
  --ink-0:#FFFFFF; --ink-1:#EBEBEB; --ink-2:rgba(235,235,235,.6); --ink-3:rgba(235,235,235,.3);
  --f-head:'Montserrat',system-ui,sans-serif; --f-disp:'Jost',system-ui,sans-serif;
  --f-body:'Inter',system-ui,sans-serif; --f-mono:'JetBrains Mono',ui-monospace,monospace;
  --spec:inset 0 1px 0 rgba(255,255,255,.14); --blur:blur(16px) saturate(150%);
  position:relative;background:var(--obsidian);width:100%;overflow:hidden;margin:0;padding:0;
  color:var(--ink-1);font-family:var(--f-body);-webkit-font-smoothing:antialiased
}
.p2-wrap img,.p2-wrap svg,.p2-wrap iframe{max-width:100%;display:block}
.p2-noise{position:absolute;inset:0;z-index:0;pointer-events:none;opacity:.13;mix-blend-mode:overlay;
  background-image:url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='160' height='160'%3E%3Cfilter id='n'%3E%3CfeTurbulence type='fractalNoise' baseFrequency='0.85' numOctaves='2'/%3E%3C/filter%3E%3Crect width='100%25' height='100%25' filter='url(%23n)'/%3E%3C/svg%3E")}
.p2-glow{position:absolute;inset:0;z-index:0;pointer-events:none;opacity:.45;
  background:radial-gradient(46% 30% at 88% 6%, rgba(45,91,223,.26), transparent 72%),radial-gradient(42% 30% at 12% 96%, rgba(139,92,246,.18), transparent 72%);filter:blur(40px)}
.p2-app{max-width:560px;margin:0 auto;padding:14px;position:relative;z-index:1}
.p2-shell{border-radius:1.8rem;padding:20px 18px;position:relative;overflow:hidden;
  background:linear-gradient(180deg,rgba(14,27,61,.5),rgba(10,14,31,.6));
  border:1px solid var(--brd);box-shadow:var(--spec),0 40px 100px -50px rgba(0,0,0,.9);
  backdrop-filter:var(--blur);-webkit-backdrop-filter:var(--blur)}
@supports not (backdrop-filter:blur(1px)){.p2-shell{background:rgba(14,18,38,.95)}}
.p2-shell::before{content:"";position:absolute;top:0;left:10%;right:10%;height:1px;background:linear-gradient(90deg,transparent,rgba(255,255,255,.4),transparent)}
.p2-cap{font-family:var(--f-mono);font-size:9px;letter-spacing:.22em;text-transform:uppercase;color:var(--ink-2);
  display:inline-flex;align-items:center;gap:8px;padding:6px 12px;border-radius:100px;background:var(--glass-2);border:1px solid var(--brd-soft);margin-bottom:16px}
.p2-cap .p2-dot{width:6px;height:6px;border-radius:50%;background:var(--accent);box-shadow:0 0 0 4px rgba(247,179,43,.18),0 0 12px rgba(247,179,43,.8);animation:p2pulse 2s infinite}
@keyframes p2pulse{0%,100%{opacity:1;transform:scale(1)}50%{opacity:.4;transform:scale(.7)}}
@media(prefers-reduced-motion:reduce){.p2-cap .p2-dot{animation:none}}
/* ↓ сюди CSS контенту частини (D / E / F) */
</style>
</head>
<body>
<div class="p2-wrap">
  <div class="p2-noise"></div><div class="p2-glow"></div>
  <div class="p2-app">
    <!-- бренд-бар у частинах 2+ не повторюємо: лого вже є зверху сторінки -->
    <div class="p2-shell">
      <span class="p2-cap"><span class="p2-dot"></span>[ЗАГОЛОВОК-МАРКЕР ЧАСТИНИ]</span>
      <!-- ↓ сюди розмітку контенту (D / E / F) -->
    </div>
  </div>
</div>
</body>
</html>
```
Light-версія «гостя»: `background:#F5F6F8` на `.p2-wrap`, `.p2-shell{background:#fff;border:1px solid rgba(10,14,31,.06);box-shadow:0 1px 2px rgba(16,27,61,.05),0 14px 36px -16px rgba(16,27,61,.18)}`,
без `.p2-noise/.p2-glow`, ink-токени зі світлої теми.

---

## D. Контент частини N — чекліст «Що ви отримуєте»

Вставляється у C. Маркер: «Що ви отримуєте під ключ за 24 години».

```css
.p2-blist{display:flex;flex-direction:column;gap:13px}
.p2-bitem{display:flex;gap:12px;align-items:flex-start}
.p2-bitem .p2-ck{flex:none;width:24px;height:24px;border-radius:7px;display:grid;place-items:center;margin-top:2px;
  background:linear-gradient(160deg,#46D86A,#22B24E);box-shadow:var(--spec),0 6px 14px -6px rgba(40,194,87,.55)}
.p2-bitem .p2-ck svg{width:13px;height:13px;fill:none;stroke:#fff;stroke-width:2.6;stroke-linecap:round;stroke-linejoin:round}
.p2-bitem p{font-size:13.5px;color:var(--ink-1);line-height:1.5}
.p2-bitem p b{color:#fff;font-weight:600}
.p2-bitem p .p2-q{color:rgba(235,235,235,.5)}
```
```html
<div class="p2-blist">
  <div class="p2-bitem"><span class="p2-ck"><svg viewBox="0 0 24 24"><path d="M5 13l4 4L19 7"/></svg></span><p>[Пункт 1: <b>ключова вигода</b>, що саме буде готово і коли] <span class="p2-q">[доказ у дужках]</span></p></div>
  <div class="p2-bitem"><span class="p2-ck"><svg viewBox="0 0 24 24"><path d="M5 13l4 4L19 7"/></svg></span><p>[Пункт 2]</p></div>
  <div class="p2-bitem"><span class="p2-ck"><svg viewBox="0 0 24 24"><path d="M5 13l4 4L19 7"/></svg></span><p>[Пункт 3]</p></div>
  <div class="p2-bitem"><span class="p2-ck"><svg viewBox="0 0 24 24"><path d="M5 13l4 4L19 7"/></svg></span><p>[Пункт 4]</p></div>
  <div class="p2-bitem"><span class="p2-ck"><svg viewBox="0 0 24 24"><path d="M5 13l4 4L19 7"/></svg></span><p>[Пункт 5–6: підсумок — що людина має в руках наприкінці і наступний крок]</p></div>
</div>
```

---

## E. Контент частини N — відео-фасад + місток (префікс p3-)

Маркер: «① Дивіться відео · 10 хвилин». Заголовок `h2` + підводка + фасад + місток.
У `<head>` додатково: `<link rel="preconnect" href="https://www.youtube-nocookie.com"><link rel="preconnect" href="https://i.ytimg.com">`.

```css
.p3-title{font-family:var(--f-head);color:var(--ink-0);font-size:clamp(20px,5.4vw,28px);font-weight:800;line-height:1.15;letter-spacing:-.03em;margin:12px 0 4px}
.p3-title .g{background:linear-gradient(96deg,var(--accent-2) 0%,#fff 55%,var(--second-lt) 100%);-webkit-background-clip:text;background-clip:text;color:transparent;font-style:italic;font-family:var(--f-disp);
  -webkit-box-decoration-break:clone;box-decoration-break:clone;padding:.02em .12em .04em 0}
.p3-sub{font-size:12.5px;color:var(--ink-2);line-height:1.45;margin-bottom:14px}
.p3-video{position:relative;width:100%;aspect-ratio:16/9;padding:0;cursor:pointer;display:block;
  border-radius:1.1rem;overflow:hidden;background:#000;border:1px solid var(--brd);box-shadow:var(--spec),0 30px 70px -30px rgba(0,0,0,.85)}
.p3-video .p3-thumb{position:absolute;inset:0;width:100%;height:100%;object-fit:cover;filter:brightness(.82)}
.p3-video::after{content:"";position:absolute;inset:0;background:linear-gradient(180deg,rgba(7,10,20,.15),rgba(7,10,20,.55))}
.p3-play{position:absolute;left:50%;top:50%;transform:translate(-50%,-50%);z-index:2;width:66px;height:66px;border-radius:50%;
  display:grid;place-items:center;background:linear-gradient(180deg,rgba(255,255,255,.22),rgba(255,255,255,.08));
  border:1px solid rgba(255,255,255,.5);backdrop-filter:blur(8px);-webkit-backdrop-filter:blur(8px);
  box-shadow:0 10px 34px -8px rgba(0,0,0,.7),inset 0 1px 0 rgba(255,255,255,.5);transition:transform .2s,box-shadow .2s}
.p3-video:hover .p3-play{transform:translate(-50%,-50%) scale(1.06)}
.p3-play svg{width:26px;height:26px;margin-left:4px;fill:#fff;filter:drop-shadow(0 2px 6px rgba(0,0,0,.5))}
.p3-dur{position:absolute;right:10px;bottom:10px;z-index:2;font-family:var(--f-mono);font-size:11px;font-weight:700;color:#fff;
  padding:4px 9px;border-radius:100px;background:rgba(7,10,20,.6);border:1px solid rgba(255,255,255,.18);backdrop-filter:blur(6px)}
.p3-iframe{width:100%;aspect-ratio:16/9;border:0;display:block;border-radius:1.1rem;overflow:hidden}
.p3-bridge{margin-top:13px;text-align:center;font-size:12.5px;color:var(--ink-2)}
.p3-bridge b{color:var(--ink-1);font-weight:600}
.p3-bridge .ar{color:var(--accent);font-weight:700}
```
```html
<span class="p3-cap"><span class="p3-dot"></span>① Дивіться відео · [ХРОНОМЕТРАЖ]</span>
<h2 class="p3-title">[Тема відео з <span class="g">градієнтним фрагментом</span>]</h2>
<div class="p3-sub">[Подивіться до кінця — далі покажу, як отримати це готовим.]</div>

<button class="p3-video" id="p3play" type="button" aria-label="Дивитися відео">
  <img class="p3-thumb" src="https://i.ytimg.com/vi/[VIDEO_ID]/maxresdefault.jpg"
       onerror="this.onerror=null;this.src='https://i.ytimg.com/vi/[VIDEO_ID]/hqdefault.jpg'" alt="">
  <span class="p3-dur">[10:00]</span>
  <span class="p3-play"><svg viewBox="0 0 24 24"><path d="M8 5v14l11-7z"/></svg></span>
</button>

<div class="p3-bridge"><span class="ar">↓</span> Додивилися? Далі — <b>[наступний крок]</b></div>
```
```html
<script>
(function(){
  var b=document.getElementById('p3play'); if(!b) return;
  b.addEventListener('click',function(){
    var f=document.createElement('iframe'); f.className='p3-iframe';
    f.src='https://www.youtube-nocookie.com/embed/[VIDEO_ID]?autoplay=1&rel=0&modestbranding=1&playsinline=1';
    f.allow='autoplay; encrypted-media; picture-in-picture; fullscreen';
    f.setAttribute('allowfullscreen',''); f.setAttribute('title','[Бренд] відео');
    b.replaceWith(f);
  });
})();
</script>
```
`<script>` — перед `</body>`. Не YouTube (Vimeo, власний mp4 зі звуком) → у фасаді те саме,
у кліку замість iframe створюй `<video controls autoplay playsinline src="…">`.

---

## F. Контент частини N — відгуки (префікс p2- або p4-)

Маркер: «Що кажуть клієнти». CSS і розмітка — компонент 11 у `components.md`; за потреби
під ним — `.p2-bridge` (як у E, з префіксом p2-) до наступної форми.
