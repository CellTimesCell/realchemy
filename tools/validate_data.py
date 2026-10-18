"""Validate Realchemy game data (game/data/*.json) against docs/DATA_SCHEMA.md.

Usage:
    python tools/validate_data.py [--data PATH]

Exit code 0 = no errors (warnings allowed), 1 = errors found.
Stdlib only, so it runs without extra installs.
"""
from __future__ import annotations

import argparse
import csv
import json
import sys
from pathlib import Path

PHASES = {"solid", "powder", "liquid", "gas", "paste", "object"}
FX = {"fire", "fizz", "steam", "spark", "organic", "electric", "success"}
MODES = {"cozy", "classic", "real"}
LIMIT_TYPES = {"none", "real_time", "actions"}
HOTSPOT_TYPES = {"pickup", "craft", "mine", "inspect"}
LOC_PREFIX = "loc:"
TAG_PREFIX = "tag:"


class Report:
    def __init__(self) -> None:
        self.errors: list[str] = []
        self.warnings: list[str] = []

    def error(self, where: str, msg: str) -> None:
        self.errors.append(f"ERROR {where}: {msg}")

    def warn(self, where: str, msg: str) -> None:
        self.warnings.append(f"WARN  {where}: {msg}")


class Validator:
    def __init__(self, data_dir: Path) -> None:
        self.data_dir = data_dir
        self.report = Report()
        self.substances: dict = {}
        self.tags: set[str] | None = None
        self.loc_keys: set[str] | None = None

    # --- loading ---------------------------------------------------------

    def load_json(self, path: Path, required: bool):
        rel = self.rel(path)
        if not path.exists():
            if required:
                self.report.error(rel, "file not found")
            return None
        try:
            return json.loads(path.read_text(encoding="utf-8"))
        except json.JSONDecodeError as e:
            self.report.error(rel, f"invalid JSON: {e}")
            return None

    def load_tags(self) -> None:
        raw = self.load_json(self.data_dir / "tags.json", required=False)
        if raw is None:
            return
        if isinstance(raw, list) and all(isinstance(t, str) for t in raw):
            self.tags = set(raw)
        elif isinstance(raw, dict):
            self.tags = set(raw.keys())
        else:
            self.report.error("tags.json", "must be a list of strings or an object keyed by tag")

    def load_loc_keys(self) -> None:
        path = self.data_dir / "i18n" / "en.csv"
        if not path.exists():
            return
        with path.open(encoding="utf-8", newline="") as f:
            rows = list(csv.reader(f))
        # Godot translation CSV: first row is header ("keys", "en", ...).
        self.loc_keys = {row[0] for row in rows[1:] if row}

    def rel(self, path: Path) -> str:
        try:
            return path.relative_to(self.data_dir).as_posix()
        except ValueError:
            return path.as_posix()

    # --- field checks ----------------------------------------------------

    def check_text(self, where: str, field: str, value, required: bool) -> None:
        """Player-facing text: "loc:key" (v1.1) or {lang: str} (v1.0)."""
        if value is None:
            if required:
                self.report.error(where, f"missing '{field}'")
            return
        if isinstance(value, str):
            if not value.startswith(LOC_PREFIX) or len(value) == len(LOC_PREFIX):
                self.report.error(where, f"'{field}' must be 'loc:<key>' or {{lang: text}}")
            elif self.loc_keys is not None and value[len(LOC_PREFIX):] not in self.loc_keys:
                self.report.error(where, f"'{field}' key '{value}' not in i18n/en.csv")
        elif isinstance(value, dict):
            if not value or not all(isinstance(k, str) and isinstance(v, str) and v.strip()
                                    for k, v in value.items()):
                self.report.error(where, f"'{field}' must map language codes to non-empty text")
        else:
            self.report.error(where, f"'{field}' must be 'loc:<key>' or {{lang: text}}")

    def check_tag(self, where: str, tag: str) -> None:
        if self.tags is not None and tag not in self.tags:
            self.report.error(where, f"unknown tag '{tag}' (not in tags.json)")

    def check_id_list(self, where: str, field: str, value, allow_tags: bool = False) -> list:
        if not isinstance(value, list):
            self.report.error(where, f"'{field}' must be a list")
            return []
        for ref in value:
            if not isinstance(ref, str):
                self.report.error(where, f"'{field}' entries must be strings")
            elif allow_tags and ref.startswith(TAG_PREFIX):
                self.check_tag(where, ref[len(TAG_PREFIX):])
            elif ref not in self.substances:
                self.report.error(where, f"'{field}' references unknown substance '{ref}'")
        return value

    def check_zone(self, where: str, zone_id) -> None:
        if not isinstance(zone_id, str):
            self.report.error(where, "zone must be a substance id string")
        elif zone_id not in self.substances:
            self.report.error(where, f"unknown zone '{zone_id}'")
        elif not self.substances[zone_id].get("is_zone"):
            self.report.error(where, f"zone '{zone_id}' is not marked is_zone")

    # --- files -----------------------------------------------------------

    def validate_substances(self) -> None:
        raw = self.load_json(self.data_dir / "substances.json", required=True)
        if raw is None:
            return
        if not isinstance(raw, dict):
            self.report.error("substances.json", "top level must be an object keyed by id")
            return
        if self.tags is None:
            self.report.warn("tags.json", "not found, tag names are not checked")
        self.substances = {k: v for k, v in raw.items() if isinstance(v, dict)}
        for sid, s in raw.items():
            where = f"substances.json:{sid}"
            if not isinstance(s, dict):
                self.report.error(where, "entry must be an object")
                continue
            self.check_text(where, "name", s.get("name"), required=True)
            if s.get("phase") not in PHASES:
                self.report.error(where, f"'phase' must be one of {sorted(PHASES)}")
            tags = s.get("tags")
            if not isinstance(tags, list) or not all(isinstance(t, str) for t in tags):
                self.report.error(where, "'tags' must be a list of strings")
            else:
                for t in tags:
                    self.check_tag(where, t)
            formula = s.get("formula")
            if formula is not None and not isinstance(formula, str):
                self.report.error(where, "'formula' must be a string or null")
            for flag in ("is_zone", "is_tool"):
                if flag in s and not isinstance(s[flag], bool):
                    self.report.error(where, f"'{flag}' must be a boolean")
            self.check_text(where, "codex", s.get("codex"), required=False)

    def validate_reactions(self) -> None:
        raw = self.load_json(self.data_dir / "reactions.json", required=True)
        if raw is None:
            return
        if not isinstance(raw, dict):
            self.report.error("reactions.json", "top level must be an object keyed by id")
            return
        unverified = []
        for rid, r in raw.items():
            where = f"reactions.json:{rid}"
            if not isinstance(r, dict):
                self.report.error(where, "entry must be an object")
                continue
            inputs = self.check_id_list(where, "inputs", r.get("inputs"), allow_tags=True)
            if not inputs:
                self.report.error(where, "'inputs' must not be empty")
            outputs = self.check_id_list(where, "outputs", r.get("outputs", []))
            consumes = self.check_id_list(where, "consumes", r.get("consumes", []))
            for c in consumes:
                if c not in inputs:
                    self.report.error(where, f"consumes '{c}' which is not an input")
                elif self.substances.get(c, {}).get("is_tool"):
                    self.report.error(where, f"consumes tool '{c}' (tools are never consumed)")
            if not outputs:
                self.report.warn(where, "no outputs")
            if r.get("zone") is not None:
                self.check_zone(where, r["zone"])
            self.check_duration(where, r.get("duration"))
            if "fx" in r and r["fx"] not in FX:
                self.report.error(where, f"'fx' must be one of {sorted(FX)}")
            if "modes" in r:
                modes = r["modes"]
                if not isinstance(modes, list) or not modes or not set(modes) <= MODES:
                    self.report.error(where, f"'modes' must be a non-empty subset of {sorted(MODES)}")
            if "action" in r and not isinstance(r["action"], str):
                self.report.error(where, "'action' must be a string")
            self.check_text(where, "science_note", r.get("science_note"), required=True)
            self.check_text(where, "flavor", r.get("flavor"), required=True)
            verified = r.get("verified", False)
            if not isinstance(verified, bool):
                self.report.error(where, "'verified' must be a boolean")
            elif not verified:
                unverified.append(rid)
        if unverified:
            self.report.warn("reactions.json", f"verified:false (needs review): {', '.join(unverified)}")

    def check_duration(self, where: str, duration) -> None:
        if duration is None:
            return
        if not isinstance(duration, dict):
            self.report.error(where, "'duration' must be an object")
            return
        secs = duration.get("game_seconds")
        if not isinstance(secs, int) or isinstance(secs, bool) or secs < 0:
            self.report.error(where, "'duration.game_seconds' must be an integer >= 0")

    def validate_cases(self) -> None:
        cases_dir = self.data_dir / "cases"
        files = sorted(cases_dir.glob("*.json")) if cases_dir.is_dir() else []
        if not files:
            self.report.warn("cases/", "no case files")
        for path in files:
            case = self.load_json(path, required=True)
            if case is None:
                continue
            where = self.rel(path)
            if not isinstance(case, dict):
                self.report.error(where, "top level must be an object")
                continue
            self.validate_case(where, path.stem, case)

    def validate_case(self, where: str, stem: str, case: dict) -> None:
        if case.get("id") != stem:
            self.report.error(where, f"'id' must match file name '{stem}'")
        self.check_text(where, "title", case.get("title"), required=True)
        self.check_text(where, "story", case.get("story"), required=True)
        start = self.check_id_list(where, "start_items", case.get("start_items"))
        if not start:
            self.report.error(where, "'start_items' must not be empty")
        self.check_id_list(where, "item_pool", case.get("item_pool", []))
        for z in case.get("zones", []):
            self.check_zone(where, z)
        goals = case.get("goals")
        if not isinstance(goals, list) or not goals:
            self.report.error(where, "'goals' must be a non-empty list")
        else:
            for g in goals:
                if not isinstance(g, dict) or g.get("item") not in self.substances:
                    self.report.error(where, f"goal references unknown item: {g}")
                elif not isinstance(g.get("count", 1), int) or g.get("count", 1) < 1:
                    self.report.error(where, f"goal count must be an integer >= 1: {g}")
        limit = case.get("limit")
        if limit is not None and (not isinstance(limit, dict) or limit.get("type") not in LIMIT_TYPES):
            self.report.error(where, f"'limit.type' must be one of {sorted(LIMIT_TYPES)}")
        deadline = case.get("deadline")
        if deadline is not None:
            if not isinstance(deadline, dict) or deadline.get("mode") != "real" \
                    or not isinstance(deadline.get("seconds"), int) or deadline["seconds"] <= 0:
                self.report.error(where, "'deadline' must be {mode: 'real', seconds: int > 0}")
        self.validate_hotspots(where, case.get("hotspots", []))
        for i, hint in enumerate(case.get("hints", [])):
            self.check_text(where, f"hints[{i}]", hint, required=True)

    def validate_hotspots(self, where: str, hotspots) -> None:
        if not isinstance(hotspots, list):
            self.report.error(where, "'hotspots' must be a list")
            return
        seen: set[str] = set()
        for h in hotspots:
            if not isinstance(h, dict) or not isinstance(h.get("id"), str):
                self.report.error(where, f"hotspot must be an object with string 'id': {h}")
                continue
            if h["id"] in seen:
                self.report.error(where, f"duplicate hotspot id '{h['id']}'")
            seen.add(h["id"])
            if h.get("type") not in HOTSPOT_TYPES:
                self.report.error(where, f"hotspot '{h['id']}' type must be one of {sorted(HOTSPOT_TYPES)}")

    def run(self) -> Report:
        self.load_tags()
        self.load_loc_keys()
        self.validate_substances()
        self.validate_reactions()
        self.validate_cases()
        return self.report


def main(argv: list[str] | None = None) -> int:
    default = Path(__file__).resolve().parent.parent / "game" / "data"
    parser = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    parser.add_argument("--data", type=Path, default=default, help="data directory (default: game/data)")
    args = parser.parse_args(argv)
    report = Validator(args.data.resolve()).run()
    for line in report.warnings + report.errors:
        print(line)
    print(f"{len(report.errors)} error(s), {len(report.warnings)} warning(s)")
    return 1 if report.errors else 0


if __name__ == "__main__":
    sys.exit(main())
