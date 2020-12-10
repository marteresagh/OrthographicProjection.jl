using Documenter
using OrthographicProjection

makedocs(
	format = Documenter.HTML(assets = ["assets/OrthographicProjection.css", "assets/logo.jpg"]),
	sitename = "OrthographicProjection.jl",
	modules = [OrthographicProjection]
)


deploydocs(
	devurl = "",
	versions = ["stable" => "v^", "v#.#"],
	repo = "github.com/marteresagh/OrthographicProjection.jl.git"
)
