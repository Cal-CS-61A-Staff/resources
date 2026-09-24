#!/usr/bin/env python3
"""Publish the resource payload into a course-site checkout.

The resources repository is the source of truth.  This script copies the
public payload into the site repository and generates the study-guide data
file from the files in ``_guides`` so adding a guide does not require a
second site PR.

Usage:
    python3 scripts/publish_site.py /path/to/fa26
"""

from __future__ import annotations

import argparse
import json
import re
import shutil
from pathlib import Path
from urllib.parse import quote


RESOURCE_DIRS = re.compile(r"(?:fa|sp|su)\d{2}$")
PAYLOAD_DIRS = ("_exams", "_guides")


def display_title(path: Path) -> str:
    """Turn a resource filename into a readable default title."""
    name = re.sub(r"\.[^.]+$", "", path.name)
    name = re.sub(r"^61a[-_]", "", name, flags=re.IGNORECASE)
    name = re.sub(r"[-_]+", " ", name)
    name = re.sub(r"\bmt([12])\b", r"Midterm \1", name, flags=re.IGNORECASE)
    return re.sub(r"\s+", " ", name).strip().title()


def copy_payload(source: Path, site: Path) -> None:
    destination = site / "assets" / "resources"
    if destination.exists():
        shutil.rmtree(destination)
    destination.mkdir(parents=True)

    for entry in sorted(source.iterdir()):
        if entry.name in PAYLOAD_DIRS:
            target_name = {"_exams": "exams", "_guides": "guides"}[entry.name]
        elif entry.is_dir() and RESOURCE_DIRS.fullmatch(entry.name):
            target_name = entry.name
        else:
            continue
        shutil.copytree(entry, destination / target_name)


def write_study_guides(source: Path, site: Path) -> None:
    guides = sorted(
        path for path in (source / "_guides").glob("*")
        if path.is_file() and path.suffix.lower() in {".pdf", ".zip"}
    )
    lines = [
        "# Generated from Cal-CS-61A-Staff/resources; do not edit manually.",
    ]
    for guide in guides:
        lines.extend(
            [
                f"- title: {json.dumps(display_title(guide))}",
                f"  url: {json.dumps('/assets/resources/guides/' + quote(guide.name))}",
            ]
        )
    data_dir = site / "_data"
    data_dir.mkdir(parents=True, exist_ok=True)
    (data_dir / "study_guides.yml").write_text("\n".join(lines) + "\n")


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("site", type=Path, help="checkout of the fa26 site")
    args = parser.parse_args()

    source = Path(__file__).resolve().parents[1]
    site = args.site.resolve()
    if not (source / "_exams").is_dir():
        raise SystemExit(f"not a resources checkout: {source}")
    if not (site / "_config.yml").is_file():
        raise SystemExit(f"not a course-site checkout: {site}")

    copy_payload(source, site)
    write_study_guides(source, site)


if __name__ == "__main__":
    main()
