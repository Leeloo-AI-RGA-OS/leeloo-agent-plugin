# Дизайн-система LGT-екранів

Витягнута з бойових LGT Leeloo (yaflu1 part 1/2, biyubt part 3, apple-light screen 1).
Тут — **скелет і правила**. Кольори, шрифти й лого підставляються під бренд клієнта.

## 1. Каркас екрана (однаковий для всіх частин)

```
.page  (фон: колір + сітка + glow-плями + шум; overflow:hidden)
 └ .app  (колонка max-width:560px; margin:0 auto; padding:0 14px 14px; z-index:1)
     ├ .brandbar  (лого клієнта по центру, висота 21–28px)
     └ .shell  (одна «скляна» картка з усім контентом екрана)
         ├ .tag        — моно-пілюля з пульсуючою крапкою (категорія / крок)
         ├ h1.hero     — УТП; ключовий фрагмент у <span class="grad"> (курсивний градієнт)
         ├ медіа       — .vwrap > .msgr-bar + .vframe (video / img / youtube-facade)
         ├ .vcap       — моно-підпис під медіа (ланцюжок процесу)
         ├ .chips      — 2–3 короткі обіцянки
         ├ .subproof   — соцдоказ цифрами (жирним — числа)
         ├ .logos      — marquee логотипів (клієнти / партнери / ЗМІ)
         └ .getlist    — нумерований список «Залишайте заявку, щоб отримати:»
```

Чому одна картка: LGT відкривають з реклами на телефоні. Один `shell` на 560px читається
як «екран застосунку», а не як сайт — вище довіра і конверсія. Не розбивай контент на
кілька карток без потреби.

Чому 560px: це ширина, на якій текст 12.5–13.5px лишається читабельним на мобільному і
не розтягується на десктопі. Не роби ширше.

## 2. Токени — тема DARK (базова)

```css
:root{
  --obsidian:#070A14; --surface:#0E1B3D; --raised:#141A30;
  --glass:rgba(255,255,255,.03); --glass-2:rgba(255,255,255,.055); --glass-hi:rgba(255,255,255,.09);
  --brd:rgba(255,255,255,.10); --brd-soft:rgba(255,255,255,.07);
  /* бренд-акценти — ЗАМІНИТИ під клієнта */
  --accent:#F7B32B; --accent-2:#FFD24D;        /* головний акцент (крапка, номери, виділення) */
  --second:#2D5BDF; --second-lt:#6E92F5;       /* другий колір градієнта заголовка */
  --third:#8B5CF6;                             /* glow-пляма внизу; можна = --second */
  --ok:#34C7B5;                                /* «зелений» для чеклістів; або #22B24E */
  --ink-0:#FFFFFF; --ink-1:#EBEBEB; --ink-2:rgba(235,235,235,.6); --ink-3:rgba(235,235,235,.3);
  --f-head:'Montserrat',system-ui,sans-serif;  /* заголовки */
  --f-disp:'Jost',system-ui,sans-serif;        /* курсивний градієнтний фрагмент, числа */
  --f-body:'Inter',system-ui,sans-serif;       /* текст */
  --f-mono:'JetBrains Mono',ui-monospace,monospace; /* теги, підписи, номери */
  --r-pill:100px; --spec:inset 0 1px 0 rgba(255,255,255,.14); --blur:blur(16px) saturate(150%);
  --host-gap:28px;
}
```

Фон `.page` у dark:
- `::before` — сітка 60px з лініями `rgba(255,255,255,.035)`, замаскована радіально зверху
  (`mask-image:radial-gradient(120% 80% at 50% 0%,#000 30%,transparent 80%)`);
- `::after` — 3 glow-плями (`--accent` ліворуч зверху ≈.16, `--second` праворуч зверху ≈.30,
  `--third` праворуч знизу ≈.20), `filter:blur(40px)`, `opacity:.5`;
- `.noise` — SVG feTurbulence, `opacity:.15; mix-blend-mode:overlay`.

Картка `.shell` у dark:
```css
background:linear-gradient(180deg,rgba(14,27,61,.5),rgba(10,14,31,.6));
border:1px solid var(--brd);box-shadow:var(--spec),0 40px 100px -50px rgba(0,0,0,.9);
backdrop-filter:var(--blur);-webkit-backdrop-filter:var(--blur);border-radius:1.8rem;padding:16px 16px 18px
```
плюс `::before` — світлова лінія зверху (`linear-gradient(90deg,transparent,rgba(255,255,255,.4),transparent)`),
і фолбек `@supports not (backdrop-filter:blur(1px)){.shell{background:rgba(14,18,38,.95)}}`.

## 3. Токени — тема LIGHT («apple»)

```css
:root{
  --bg:#F5F6F8; --card:#FFFFFF;
  --ink-0:#0A0E1F; --ink-1:#1D1D1F; --ink-2:#5B6472; --ink-3:#9AA3B2;
  --brd:rgba(10,14,31,.10); --brd-soft:rgba(10,14,31,.06);
  --navy:#0E1B3D; --second:#2D5BDF; --second-lt:#5C82EE; --third:#6B3FA0;
  --accent:#F7B32B; --accent-2:#FFD24D;
  --sh-card:0 1px 2px rgba(16,27,61,.05),0 14px 36px -16px rgba(16,27,61,.18);
  --sh-soft:0 2px 8px rgba(16,27,61,.06),0 36px 70px -34px rgba(16,27,61,.30);
  /* шрифти, --r-pill, --host-gap — ті самі */
}
```
- `.page` — просто `background:var(--bg)`, без сітки/glow/шуму.
- `.shell{background:var(--card);border:1px solid var(--brd-soft);box-shadow:var(--sh-card)}`,
  лінія зверху — `rgba(45,91,223,.28)`.
- Градієнт заголовка — темний: `linear-gradient(96deg,var(--second) 0%,var(--third) 55%,var(--navy) 100%)`.
- `.tag`, `.chip` — білі з рамкою `--brd`; `.vframe` має `padding:8px` і внутрішній радіус `.7rem`.
- Логотипи — без фільтрів, `opacity:.95`.

Коли яку тему брати: dark — для tech/AI/фінансів/преміум-послуг та коли креативи темні;
light — для медицини, освіти, дитячих, б’юті, e-commerce та коли лого клієнта кольорове
й погано читається на темному. Якщо клієнт має свій сайт — бери тему сайту.

## 4. Ребрендинг під клієнта (алгоритм)

1. **Акцент** (`--accent/--accent-2`) — головний колір бренду. Якщо бренд-колір темний
   (бордо, темно-синій) — акцентом роби його світлішу версію, а темний віддай `--second`.
2. **Другий колір градієнта** (`--second/--second-lt`) — контрастний до акценту. Для
   монобрендів: акцент + білий + світлий відтінок акценту.
3. **Градієнт `.grad`** завжди 3 стопи: `accent-2 → #fff (dark) / navy (light) → second-lt`.
   Середній стоп дає читабельність курсиву на будь-якому фоні.
4. **Glow-плями** фарбуй у `--accent` і `--second` з тими ж alpha. Не збільшуй alpha > .35 —
   зʼявляється «дискотека».
5. **Шрифти** лишай (Montserrat/Jost/Inter/JetBrains Mono) — вони підібрані під кегль
   12–34px на мобільному. Міняй тільки якщо у клієнта є брендбук зі шрифтами з Google Fonts;
   тоді: heading → `--f-head`, display/italic → `--f-disp`, text → `--f-body`. Моно не міняй.
6. **Лого**: SVG інлайном (fill під тему через плейсхолдер `{{asset:logo.svg|fill=#…}}`)
   або PNG з прозорим фоном висотою 21–28px. На темній темі кольорове лого можна
   знебарвити: `filter:brightness(0) invert(1)`.
7. Все інше (радіуси, тіні, відступи, кеглі) — не чіпай. Це і є «формат LGT».

## 5. Типографіка (кеглі підібрані під 560px)

| Елемент | Шрифт | Кегль | Інше |
|---|---|---|---|
| `.tag` | mono | 9px | letter-spacing .22em, uppercase |
| `h1.hero` | head 800 | clamp(23px,6.6vw,34px) | line-height 1.1, letter-spacing -.04em |
| `h1 .grad` | disp italic | той самий | градієнт, `box-decoration-break:clone` |
| `h1 .tail` | body 600 | .62em | колір ink-2 (ціна/гарантія «тихо») |
| `h2` частин 2+ | head 800 | clamp(20px,5.4vw,28px) | |
| `.vcap` | mono | 9px | uppercase, ink-3 |
| `.chip` | body 600 | 12.5px | |
| `.subproof` | body | 11.5px | центр, числа `<b>` |
| `.getlist .gh` | body 700 | 13.5px | |
| `.getlist li`, `.bitem p` | body | 12.5–13.5px | line-height 1.4–1.5 |
| `.getlist .q`, `.p2-q` | body | inherit | `rgba(235,235,235,.5)` — «[зазвичай $999]» |

Правило акцентів у тексті: `<b>` — білий/ink-0 600; квадратні дужки `[…]` — приглушений
`.q`; ціни й цифри в `.tail .num` — `--f-disp` 700, `white-space:nowrap`.

## 6. Відступи (вертикальний ритм)

brandbar → shell: 8px · tag → h1: 11–12px · h1 → sub: 4–6px · sub → медіа: 14px
(або `.vwrap{margin-top:34px}` коли над відео стоїть `.msgr-bar` 24px) · медіа → vcap: 7–9px ·
vcap → chips: 11–13px · chips → subproof: 13–14px · subproof → logos: 10px · logos → getlist: 14px ·
пункти списку між собою: 7–8px (getlist) / 13px (чекліст).

## 7. Анімації

- `.tag .dot` — `pulse 2s infinite` (scale .7 / opacity .4).
- `.logos-tr` — `lsc 40–42s linear infinite` `translateX(0 → -50%)`; доріжка продублена.
- Все під `@media(prefers-reduced-motion:reduce)` вимикається.
- Нічого більше не анімуй: LGT має вантажитися і читатися миттєво.
