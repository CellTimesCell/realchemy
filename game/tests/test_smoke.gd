extends GutTest
## Smoke test: proves GUT runs headless from the command line.


func test_gut_runs() -> void:
	assert_true(true, "GUT is alive")


func test_project_base_resolution() -> void:
	var width: int = ProjectSettings.get_setting("display/window/size/viewport_width")
	var height: int = ProjectSettings.get_setting("display/window/size/viewport_height")
	assert_eq(Vector2i(width, height), Vector2i(480, 270), "Base resolution must be 480x270")
