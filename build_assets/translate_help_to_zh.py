import argparse
import html
import http.client
import json
import os
import re
import shutil
import time
import urllib.error
import urllib.parse
import urllib.request
from html.parser import HTMLParser
from pathlib import Path


SKIP_TAGS = {"script", "style", "font"}
TRANSLATE_ATTRS = {"title", "alt"}
GLOSSARY = {
    "CONTAM": "__TERM_CONTAM__",
    "ContamW": "__TERM_CONTAMW__",
    "SketchPad": "__TERM_SKETCHPAD__",
    "CFD": "__TERM_CFD__",
    "AHS": "__TERM_AHS__",
    "WPC": "__TERM_WPC__",
    "CVF": "__TERM_CVF__",
    "DVF": "__TERM_DVF__",
    "PRJ": "__TERM_PRJ__",
    "CHM": "__TERM_CHM__",
    "NIST": "__TERM_NIST__",
    "Ctrl+S": "__TERM_CTRLS__",
    "Ctrl+O": "__TERM_CTRLO__",
    "Ctrl+T": "__TERM_CTRLT__",
}


def should_translate(text: str) -> bool:
    core = text.strip()
    if not core:
        return False
    if core == "\xa0":
        return False
    if re.fullmatch(r"[\W_]+", core):
        return False
    if re.fullmatch(r"[0-9.]+", core):
        return False
    if re.fullmatch(r"[A-Z0-9/_+\-.]{1,6}", core):
        return False
    if re.fullmatch(r"[A-Za-z0-9_./:+\\<>=()\-\[\],;#%&^|~* ]+", core) and len(core) < 4:
        return False
    return bool(re.search(r"[A-Za-z]", core))


def protect_terms(text: str) -> str:
    for src, token in GLOSSARY.items():
        text = text.replace(src, token)
    return text


def restore_terms(text: str) -> str:
    for src, token in GLOSSARY.items():
        text = text.replace(token, src)
    return text


def post_process(text: str) -> str:
    fixes = {
        "__TERM_CONTAM__": "CONTAM",
        "__TERM_CONTAMW__": "ContamW",
        "__TERM_SKETCHPAD__": "SketchPad",
        "__TERM_CFD__": "CFD",
        "__TERM_AHS__": "AHS",
        "__TERM_WPC__": "WPC",
        "__TERM_CVF__": "CVF",
        "__TERM_DVF__": "DVF",
        "__TERM_PRJ__": "PRJ",
        "__TERM_CHM__": "CHM",
        "__TERM_NIST__": "NIST",
        "__TERM_CTRLS__": "Ctrl+S",
        "__TERM_CTRLO__": "Ctrl+O",
        "__TERM_CTRLT__": "Ctrl+T",
        "__术语_CONTAM__": "CONTAM",
        "__术语_CONTAMW__": "ContamW",
        "__术语_NIST__": "NIST",
        "__术语_CTRLS__": "Ctrl+S",
        "__术语_CTRLO__": "Ctrl+O",
        "__术语_CTRLT__": "Ctrl+T",
        "__术语_差价合约__": "CFD",
        "__术语画板__": "SketchPad",
        "__术语_画板__": "SketchPad",
        "__学期_AHS__": "AHS",
        "AHS__INFO_MSGTYPE": "AHS_INFO_MSGTYPE",
        "AHS__排气_": "AHS_exhaust_",
        "AHS__Schematic.gif": "AHS_Schematic.gif",
        "图形用户界面": "图形界面",
        "污染物扩散": "污染物扩散",
        "气流和污染物扩散分析": "气流与污染物扩散分析",
        "项目文件": "项目文件",
        "浮动状态栏": "浮动状态栏",
        "结果查看模式": "结果查看模式",
        "空气处理系统": "空气处理系统",
        "气流路径": "气流路径",
        "区域": "房间",
        "空气龄": "空气龄",
        "箱须图": "箱线图",
        "超级元素": "超元件",
        "气流元素": "气流元件",
        "源/接收器": "源/汇",
        "细胞": "单元",
        "康塔姆": "CONTAM",
        "绘图房间": "绘图区",
        "矩形房间": "矩形区域",
        "插入符号房间": "光标附近",
        "光标附近中": "光标附近",
        "状态栏是主窗口底部SketchPad下方显示的房间": "状态栏是主窗口底部、SketchPad 下方显示的区域",
        "该房间分为三个独立的窗格": "该区域分为三个独立的窗格",
        "此房间": "此区域",
        "该房间": "该区域",
        "normal mode": "常规模式",
        "results mode": "结果模式",
        "图-": "图 - ",
        "ContamW 工具栏": "ContamW 工具栏",
    }
    for src, dst in fixes.items():
        text = text.replace(src, dst)
    return text


def fetch_translation(payload: str) -> str:
    params = urllib.parse.urlencode(
        {
            "client": "gtx",
            "sl": "auto",
            "tl": "zh-CN",
            "dt": "t",
            "q": payload,
        }
    )
    req = urllib.request.Request(
        "https://translate.googleapis.com/translate_a/single?" + params,
        headers={"User-Agent": "Mozilla/5.0"},
    )
    with urllib.request.urlopen(req, timeout=30) as resp:
        data = json.loads(resp.read().decode("utf-8"))
    return "".join(part[0] for part in data[0])


def translate_batch(lines):
    sep = "\nZXQSEPZXQ\n"
    payload = sep.join(protect_terms(line) for line in lines)
    translated = None
    for attempt in range(5):
        try:
            translated = fetch_translation(payload)
            break
        except (urllib.error.URLError, ConnectionError, TimeoutError, http.client.HTTPException):
            time.sleep(1 + attempt)
    if translated is None:
        raise RuntimeError("batch translation failed after retries")
    out = translated.split("ZXQSEPZXQ")
    if len(out) != len(lines):
        out = []
        for line in lines:
            single = None
            for attempt in range(5):
                try:
                    single = fetch_translation(protect_terms(line))
                    break
                except (urllib.error.URLError, ConnectionError, TimeoutError, http.client.HTTPException):
                    time.sleep(1 + attempt)
            if single is None:
                raise RuntimeError(f"single translation failed: {line[:80]}")
            out.append(single)
            time.sleep(0.05)
    return [post_process(restore_terms(item)) for item in out]


def translate_texts(strings, cache, cache_path: Path):
    pending = [s for s in strings if s not in cache]
    batch = []
    batch_chars = 0
    processed = 0
    for item in pending:
        size = len(item) + 1
        if batch and batch_chars + size > 2800:
            results = translate_batch(batch)
            for src, dst in zip(batch, results):
                cache[src] = dst
            cache_path.write_text(json.dumps(cache, ensure_ascii=False, indent=2), encoding="utf-8")
            processed += len(batch)
            print(f"translate: {processed}/{len(pending)}")
            batch = []
            batch_chars = 0
            time.sleep(0.2)
        batch.append(item)
        batch_chars += size
    if batch:
        results = translate_batch(batch)
        for src, dst in zip(batch, results):
            cache[src] = dst
        cache_path.write_text(json.dumps(cache, ensure_ascii=False, indent=2), encoding="utf-8")
        processed += len(batch)
        print(f"translate: {processed}/{len(pending)}")
    return cache


def preserve_whitespace(src: str, dst: str) -> str:
    leading = re.match(r"^\s*", src).group(0)
    trailing = re.search(r"\s*$", src).group(0)
    return leading + dst + trailing


def translate_segment(text: str, cache) -> str:
    core = text.strip()
    if not should_translate(core):
        return text
    if core in cache:
        return preserve_whitespace(text, post_process(cache[core]))
    return text


class HelpTranslator(HTMLParser):
    def __init__(self, cache):
        super().__init__(convert_charrefs=False)
        self.cache = cache
        self.out = []
        self.stack = []

    def _tag_text_enabled(self):
        return not any(tag in SKIP_TAGS for tag in self.stack)

    def handle_starttag(self, tag, attrs):
        self.stack.append(tag)
        self.out.append("<" + tag)
        attr_map = dict(attrs)
        new_attrs = []
        for name, value in attrs:
            if value is None:
                new_attrs.append((name, value))
                continue
            new_value = value
            if name in TRANSLATE_ATTRS and should_translate(value):
                new_value = post_process(self.cache.get(value.strip(), value))
            if tag == "param" and attr_map.get("name") == "Name" and name == "value" and should_translate(value):
                new_value = post_process(self.cache.get(value.strip(), value))
            if tag == "meta" and name.lower() == "content" and "charset=" in value.lower():
                new_value = re.sub(r"charset\s*=\s*[-A-Za-z0-9_]+", "charset=UTF-8", value, flags=re.I)
            new_attrs.append((name, new_value))
        for name, value in new_attrs:
            if value is None:
                self.out.append(f" {name}")
            else:
                self.out.append(f' {name}="{html.escape(value, quote=True)}"')
        self.out.append(">")

    def handle_startendtag(self, tag, attrs):
        self.out.append("<" + tag)
        attr_map = dict(attrs)
        for name, value in attrs:
            if value is None:
                self.out.append(f" {name}")
                continue
            new_value = value
            if name in TRANSLATE_ATTRS and should_translate(value):
                new_value = post_process(self.cache.get(value.strip(), value))
            if tag == "param" and attr_map.get("name") == "Name" and name == "value" and should_translate(value):
                new_value = post_process(self.cache.get(value.strip(), value))
            if tag == "meta" and name.lower() == "content" and "charset=" in value.lower():
                new_value = re.sub(r"charset\s*=\s*[-A-Za-z0-9_]+", "charset=UTF-8", value, flags=re.I)
            self.out.append(f' {name}="{html.escape(new_value, quote=True)}"')
        self.out.append(" />")

    def handle_endtag(self, tag):
        if self.stack:
            self.stack.pop()
        self.out.append(f"</{tag}>")

    def handle_data(self, data):
        if self._tag_text_enabled():
            self.out.append(translate_segment(data, self.cache))
        else:
            self.out.append(data)

    def handle_entityref(self, name):
        self.out.append(f"&{name};")

    def handle_charref(self, name):
        self.out.append(f"&#{name};")

    def handle_comment(self, data):
        self.out.append(f"<!--{data}-->")

    def handle_decl(self, decl):
        self.out.append(f"<!{decl}>")

    def handle_pi(self, data):
        self.out.append(f"<?{data}>")

    def unknown_decl(self, data):
        self.out.append(f"<![{data}]>")

    def rendered(self):
        return "".join(self.out)


def collect_html_strings(text: str):
    class Collector(HTMLParser):
        def __init__(self):
            super().__init__(convert_charrefs=False)
            self.stack = []
            self.attr_map_stack = []
            self.items = []

        def handle_starttag(self, tag, attrs):
            self.stack.append(tag)
            amap = dict(attrs)
            self.attr_map_stack.append(amap)
            for name, value in attrs:
                if value is None:
                    continue
                if name in TRANSLATE_ATTRS and should_translate(value):
                    self.items.append(value.strip())
                if tag == "param" and amap.get("name") == "Name" and name == "value" and should_translate(value):
                    self.items.append(value.strip())

        def handle_startendtag(self, tag, attrs):
            amap = dict(attrs)
            for name, value in attrs:
                if value is None:
                    continue
                if name in TRANSLATE_ATTRS and should_translate(value):
                    self.items.append(value.strip())
                if tag == "param" and amap.get("name") == "Name" and name == "value" and should_translate(value):
                    self.items.append(value.strip())

        def handle_endtag(self, tag):
            if self.stack:
                self.stack.pop()
            if self.attr_map_stack:
                self.attr_map_stack.pop()

        def handle_data(self, data):
            if any(tag in SKIP_TAGS for tag in self.stack):
                return
            if should_translate(data):
                self.items.append(data.strip())

    parser = Collector()
    parser.feed(text)
    return parser.items


def write_translated_html(src_path: Path, dst_path: Path, cache):
    raw = src_path.read_text(encoding="cp1252", errors="ignore")
    parser = HelpTranslator(cache)
    parser.feed(raw)
    content = parser.rendered()
    content = re.sub(
        r'encoding="[^"]+"',
        'encoding="utf-8"',
        content,
        count=1,
        flags=re.I,
    )
    content = re.sub(
        r'charset\s*=\s*[-A-Za-z0-9_]+',
        'charset=UTF-8',
        content,
        count=1,
        flags=re.I,
    )
    content = content.replace(">normal mode<", ">常规模式<")
    content = content.replace(">results mode<", ">结果模式<")
    with open(dst_path, "w", encoding="utf-8", newline="\n") as fh:
        fh.write(content)


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--source", required=True)
    ap.add_argument("--dest", required=True)
    args = ap.parse_args()

    source = Path(args.source)
    dest = Path(args.dest)
    cache_path = dest.parent / f"{dest.name}_translation_cache_zh.json"

    if cache_path.exists():
        cache = json.loads(cache_path.read_text(encoding="utf-8"))
    else:
        cache = {}

    if dest.exists():
        shutil.rmtree(dest)
    shutil.copytree(source, dest)

    html_files = sorted(dest.rglob("*.htm"))
    toc_files = [dest / "_Temp.hhc", dest / "_Temp.hhk"]

    strings = set()
    for path in html_files + [p for p in toc_files if p.exists()]:
        raw = path.read_text(encoding="cp1252", errors="ignore")
        for item in collect_html_strings(raw):
            strings.add(item)

    print(f"collect: {len(strings)} unique strings")
    cache = translate_texts(sorted(strings), cache, cache_path)
    cache_path.write_text(json.dumps(cache, ensure_ascii=False, indent=2), encoding="utf-8")

    for idx, path in enumerate(html_files, start=1):
        write_translated_html(path, path, cache)
        if idx % 25 == 0 or idx == len(html_files):
            print(f"html: {idx}/{len(html_files)}")

    for path in toc_files:
        if path.exists():
            write_translated_html(path, path, cache)

    print(f"done: {dest}")


if __name__ == "__main__":
    main()
