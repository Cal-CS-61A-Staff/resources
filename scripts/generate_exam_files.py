#!/usr/bin/env python3
"""Generate ``_exams/exam_files.json`` from exam PDFs and ZIP files.

Run this script from anywhere inside the resources repository:

    python3 scripts/generate_exam_files.py

Use ``--check`` to verify that the committed manifest is current without
modifying it:

    python3 scripts/generate_exam_files.py --check
"""

from __future__ import annotations

import argparse
import hashlib
import json
import re
from pathlib import Path


REPOSITORY_ROOT = Path(__file__).resolve().parent.parent
MANIFEST_PATH = REPOSITORY_ROOT / "_exams" / "exam_files.json"
SEMESTER_DIRECTORY = re.compile(r"^(?:fa|sp|su)\d{2}$")
EXAM_EXTENSIONS = {".pdf", ".zip"}


def sha256(path: Path) -> str:
    """Return the SHA-256 digest of a file without loading it all at once."""
    digest = hashlib.sha256()
    with path.open("rb") as exam_file:
        for chunk in iter(lambda: exam_file.read(1024 * 1024), b""):
            digest.update(chunk)
    return digest.hexdigest()


def exam_paths() -> list[Path]:
    """Return all exam PDFs and ZIP files in semester directories."""
    paths = (
        path
        for directory in REPOSITORY_ROOT.iterdir()
        if directory.is_dir() and SEMESTER_DIRECTORY.fullmatch(directory.name)
        for path in directory.rglob("*")
        if path.is_file() and path.suffix.lower() in EXAM_EXTENSIONS
    )
    return sorted(paths, key=lambda path: path.relative_to(REPOSITORY_ROOT).as_posix())


def generated_manifest() -> str:
    """Return the complete, consistently formatted manifest."""
    files = [
        {
            "path": path.relative_to(REPOSITORY_ROOT).as_posix(),
            "sha": sha256(path),
        }
        for path in exam_paths()
    ]
    return json.dumps({"files": files}, indent=2) + "\n"


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "--check",
        action="store_true",
        help="fail if exam_files.json does not match the exam files",
    )
    args = parser.parse_args()
    manifest = generated_manifest()

    if args.check:
        if MANIFEST_PATH.exists() and MANIFEST_PATH.read_text(encoding="utf-8") == manifest:
            print(f"{MANIFEST_PATH.relative_to(REPOSITORY_ROOT)} is up to date")
            return 0
        print(f"{MANIFEST_PATH.relative_to(REPOSITORY_ROOT)} is out of date")
        return 1

    MANIFEST_PATH.write_text(manifest, encoding="utf-8")
    count = len(json.loads(manifest)["files"])
    print(f"Wrote {MANIFEST_PATH.relative_to(REPOSITORY_ROOT)} with {count} files")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
