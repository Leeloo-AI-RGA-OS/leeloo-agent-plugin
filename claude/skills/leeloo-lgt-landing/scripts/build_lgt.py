#!/usr/bin/env python3
"""
build_lgt.py — збирає фінальний HTML екрана LGT (Leeloo.ai) з вихідника з плейсхолдерами.

Плейсхолдери у вихіднику:
  {{asset:logo.png}}                    -> data:image/...;base64,...  (файл шукається в --asset-dir, потім у skill/assets)
  {{asset:logo.svg}}                    -> inline <svg> (щоб можна було керувати fill через CSS)
  {{asset:logo.svg|fill=#0E1B3D}}       -> inline <svg> з заміненим fill
  {{msgr-bar}}                          -> універсальна смужка іконок месенджерів (WhatsApp…Gmail · 24/7/365)
  {{logos:a.png,b.png,c.png}}           -> подвоєна доріжка логотипів для .logos-tr (файли клієнта з --asset-dir)
  {{logos:a.png,b.png|mono}}            -> те ж, кожному <img> клас mono (знебарвлення на темній темі)
  {{logos:https://…/1.png,https://…/2.png}} -> доріжка з URL (без інлайну)

Перевірки (--check увімкнено за замовчуванням):
  - збалансовані <style>/<script>/<div>
  - --part 1: є хак відступу хоста (--host-gap або .adaptive-container{top:-60px})
  - --part 2+: немає :root/html/body селекторів; усі класи та @keyframes мають --prefix (напр. p2-)
  - є <meta name="robots" content="noindex,nofollow">
  - немає localStorage/sessionStorage/<form>
  - не лишилось {{плейсхолдерів}}; розмір результату (попередження > 300 KB)

Використання:
  python scripts/build_lgt.py part1.src.html --part 1 --asset-dir ./client-assets -o part1.html
  python scripts/build_lgt.py part2.src.html --part 2 --prefix p2- -o part2.html
"""
import argparse
import base64
import mimetypes
import re
import sys
from pathlib import Path

SKILL_DIR = Path(__file__).resolve().parent.parent
SKILL_ASSETS = SKILL_DIR / "assets"
ASSET_DIRS: list[Path] = []


def data_uri(path: Path) -> str:
    mime = mimetypes.guess_type(str(path))[0] or "application/octet-stream"
    if path.suffix.lower() == ".svg":
        mime = "image/svg+xml"
    return f"data:{mime};base64,{base64.b64encode(path.read_bytes()).decode()}"


def resolve_asset(name: str) -> Path:
    p = Path(name)
    if p.is_absolute() and p.exists():
        return p
    for d in ASSET_DIRS + [Path.cwd(), SKILL_ASSETS]:
        if (d / name).exists():
            return d / name
    raise FileNotFoundError(f"asset not found: {name} (шукав у {[str(d) for d in ASSET_DIRS]}, cwd, {SKILL_ASSETS})")


def inline_svg(path: Path, fill: str | None) -> str:
    svg = path.read_text(encoding="utf-8")
    if fill:
        svg = re.sub(r'fill="#[0-9A-Fa-f]{3,8}"', f'fill="{fill}"', svg)
    return svg


def img_src(item: str) -> str:
    item = item.strip()
    if re.match(r"^https?://", item):
        return item
    return data_uri(resolve_asset(item))


def logos_track(spec: str) -> str:
    """Внутрішній HTML для <div class="logos-tr">…</div>. Подвоюється, бо анімація translateX(-50%) циклиться безшовно."""
    files, _, flag = spec.partition("|")
    cls = f' class="{flag.strip()}"' if flag.strip() else ""
    items = [f'<img{cls} src="{img_src(f)}" alt="">' for f in files.split(",") if f.strip()]
    if len(items) < 4:
        print("⚠ логотипів менше 4 — marquee виглядатиме порожньо; додай ще або прибери блок .logos")
    once = "".join(items)
    return once + once


def substitute(html: str) -> str:
    def repl_asset(m):
        name, _, opts = m.group(1).partition("|")
        path = resolve_asset(name.strip())
        if path.suffix.lower() == ".svg":
            fm = re.search(r"fill=([^,]+)", opts)
            return inline_svg(path, fm.group(1).strip() if fm else None)
        return data_uri(path)

    # HTML-коментарі прибираємо: у вставленому блоку вони — шум, а плейсхолдери всередині
    # коментарів (підказки з шаблону) не повинні тягнути неіснуючі файли.
    html = re.sub(r"<!--.*?-->", "", html, flags=re.S)
    html = re.sub(r"\{\{asset:([^}]+)\}\}", repl_asset, html)
    html = html.replace("{{msgr-bar}}", data_uri(SKILL_ASSETS / "msgr-bar.png"))
    html = re.sub(r"\{\{logos:([^}]+)\}\}", lambda m: logos_track(m.group(1)), html)
    return html


def check(html: str, part: int, prefix: str | None) -> list[str]:
    problems = []
    css = "\n".join(re.findall(r"<style[^>]*>(.*?)</style>", html, re.S))

    for tag in ("style", "script", "div"):
        o = len(re.findall(rf"<{tag}\b[^>]*(?<!/)>", html))
        c = len(re.findall(rf"</{tag}\s*>", html))
        if o != c:
            problems.append(f"незбалансований <{tag}>: відкрито {o}, закрито {c}")

    if 'name="robots"' not in html:
        problems.append('немає <meta name="robots" content="noindex,nofollow">')
    if re.search(r"\b(localStorage|sessionStorage)\b", html):
        problems.append("використано localStorage/sessionStorage — у LGT заборонено")
    if re.search(r"<form\b", html, re.I):
        problems.append("знайдено <form> — форму підписки рендерить Leeloo, свою верстати не треба")
    if "{{" in html:
        problems.append(f"лишилися плейсхолдери: {sorted(set(re.findall(r'\{\{[^}]*\}\}', html)))}")

    if part == 1:
        if "--host-gap" not in css and ".adaptive-container" not in css:
            problems.append("part 1: немає хаку відступу хоста (--host-gap або .adaptive-container{top:-60px})")
    else:
        if re.search(r"(^|[\s}])(:root|html|body)\s*[{,]", css):
            problems.append(f"part {part}: знайдено :root/html/body селектор — у частинах 2+ заборонено (перебʼє part 1)")
        if not prefix:
            problems.append(f"part {part}: не вказано --prefix для перевірки скоупу класів")
        else:
            pre = prefix.rstrip("-") + "-"
            css_noturl = re.sub(r"url\([^)]*\)", "", css)
            bad = sorted({c for c in re.findall(r"\.([A-Za-z_][\w-]*)", css_noturl)
                          if not c.startswith(pre) and c not in ("g", "ar", "mono", "orig")})
            if bad:
                problems.append(f"part {part}: неспрефіксовані класи в CSS: {bad[:15]}")
            if re.search(r"@keyframes\s+(?!" + re.escape(prefix.rstrip('-')) + r")", css):
                problems.append(f"part {part}: @keyframes без префікса — зіткнеться з part 1")
    return problems


def main():
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("src")
    ap.add_argument("-o", "--out")
    ap.add_argument("--part", type=int, default=1, help="номер екрана (1 = перший HTML-блок сторінки)")
    ap.add_argument("--prefix", help="префікс класів для part 2+ (напр. p2-)")
    ap.add_argument("--asset-dir", action="append", default=[], help="папка з файлами клієнта (лого, фото, логотипи); можна кілька")
    ap.add_argument("--no-check", action="store_true")
    a = ap.parse_args()
    ASSET_DIRS.extend(Path(d) for d in a.asset_dir)

    src = Path(a.src)
    html = substitute(src.read_text(encoding="utf-8"))
    out = Path(a.out) if a.out else src.with_suffix(".built.html")
    out.write_text(html, encoding="utf-8")

    size = out.stat().st_size
    print(f"✔ записано {out}  ({size/1024:.1f} KB)")
    if size > 300 * 1024:
        print("⚠ розмір > 300 KB — стисни фото (WebP ≤ 1200px) або віддай їх за URL; HTML-блок Leeloo стає повільним")

    if not a.no_check:
        probs = check(html, a.part, a.prefix)
        if probs:
            print("Перевірка знайшла проблеми:")
            for p in probs:
                print("  ✖", p)
            sys.exit(1)
        print("✔ перевірка пройдена")


if __name__ == "__main__":
    main()
