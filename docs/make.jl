using Documenter
using OrthographicProjection

makedocs(
	format = Documenter.HTML(assets = ["assets/OrthographicProjection.css", "assets/logo.jpg"]),
	sitename = "OrthographicProjection.jl",
	modules = [OrthographicProjection]
)


deploydocs(
	repo = "github.com/marteresagh/OrthographicProjection.jl.git"
)
