import copy
import json
import sys
import tempfile
import unittest
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent.parent))
from validate_data import Validator  # noqa: E402

SUBSTANCES = {
    "limestone": {"name": {"en": "Limestone"}, "formula": "CaCO3", "phase": "solid", "tags": ["mineral"]},
    "quicklime": {"name": "loc:sub_quicklime", "formula": "CaO", "phase": "powder", "tags": ["alkaline"]},
    "stone": {"name": {"en": "Stone"}, "phase": "object", "tags": ["mineral"], "is_tool": True},
    "fire": {"name": {"en": "Fire"}, "phase": "object", "tags": [], "is_zone": True},
}
REACTIONS = {
    "calcination": {
        "inputs": ["limestone"], "zone": "fire", "outputs": ["quicklime"], "consumes": ["limestone"],
        "duration": {"game_seconds": 600}, "fx": "fire", "modes": ["classic", "real"],
        "flavor": "loc:rx_calcination_flavor", "science_note": {"en": "CaCO3 -> CaO + CO2 when heated."},
        "verified": True,
    },
    "crush": {
        "inputs": ["tag:mineral", "stone"], "outputs": ["quicklime"], "consumes": [],
        "flavor": {"en": "Crunch."}, "science_note": {"en": "Fact."}, "verified": True,
    },
}
CASE = {
    "id": "castle", "title": "loc:case_castle_title", "story": {"en": "..."},
    "start_items": ["limestone", "stone"], "zones": ["fire"],
    "goals": [{"item": "quicklime", "count": 1}], "limit": {"type": "none"},
    "deadline": {"mode": "real", "seconds": 3600},
    "hotspots": [{"id": "coffin", "pos": [3, 4], "type": "inspect"}],
}
TAGS = ["mineral", "alkaline"]
EN_CSV = "keys,en\nsub_quicklime,Quicklime\nrx_calcination_flavor,Hot!\ncase_castle_title,Castle\n"


class ValidateDataTest(unittest.TestCase):
    def setUp(self):
        self.tmp = tempfile.TemporaryDirectory()
        self.dir = Path(self.tmp.name)
        self.data = {"substances": copy.deepcopy(SUBSTANCES), "reactions": copy.deepcopy(REACTIONS),
                     "case": copy.deepcopy(CASE), "tags": list(TAGS)}

    def tearDown(self):
        self.tmp.cleanup()

    def run_validator(self, csv_text=EN_CSV):
        (self.dir / "cases").mkdir(exist_ok=True)
        (self.dir / "substances.json").write_text(json.dumps(self.data["substances"]), encoding="utf-8")
        (self.dir / "reactions.json").write_text(json.dumps(self.data["reactions"]), encoding="utf-8")
        (self.dir / "tags.json").write_text(json.dumps(self.data["tags"]), encoding="utf-8")
        case = self.data["case"]
        (self.dir / "cases" / f"{case['id']}.json").write_text(json.dumps(case), encoding="utf-8")
        if csv_text is not None:
            (self.dir / "i18n").mkdir(exist_ok=True)
            (self.dir / "i18n" / "en.csv").write_text(csv_text, encoding="utf-8")
        return Validator(self.dir).run()

    def assert_error(self, report, fragment):
        self.assertTrue(any(fragment in e for e in report.errors),
                        f"expected error containing {fragment!r}, got {report.errors}")

    def test_valid_data_has_no_errors(self):
        report = self.run_validator()
        self.assertEqual(report.errors, [])

    def test_unknown_input_substance(self):
        self.data["reactions"]["calcination"]["inputs"] = ["marble"]
        self.assert_error(self.run_validator(), "unknown substance 'marble'")

    def test_unknown_input_tag(self):
        self.data["reactions"]["crush"]["inputs"] = ["tag:shiny", "stone"]
        self.assert_error(self.run_validator(), "unknown tag 'shiny'")

    def test_missing_science_note(self):
        del self.data["reactions"]["crush"]["science_note"]
        self.assert_error(self.run_validator(), "missing 'science_note'")

    def test_missing_flavor(self):
        del self.data["reactions"]["crush"]["flavor"]
        self.assert_error(self.run_validator(), "missing 'flavor'")

    def test_loc_key_missing_from_csv(self):
        self.data["reactions"]["calcination"]["flavor"] = "loc:rx_nope"
        self.assert_error(self.run_validator(), "'loc:rx_nope' not in i18n/en.csv")

    def test_loc_keys_not_checked_without_csv(self):
        self.data["reactions"]["calcination"]["flavor"] = "loc:rx_nope"
        self.assertEqual(self.run_validator(csv_text=None).errors, [])

    def test_consuming_a_tool(self):
        self.data["reactions"]["crush"]["consumes"] = ["stone"]
        self.assert_error(self.run_validator(), "consumes tool 'stone'")

    def test_zone_must_be_marked(self):
        self.data["reactions"]["calcination"]["zone"] = "stone"
        self.assert_error(self.run_validator(), "not marked is_zone")

    def test_bad_mode_and_fx(self):
        self.data["reactions"]["calcination"]["modes"] = ["hard"]
        self.data["reactions"]["calcination"]["fx"] = "boom"
        report = self.run_validator()
        self.assert_error(report, "'modes'")
        self.assert_error(report, "'fx'")

    def test_unverified_is_warning_not_error(self):
        self.data["reactions"]["crush"]["verified"] = False
        report = self.run_validator()
        self.assertEqual(report.errors, [])
        self.assertTrue(any("crush" in w for w in report.warnings))

    def test_case_id_must_match_file(self):
        self.data["case"]["id"] = "castle"
        self.run_validator()
        (self.dir / "cases" / "castle.json").rename(self.dir / "cases" / "other.json")
        self.assert_error(Validator(self.dir).run(), "must match file name 'other'")

    def test_case_bad_references(self):
        self.data["case"]["goals"] = [{"item": "gold"}]
        self.data["case"]["hotspots"].append({"id": "coffin", "type": "dance"})
        self.data["case"]["deadline"] = {"mode": "cozy", "seconds": 10}
        report = self.run_validator()
        self.assert_error(report, "goal references unknown item")
        self.assert_error(report, "duplicate hotspot id 'coffin'")
        self.assert_error(report, "type must be one of")
        self.assert_error(report, "'deadline'")

    def test_invalid_json(self):
        self.run_validator()
        (self.dir / "reactions.json").write_text("{oops", encoding="utf-8")
        self.assert_error(Validator(self.dir).run(), "invalid JSON")


if __name__ == "__main__":
    unittest.main()
