using Documenter
using OrthographicProjection

# makedocs(
# 	format = Documenter.HTML(),
# 	sitename = "OrthographicProjection.jl",
# 	#assets = ["assets/OrthographicProjection.css", "assets/logo.jpg"],
# 	modules = [OrthographicProjection]
# )
#
#
# deploydocs(
# 	repo = "github.com/marteresagh/OrthographicProjection.jl.git"
# )


makedocs(
    modules = [OrthographicProjection],
    format = Documenter.HTML(
        prettyurls = "deploy" in ARGS,
    ),
    sitename = "OrthographicProjection.jl",
    pages = [
        "Home" => "index.md",
        "Description" => "description.md",
        "Results" => "results.md",
        "Script" => "script.md",
        "References" => "refs.md",
    ]
)

deploydocs(
    repo = "github.com/marteresagh/OrthographicProjection.jl.git",
    push_preview = true,
)
