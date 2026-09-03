#!/usr/bin/env python3
"""Recover the exam files this mirror is still missing, from archive.org.

Every target here was lost the same way: the original scrape requested an
inst.eecs.berkeley.edu URL, which now answers with the CalNet login page, and
the HTML was written out under a .pdf name. `outstanding.json` maps each
repository path to the URL it should have come from.

archive.org rate-limits raw file downloads aggressively (HTTP 429) and the
cooldown lasts tens of minutes, so this script goes slowly on purpose and is
safe to re-run: anything already valid on disk is skipped.

    python3 scripts/refetch.py
"""
from __future__ import annotations

import json
import os
import subprocess
import sys
import time
import urllib.parse

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
TARGETS = os.path.join(os.path.dirname(os.path.abspath(__file__)), "outstanding.json")
UA = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7)"
MAGIC = {".pdf": b"%PDF", ".zip": b"PK\x03\x04"}


def canonical(url: str) -> str:
    return url if url.startswith("http") else urllib.parse.urljoin("https://cs61a.org/", url)


def valid(path: str) -> bool:
    """A real exam, not a login page: right magic bytes and a plausible size."""
    if not os.path.exists(path) or os.path.getsize(path) < 2000:
        return False
    with open(path, "rb") as f:
        return f.read(4) == MAGIC[os.path.splitext(path)[1]]


def curl(url: str, dest: str | None = None, timeout: int = 180) -> str:
    cmd = ["curl", "-sL", "-A", UA, "--max-time", str(timeout)]
    if dest:
        cmd += ["-o", dest, "-w", "%{http_code}"]
    result = subprocess.run(cmd + [url], capture_output=True, text=True)
    return result.stdout.strip().splitlines()[-1] if dest else result.stdout


def snapshot(url: str) -> str | None:
    query = "https://archive.org/wayback/available?url=" + urllib.parse.quote(url, safe="")
    for _ in range(3):
        try:
            closest = json.loads(curl(query, timeout=60))["archived_snapshots"].get("closest")
            if closest and closest.get("available"):
                return closest["url"]
        except (ValueError, KeyError):
            pass
        time.sleep(15)
    return None


def fetch(url: str, dest: str) -> bool:
    snap = snapshot(url)
    if not snap:
        return False
    # `id_` asks the archive for the original bytes, without its own rewriting.
    timestamp, _, original = snap.partition("/web/")[2].partition("/")
    raw = f"https://web.archive.org/web/{timestamp}id_/{original}"
    os.makedirs(os.path.dirname(dest), exist_ok=True)
    for backoff in (90, 150, 240, 300, 300):
        if curl(raw, dest) == "200" and valid(dest):
            return True
        time.sleep(backoff)
    if os.path.exists(dest) and not valid(dest):
        os.remove(dest)
    return False


def main() -> int:
    targets = sorted(json.load(open(TARGETS)).items())
    remaining = []
    for number, (relative, url) in enumerate(targets, 1):
        dest = os.path.join(ROOT, relative)
        prefix = f"[{number}/{len(targets)}]"
        if valid(dest):
            print(f"{prefix} have {relative}", flush=True)
            continue
        if fetch(canonical(url), dest):
            print(f"{prefix} got  {os.path.getsize(dest):>9,}  {relative}", flush=True)
        else:
            remaining.append(relative)
            print(f"{prefix} MISS {relative}", flush=True)
        time.sleep(30)

    print(f"\n{len(targets) - len(remaining)}/{len(targets)} recovered", flush=True)
    for relative in remaining:
        print(f"  still missing: {relative}", flush=True)
    return 1 if remaining else 0


if __name__ == "__main__":
    sys.exit(main())
