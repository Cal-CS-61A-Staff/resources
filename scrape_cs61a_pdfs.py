#!/usr/bin/env python3
from __future__ import annotations

import os
import re
import sys
from pathlib import Path
from urllib.parse import urljoin
from urllib.request import Request, urlopen


ROOT_URL = "https://cs61a.org/resources/"
ROOT = Path(__file__).resolve().parent

ROW_RE = re.compile(r"<tr><td>(Summer|Spring|Fall)\s+(\d{4})</td><td>.*?</tr>", re.S)
LINK_RE = re.compile(r'<a href="([^"]+)"[^>]*>(Exam|Solutions)</a>')


def fetch(url: str) -> str:
    req = Request(url, headers={"User-Agent": "Mozilla/5.0"})
    with urlopen(req) as resp:
        return resp.read().decode("utf-8", errors="replace")


def download(url: str, dest: Path) -> None:
    dest.parent.mkdir(parents=True, exist_ok=True)
    req = Request(url, headers={"User-Agent": "Mozilla/5.0"})
    with urlopen(req) as resp, open(dest, "wb") as f:
        f.write(resp.read())


def semester_code(season: str, year: str) -> str:
    return {"Summer": "su", "Spring": "sp", "Fall": "fa"}[season] + year[2:]


def semester_rank(code: str) -> tuple[int, int]:
    season = code[:2]
    year = int("20" + code[2:])
    season_order = {"sp": 0, "su": 1, "fa": 2}
    return year, season_order[season]


def normalized_stem(semester: str, category: str, is_solution: bool) -> str:
    exam_name = category
    if semester.startswith("su") and category == "mt1":
        exam_name = "midterm"
    suffix = "_sol" if is_solution else ""
    return f"61a-{semester}-{exam_name}{suffix}"


def output_name(url: str, semester: str, category: str, is_solution: bool) -> str:
    ext = Path(url.split("?", 1)[0]).suffix
    if not ext:
        ext = ".pdf"
    return normalized_stem(semester, category, is_solution) + ext


def main() -> int:
    html = fetch(ROOT_URL)
    archive_html = html.split('<div id="past-mock-exams-"', 1)[0]
    rows = ROW_RE.findall(archive_html)
    if not rows:
        print("No archive rows found.", file=sys.stderr)
        return 1

    downloads: list[tuple[str, str, str]] = []
    for match in ROW_RE.finditer(archive_html):
        season, year = match.group(1), match.group(2)
        semester = semester_code(season, year)
        if semester_rank(semester) < semester_rank("fa14") or semester_rank(semester) > semester_rank("fa26"):
            continue

        row_html = match.group(0)
        links = LINK_RE.findall(row_html)
        if not links:
            continue

        categories = ["mt1", "mt2", "final"] if season != "Summer" else ["mt1", "final"]
        for idx, category in enumerate(categories):
            pair = links[idx * 2 : idx * 2 + 2]
            if len(pair) != 2:
                continue
            for href, label in pair:
                downloads.append((semester, category, label == "Solutions", urljoin(ROOT_URL, href)))

    if not downloads:
        print("No downloads discovered.", file=sys.stderr)
        return 1

    for semester, category, is_solution, url in downloads:
        dest_dir = ROOT / semester / category
        filename = output_name(url, semester, category, is_solution)
        dest = dest_dir / filename
        print(f"{semester}/{category}: {filename}")
        download(url, dest)

    return 0


if __name__ == "__main__":
    raise SystemExit(main())
