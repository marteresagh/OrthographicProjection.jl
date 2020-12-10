using Documenter
using OrthographicProjection

makedocs(
	format = Documenter.HTML(),
	sitename = "OrthographicProjection.jl",
	assets = ["assets/OrthographicProjection.css", "assets/logo.jpg"],
	modules = [OrthographicProjection]
)


deploydocs(
	repo = "github.com/marteresagh/OrthographicProjection.jl.git"
)
