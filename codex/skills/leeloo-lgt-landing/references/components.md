# Компоненти LGT-екрана

Кожен компонент — HTML + CSS у стилі бойових LGT. CSS спирається на токени з
`design-system.md`. Для частин 2+ **усі класи й @keyframes отримують префікс** (`p2-`, `p3-`…),
а `var(--…)` замінюються на локальні змінні, оголошені на `.pN-wrap` (див. `part-templates.md`).

Зміст: 1 brandbar · 2 tag · 3 hero · 4 media (video / image / youtube) · 5 vcap · 6 chips ·
7 subproof · 8 logos · 9 getlist · 10 checklist · 11 testimonials · 12 bridge · 13 stats

---

## 1. Brandbar — лого клієнта

```html
<div class="brandbar">{{asset:logo.svg|fill=#FFFFFF}}</div>
<!-- або PNG: --> <div class="brandbar"><img src="{{asset:logo.png}}" alt="Назва бренду"></div>
```
```css
.brandbar{display:flex;justify-content:center;padding:calc(var(--host-gap) + 6px) 0 2px}
.brandbar svg,.brandbar img{height:21px;width:auto}   /* 21–28px; для «квадратних» лого до 34px */
```
Лого кольорове і не читається на темному → `.brandbar img{filter:brightness(0) invert(1)}`.

**Лого немає (тільки назва)** — текстовий логотип у дисплейному шрифті з акцентною крапкою:
```html
<div class="brandbar"><span class="logo-text">Smile<span>Lab</span><i></i></span></div>
```
```css
.logo-text{font-family:var(--f-head);font-weight:800;font-size:19px;letter-spacing:-.03em;color:var(--ink-0);display:inline-flex;align-items:baseline;gap:2px}
.logo-text span{color:var(--accent)}
.logo-text i{width:6px;height:6px;border-radius:50%;background:var(--accent);margin-left:3px;align-self:center}
```
Ділити назву на два слова/склади (одне біле, одне акцентне) — так текст читається як знак, а не як заголовок.

## 2. Tag — пілюля з пульсуючою крапкою

Роль: категорія пропозиції («AI автоматизація маркетингу…») або маркер кроку
(«① Дивіться відео · 10 хвилин»). Один на екран, короткий (до 45 символів).

```html
<span class="tag"><span class="dot"></span>КАТЕГОРІЯ АБО КРОК</span>
```
```css
.tag{display:inline-flex;align-items:center;gap:8px;font-family:var(--f-mono);font-size:9px;letter-spacing:.22em;text-transform:uppercase;color:var(--ink-2);
  padding:6px 12px;border-radius:var(--r-pill);background:var(--glass-2);border:1px solid var(--brd-soft);box-shadow:var(--spec)}
.tag .dot{width:6px;height:6px;border-radius:50%;background:var(--accent);box-shadow:0 0 0 4px rgba(247,179,43,.18),0 0 12px rgba(247,179,43,.8);animation:pulse 2s infinite}
@keyframes pulse{0%,100%{opacity:1;transform:scale(1)}50%{opacity:.4;transform:scale(.7)}}
@media(prefers-reduced-motion:reduce){.tag .dot{animation:none}}
```
Light: `background:#fff;border:1px solid var(--brd)`, без `box-shadow:var(--spec)`.
Тіні крапки — це rgba акценту; перефарбовуючи `--accent`, перерахуй ці два rgba.

## 3. Hero — УТП з градієнтним фрагментом

Формула заголовка з бойових LGT: **[результат за термін] + [механізм у градієнті] + [масштаб/гарантія тихо]**.
Приклад структури: «Готова за 30 днів AI-система продажів, *яка 24/7 перетворює рекламу на заявки*
<tail>на $10K–$1M+/міс, або ви не платите</tail>». Градієнт — на 5–9 словах, не на всьому.

```html
<h1 class="hero">Перша частина УТП,<span class="grad"> ключова обіцянка курсивом</span>
  <span class="tail"><span class="num">на $10K–$100K/міс</span>, або ви не платите</span></h1>
<div class="sub">Одне речення-підводка (для частин 2+ або замість .tail).</div>
```
```css
h1.hero{font-family:var(--f-head);color:var(--ink-0);font-size:clamp(23px,6.6vw,34px);font-weight:800;line-height:1.1;letter-spacing:-.04em;margin:11px 0 6px;padding-right:.06em}
h1.hero .grad{background:linear-gradient(96deg,var(--accent-2) 0%,#fff 55%,var(--second-lt) 100%);-webkit-background-clip:text;background-clip:text;color:transparent;
  font-style:italic;font-family:var(--f-disp);-webkit-box-decoration-break:clone;box-decoration-break:clone;padding:.02em .16em .04em 0}
h1.hero .tail{font-size:.62em;font-weight:600;color:var(--ink-2);font-family:var(--f-body);letter-spacing:0}
h1.hero .tail .num{font-family:var(--f-disp);font-weight:700;white-space:nowrap}
.sub{font-size:12.5px;color:var(--ink-2);line-height:1.45;margin-bottom:14px}
```
`padding` у `.grad` потрібен, щоб курсивні літери не обрізалися кліпом градієнта.
Light-варіант виносить масштаб окремим рядком: `<div class="rate">на $10K–$1M+/міс…</div>`
(`font-family:var(--f-disp);font-weight:800;font-size:clamp(16px,4.8vw,21px);color:var(--navy)`).

## 4. Медіа

### 4a. Відео-демо (mp4, автоплей без звуку) + смужка месенджерів

Використовуй, коли є короткий (15–60 с) продуктовий ролик або анімований креатив. Смужка
месенджерів над відео («WhatsApp…Gmail · 24/7/365») говорить, що спілкування буде в
месенджерах — це універсально для будь-якого клієнта Leeloo, тому ассет вбудований у скіл.

```html
<div class="vwrap">
  <div class="msgr-bar"><img src="{{msgr-bar}}" alt="WhatsApp, Messenger, Instagram, Telegram, Viber, SMS, Apple, Google, Gmail — 24/7/365"></div>
  <div class="vframe">
    <video muted loop playsinline autoplay preload="metadata" poster="URL_ПОСТЕРА" aria-label="Демо">
      <source src="URL_MP4" type="video/mp4">
    </video>
  </div>
</div>
<script>document.querySelectorAll('video[autoplay]').forEach(v=>v.play().catch(()=>{}));</script>
```
```css
.vwrap{position:relative;margin-top:34px}
.msgr-bar{position:absolute;right:0;bottom:100%;margin-bottom:-1px;z-index:4}
.msgr-bar img{height:24px;width:auto;display:block;filter:drop-shadow(0 3px 8px rgba(0,0,0,.6))}
.vframe{border-radius:1.1rem;overflow:hidden;background:rgba(7,8,16,.7);border:1px solid var(--brd);box-shadow:var(--spec),0 30px 70px -30px rgba(0,0,0,.85)}
.vframe video{width:100%;height:auto;display:block;object-fit:contain}
```
Відео/постер — тільки за URL (файловий хостинг клієнта, static.leeloo.ai після завантаження в
медіатеку Leeloo, CDN). Не інлайнь відео в base64. Без смужки — `.vwrap{margin-top:14px}`.

### 4b. Картинка-креатив

```html
<div class="vwrap"><div class="vframe"><img src="{{asset:hero.webp}}" alt="" loading="eager"></div></div>
```
Той самий `.vframe`, але для картинки задай пропорцію і `cover`, інакше поки фото вантажиться
(або якщо URL битий) рамка схлопнеться в 0px і екран «стрибне»:
```css
.vframe img{width:100%;aspect-ratio:16/10;height:auto;display:block;object-fit:cover;background:rgba(255,255,255,.04)}
```
Файл ≤ 1200px по ширині,
WebP/JPEG ≤ 150 KB — інакше віддавай за URL. Пропорція 16:9 або 4:5 (для портретних креативів
з Instagram) — не квадрат-заглушка.

### 4c. YouTube-фасад (клік → iframe)

Для довгих відео (VSL, розбір, вебінар). Фасад замість iframe вантажиться миттєво і не тягне
YouTube-скрипти до кліку. Домен `youtube-nocookie.com`.

```html
<button class="video" id="vplay" type="button" aria-label="Дивитися відео">
  <img class="thumb" src="https://i.ytimg.com/vi/VIDEO_ID/maxresdefault.jpg"
       onerror="this.onerror=null;this.src='https://i.ytimg.com/vi/VIDEO_ID/hqdefault.jpg'" alt="">
  <span class="dur">10:00</span>
  <span class="play"><svg viewBox="0 0 24 24"><path d="M8 5v14l11-7z"/></svg></span>
</button>
<script>
(function(){var b=document.getElementById('vplay');if(!b)return;
b.addEventListener('click',function(){var f=document.createElement('iframe');f.className='iframe';
f.src='https://www.youtube-nocookie.com/embed/VIDEO_ID?autoplay=1&rel=0&modestbranding=1&playsinline=1';
f.allow='autoplay; encrypted-media; picture-in-picture; fullscreen';f.setAttribute('allowfullscreen','');
f.setAttribute('title','Відео');b.replaceWith(f);});})();
</script>
```
```css
.video{position:relative;width:100%;aspect-ratio:16/9;padding:0;cursor:pointer;display:block;border-radius:1.1rem;overflow:hidden;background:#000;border:1px solid var(--brd);box-shadow:var(--spec),0 30px 70px -30px rgba(0,0,0,.85)}
.video .thumb{position:absolute;inset:0;width:100%;height:100%;object-fit:cover;filter:brightness(.82)}
.video::after{content:"";position:absolute;inset:0;background:linear-gradient(180deg,rgba(7,10,20,.15),rgba(7,10,20,.55))}
.play{position:absolute;left:50%;top:50%;transform:translate(-50%,-50%);z-index:2;width:66px;height:66px;border-radius:50%;display:grid;place-items:center;
  background:linear-gradient(180deg,rgba(255,255,255,.22),rgba(255,255,255,.08));border:1px solid rgba(255,255,255,.5);backdrop-filter:blur(8px);-webkit-backdrop-filter:blur(8px);
  box-shadow:0 10px 34px -8px rgba(0,0,0,.7),inset 0 1px 0 rgba(255,255,255,.5);transition:transform .2s}
.video:hover .play{transform:translate(-50%,-50%) scale(1.06)}
.play svg{width:26px;height:26px;margin-left:4px;fill:#fff;filter:drop-shadow(0 2px 6px rgba(0,0,0,.5))}
.dur{position:absolute;right:10px;bottom:10px;z-index:2;font-family:var(--f-mono);font-size:11px;font-weight:700;color:#fff;padding:4px 9px;border-radius:100px;background:rgba(7,10,20,.6);border:1px solid rgba(255,255,255,.18);backdrop-filter:blur(6px)}
.iframe{width:100%;aspect-ratio:16/9;border:0;display:block;border-radius:1.1rem;overflow:hidden}
```
У `<head>` додай `<link rel="preconnect" href="https://www.youtube-nocookie.com"><link rel="preconnect" href="https://i.ytimg.com">`.
ID екрана з відео роби унікальним на сторінці (`p3play`, а не `vplay`, якщо це частина 3).

## 5. Vcap — підпис-ланцюжок під медіа

```html
<div class="vcap">Лідген → Чати → Продаж → CRM → Оплата → Аналітика</div>
```
```css
.vcap{text-align:center;font-family:var(--f-mono);font-size:9px;letter-spacing:.08em;color:var(--ink-3);text-transform:uppercase;margin-top:7px}
```
Це «як це працює» одним рядком: 4–6 кроків шляху клієнта. Для стоматології:
«Заявка → Дзвінок → Огляд → План → Лікування → Гарантія».

## 6. Chips — 2–3 короткі обіцянки

```html
<div class="chips"><span class="chip">без технічних навичок</span><span class="chip">за 30 днів</span></div>
```
```css
.chips{display:flex;gap:8px;flex-wrap:wrap;justify-content:center;margin-top:11px}
.chip{font-size:12.5px;font-weight:600;color:var(--ink-1);padding:8px 16px;border-radius:var(--r-pill);background:var(--glass-2);border:1px solid var(--brd-soft)}
```
Чіпи — знімачі заперечень (складно / довго / дорого / ризиковано): по 2–3 слова кожен.

## 7. Subproof — соцдоказ цифрами

```html
<div class="subproof">З 2016 р. перевірено в <b>8&nbsp;500+ бізнесах</b> із 60 країн на мільйонах $ рекламних бюджетів і понад <b>$1 млрд виручки</b></div>
```
```css
.subproof{margin-top:13px;font-size:11.5px;color:var(--ink-2);line-height:1.4;text-align:center}
.subproof b{color:var(--ink-1)}
```
Одне речення, 2–3 числа жирним. Немає великих чисел → рік заснування + кількість клієнтів +
рейтинг («4.9★ за 312 відгуками»). Числа з тонким пробілом `&nbsp;` між тисячами.

## 8. Logos — marquee логотипів

Клієнти клієнта, партнери, ЗМІ, сертифікати, маркетплейси, де він продає. Мінімум 6 (краще 8–12).
Файли PNG/SVG з прозорим фоном, висота 60px (ширина довільна) — тоді доріжка рівна.

```html
<div class="logos"><div class="logos-tr">{{logos:a.png,b.png,c.png,d.png,e.png,f.png|mono}}</div></div>
```
```css
.logos{margin-top:10px;overflow:hidden;border-radius:1.1rem;background:rgba(255,255,255,.03);border:1px solid var(--brd-soft);padding:14px 0;
  -webkit-mask-image:linear-gradient(90deg,transparent,#000 8%,#000 92%,transparent);mask-image:linear-gradient(90deg,transparent,#000 8%,#000 92%,transparent)}
.logos-tr{display:flex;align-items:center;width:max-content;animation:lsc 42s linear infinite}
.logos-tr img{height:26px;width:auto;margin:0 18px;object-fit:contain;transition:filter .3s,opacity .3s}
.logos-tr img.mono{filter:brightness(0) invert(.72);opacity:.95}
.logos-tr img.mono:hover{filter:brightness(0) invert(1);opacity:1}
.logos-tr img.orig{filter:none;opacity:1}
@keyframes lsc{from{transform:translateX(0)}to{transform:translateX(-50%)}}
@media(prefers-reduced-motion:reduce){.logos-tr{animation:none;transform:translateX(-50%)}}
```
`{{logos:…}}` сам подвоює доріжку (анімація до -50% циклиться безшовно). На dark логотипи
знебарвлюються `mono`; 1–2 «фірмових» (червоне лого, жовтий бренд) можна лишити в кольорі —
дай їм `class="orig"` вручну, підставивши `{{asset:…}}` окремими `<img>`. На light — без `|mono`.

## 9. Getlist — «Залишайте заявку, щоб отримати:»

Це міст до форми Leeloo, яка стоїть одразу під частиною 1. Список каже, що саме людина
отримає після підписки в месенджері. 2–3 пункти, перший — найцінніший і безкоштовний.

```html
<div class="getlist">
  <div class="gh">👇 Залишайте заявку, щоб отримати <b>за 24 години</b>:</div>
  <ol>
    <li><span class="n">1</span>Індивідуальну <b>стратегію…</b> безкоштовно <span class="q">[зазвичай $999]</span></li>
    <li><span class="n">2</span><b>Розрахунок…</b> <span class="q">[без технічних навичок]</span></li>
    <li><span class="n">3</span>Кейси й приклади…</li>
  </ol>
</div>
```
```css
.getlist{margin-top:14px}
.getlist .gh{text-align:center;font-size:13.5px;font-weight:700;color:var(--ink-0);line-height:1.35;margin-bottom:9px}
.getlist .gh b{color:var(--accent)}
.getlist ol{list-style:none;display:flex;flex-direction:column;gap:7px}
.getlist li{position:relative;padding-left:28px;font-size:12.5px;color:var(--ink-1);line-height:1.38}
.getlist li b{color:#fff;font-weight:600}
.getlist li .q{color:rgba(235,235,235,.5)}
.getlist li .n{position:absolute;left:0;top:0;width:20px;height:20px;border-radius:50%;display:grid;place-items:center;font-family:var(--f-mono);font-size:10px;font-weight:700;color:#0A0E1F;background:linear-gradient(180deg,var(--accent-2),var(--accent))}
```
Light: `.gh b{color:var(--navy)}`, `li b{color:var(--ink-0)}`, номер із `box-shadow:0 2px 6px rgba(247,179,43,.35)`.

Дужка `[зазвичай $X]` працює тільки з реальною ціною з брифу. Немає ціни — не вигадуй: став
іншу приглушену уточнювалку (`[за 24 години]`, `[онлайн або в клініці]`, `[без зобовʼязань]`)
або нічого, і скажи клієнту, що дужку з ціною можна додати.

## 10. Checklist — «Що ви отримуєте» (частина 2)

Зелені галочки замість номерів: це вже не порядок, а перелік цінності. 4–6 пунктів,
кожен — одне речення з `<b>` на ключовій вигоді, деталі в `[…]` приглушено.

```html
<div class="p2-blist">
  <div class="p2-bitem"><span class="p2-ck"><svg viewBox="0 0 24 24"><path d="M5 13l4 4L19 7"/></svg></span>
    <p>Наша команда створить <b>стратегію…</b>. Через 24 години у вас будуть: … <span class="p2-q">[перевірено на 8&nbsp;500+ бізнесах]</span></p></div>
  <!-- ще 3–5 .p2-bitem -->
</div>
```
```css
.p2-blist{display:flex;flex-direction:column;gap:13px}
.p2-bitem{display:flex;gap:12px;align-items:flex-start}
.p2-bitem .p2-ck{flex:none;width:24px;height:24px;border-radius:7px;display:grid;place-items:center;margin-top:2px;background:linear-gradient(160deg,#46D86A,#22B24E);box-shadow:var(--spec),0 6px 14px -6px rgba(40,194,87,.55)}
.p2-bitem .p2-ck svg{width:13px;height:13px;fill:none;stroke:#fff;stroke-width:2.6;stroke-linecap:round;stroke-linejoin:round}
.p2-bitem p{font-size:13.5px;color:var(--ink-1);line-height:1.5}
.p2-bitem p b{color:#fff;font-weight:600}
.p2-bitem p .p2-q{color:rgba(235,235,235,.5)}
```
Галочка лишається зеленою в будь-якому бренді — це семантика «виконано», не акцент.

## 11. Testimonials — відгуки клієнтів

У бойових LGT Leeloo цього блоку не було (доказ — логотипи й цифри), але клієнтам Leeloo відгуки
потрібні часто. Блок зроблено в тій самі мові: скляні картки, моно-підпис, зірки акцентом.
2–3 відгуки, кожен до 200 символів, з фото/ініціалами, імʼям і результатом у цифрі.

```html
<div class="p2-rev">
  <div class="p2-rcard">
    <div class="p2-rhead">
      <img class="p2-ava" src="{{asset:rev-1.jpg}}" alt="">  <!-- або <span class="p2-ava p2-ini">ОК</span> -->
      <div><div class="p2-rname">Олена К.</div><div class="p2-rrole">Власниця студії · Київ</div></div>
      <div class="p2-stars">★★★★★</div>
    </div>
    <p class="p2-rtext">«Цитата з конкретним результатом: <b>+38% записів за 2 місяці</b>…»</p>
  </div>
</div>
```
```css
.p2-rev{display:flex;flex-direction:column;gap:10px;margin-top:14px}
.p2-rcard{border-radius:1.1rem;padding:14px;background:var(--glass-2);border:1px solid var(--brd-soft);box-shadow:var(--spec)}
.p2-rhead{display:flex;align-items:center;gap:10px}
.p2-ava{width:36px;height:36px;border-radius:50%;object-fit:cover;flex:none;border:1px solid var(--brd)}
.p2-ini{display:grid;place-items:center;font-family:var(--f-mono);font-size:11px;font-weight:700;color:#0A0E1F;background:linear-gradient(180deg,var(--accent-2),var(--accent))}
.p2-rname{font-size:13px;font-weight:700;color:var(--ink-0);line-height:1.2}
.p2-rrole{font-family:var(--f-mono);font-size:9px;letter-spacing:.08em;text-transform:uppercase;color:var(--ink-3);margin-top:2px}
.p2-stars{margin-left:auto;color:var(--accent);font-size:12px;letter-spacing:.1em}
.p2-rtext{margin-top:10px;font-size:12.5px;line-height:1.5;color:var(--ink-1)}
.p2-rtext b{color:#fff;font-weight:600}
```
Light-варіант: `.p2-rcard{background:#fff;border:1px solid rgba(10,14,31,.08);box-shadow:0 1px 2px rgba(16,27,61,.05),0 10px 28px -14px rgba(16,27,61,.18)}`,
`.p2-rtext b{color:var(--ink-0)}`, `.p2-rrole{color:var(--ink-3)}` зі світлими ink-токенами — те ж стосується `b{color:#fff}` і `rgba(235,…)` у чеклісті (компонент 10): на light замінюй на `var(--ink-0)` і `var(--ink-3)`.

Фото відгуків — квадрат ≤ 160px, JPEG ≤ 15 KB кожне, інакше за URL. Скріншоти переписок з
месенджерів — окремим `.vframe` з `img`, не в картку.

## 12. Bridge — стрілка-місток до наступного блоку

```html
<div class="bridge"><span class="ar">↓</span> Додивилися? Далі — <b>як отримати це готовим за 30 днів</b></div>
```
```css
.bridge{margin-top:13px;text-align:center;font-size:12.5px;color:var(--ink-2)}
.bridge b{color:var(--ink-1);font-weight:600}
.bridge .ar{color:var(--accent);font-weight:700}
```
Ставиться в кінці екрана, під яким іде форма Leeloo або наступний HTML-блок.

## 13. Stats — 3 великі цифри (опційно, замість або разом із subproof)

```html
<div class="stats"><div><b>8 500+</b><span>бізнесів</span></div><div><b>60</b><span>країн</span></div><div><b>$1 млрд</b><span>виручки</span></div></div>
```
```css
.stats{display:grid;grid-template-columns:repeat(3,1fr);gap:8px;margin-top:13px}
.stats div{text-align:center;padding:10px 6px;border-radius:.9rem;background:var(--glass-2);border:1px solid var(--brd-soft)}
.stats b{display:block;font-family:var(--f-disp);font-weight:800;font-size:clamp(17px,5vw,22px);color:var(--ink-0);letter-spacing:-.02em}
.stats span{display:block;font-family:var(--f-mono);font-size:9px;letter-spacing:.1em;text-transform:uppercase;color:var(--ink-3);margin-top:2px}
```
