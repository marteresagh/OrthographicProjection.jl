push!(LOAD_PATH,"../src/")

using Documenter, OrthographicProjection

makedocs(
	format = :html,
	sitename = "OrthographicProjection.jl",
	assets = ["assets/OrthographicProjection.css", "assets/logo.jpg"],
	pages = [
		"1 - Home" => "index.md",
		"2 - Getting Started" => "gettingStarted.md",
		"Theory..." => [
			"3.0 - Theory Index" => "theory-index.md",
		],
		"... and Practice" => [
			"4.0 - Module Introduction" => "this-module.md",
		],
		"A - About the Authors" => "authors.md",
		"B - Bibliography" => "bibliography.md"
	]
)
