var documenterSearchIndex = {"docs":
[{"location":"description.html#Description","page":"Description","title":"Description","text":"","category":"section"},{"location":"description.html","page":"Description","title":"Description","text":"In this package you can find two main algorithms:","category":"page"},{"location":"description.html","page":"Description","title":"Description","text":"segment : allows you to separate the points of a 3D point cloud contained in a volume,\northophoto : generates the image as orthographic projection of 3D point cloud with respect to a chosen plane","category":"page"},{"location":"description.html","page":"Description","title":"Description","text":"Both of them has the same core function, that takes as input a point cloud Potree project and a cuboidal LAR model.","category":"page"},{"location":"description.html#Input-Point-Cloud","page":"Description","title":"Input Point Cloud","text":"","category":"section"},{"location":"description.html","page":"Description","title":"Description","text":"To manage a point cloud with huge number of points we use Potree project, achieved with the tool PotreeConverter 1.7.","category":"page"},{"location":"description.html#Potree","page":"Description","title":"Potree","text":"","category":"section"},{"location":"description.html","page":"Description","title":"Description","text":"A Potree is a data structure used to store huge point clouds, based on octree. All details of this structure are described by Markus Schütz in his thesis.","category":"page"},{"location":"description.html","page":"Description","title":"Description","text":"(Image: potree)","category":"page"},{"location":"description.html","page":"Description","title":"Description","text":"A Potree project is a collection of files, for each node of the octree there is a file called r, followed by a numeric code indicating its position in the hierarchy, for example:","category":"page"},{"location":"description.html","page":"Description","title":"Description","text":"r is the root node,\nr0 is the first child of the root node,\nr07 is the eighth child of the first child of the root node.","category":"page"},{"location":"description.html","page":"Description","title":"Description","text":"Due to particular way of tagging nodes, it is possible store Potree in a trie data structure, provided by Julia in module DataStructures.jl. As the usual tree data structure, a trie is made up of collections of trie node. Every trie node has three components:","category":"page"},{"location":"description.html","page":"Description","title":"Description","text":"a value, where store information: in our case the path to the (LAS or LAZ) file associated;\na map, where key is a digit and the value is trie node, used to establish the parent-child relationship;\nboolean value, indicating the end of word.","category":"page"},{"location":"description.html#Core-Function:-Trie-Traversal","page":"Description","title":"Core Function: Trie Traversal","text":"","category":"section"},{"location":"description.html","page":"Description","title":"Description","text":"TODO : alla base di questi algortimi c'è la necessità di controllare quali punti ricadono nella regione di interesse. Per evitare di fare il controllo su tutti i punti della nuvola che rallenterebbe la procedura e avrebbe un costo computazionale elevato, ci facciamo guidare dalla struttura potree. Ogni nodo dell'albero è generato dalla decomposizione dello spazio in regioni congruenti: il volume occupato dal nodo è descritto come un AABB, che troviamo nell'header del file associato al nodo. A questo punto possiamo passare al controllo dell'intersezione tra l'octree e il volume di clipping. Abbiamo come output tre valori:","category":"page"},{"location":"description.html","page":"Description","title":"Description","text":"0 :  spiegare il significato\n1 :\n2 :  ","category":"page"},{"location":"description.html","page":"Description","title":"Description","text":"FOTO e PSEUDO codice","category":"page"},{"location":"description.html#Segment","page":"Description","title":"Segment","text":"","category":"section"},{"location":"description.html","page":"Description","title":"Description","text":"TODO: quindi spieghi se la nuvola entra in tutto il volume processerò ogni punto altrimenti processerò solo i punti che ricadono nel volume ecc...  salvataggio dei punti che ricadono nel modello","category":"page"},{"location":"description.html#Create-image","page":"Description","title":"Create image","text":"","category":"section"},{"location":"description.html","page":"Description","title":"Description","text":"TODO : l'immagine creata è un tensore che descrive i 3 canali rgb. inizialmente il tensore viene riempito del colore di fondo. descrivi Xref e Yref e che quindi di ogni punto che processo devo prendere il colore ed inserirlo nella giusta casella della matrice. e salvo poi in uno z buffer il valore z del punto.","category":"page"},{"location":"description.html","page":"Description","title":"Description","text":"se in quella casella comparirà un nuovo punto prenderò il pixel più vicino all'osservatore.","category":"page"},{"location":"results.html#Results","page":"Results","title":"Results","text":"","category":"section"},{"location":"script.html","page":"Script","title":"Script","text":"% TODO: inserire foto","category":"page"},{"location":"script.html#Script-Usage","page":"Script","title":"Script Usage","text":"","category":"section"},{"location":"script.html#orthophoto.jl","page":"Script","title":"orthophoto.jl","text":"","category":"section"},{"location":"script.html","page":"Script","title":"Script","text":"Orthographic projection of 3D point cloud.","category":"page"},{"location":"script.html","page":"Script","title":"Script","text":"Options:","category":"page"},{"location":"script.html","page":"Script","title":"Script","text":"$ julia orthophoto.jl -h   \n\npositional arguments:\n  source               A text file with Potree directories list or a\n                       single Potree directory\n\noptional arguments:\n  -o, --output OUTPUT   Output image\n  --bbin BBIN           Bounding box as 'x_min y_min z_min x_max y_max\n                        z_max' or Potree JSON volume model\n  --po PO               Projection plane: XY+, XY-, XZ+, XZ-,\n                        YZ+, YZ- (default: \"XY+\")\n  --gsd GSD             Resolution (type: Float64, default: 0.3)\n  --quote QUOTE         Distance of plane from origin (type: Float64)\n  --thickness THICKNESS\n                        Section thickness (type: Float64)\n  --pc                  If true a point cloud of extracted model is saved in a\n                        LAS file\n  --bgcolor BGCOLOR     Background color\n  -h, --help            show this help message and exit","category":"page"},{"location":"script.html","page":"Script","title":"Script","text":"Examples:","category":"page"},{"location":"script.html","page":"Script","title":"Script","text":"# Orthographic projection of top view\njulia orthophoto.jl \"C:/Potree_projects.txt\" -o \"C:/image.jpg\" --bbin \"0 0 0 1 1 1\" --bgcolor \"0 0 0\"","category":"page"},{"location":"script.html#segment.jl","page":"Script","title":"segment.jl","text":"","category":"section"},{"location":"script.html","page":"Script","title":"Script","text":"Point cloud segmentation.","category":"page"},{"location":"script.html","page":"Script","title":"Script","text":"Cut points contained in a volume described by:","category":"page"},{"location":"script.html","page":"Script","title":"Script","text":"bbox: axis aligned bounding box\njsonfile: JSON format\nc,e,r: position, scale, rotation","category":"page"},{"location":"script.html","page":"Script","title":"Script","text":"Options:","category":"page"},{"location":"script.html","page":"Script","title":"Script","text":"$ julia segment.jl -h   \n\npositional arguments:\n  source               A text file with Potree directories list or a\n                       single Potree directory\n\noptional arguments:\n  -o, --output OUTPUT  Output file: LAS format\n  --bbox BBOX          Bounding box as 'x_min y_min z_min x_max y_max\n                       z_max'\n  --jsonfile JSONFILE  Path to Potree JSON volume model\n  --c C                Position: center of volume\n  --e E                Scale: size of box\n  --r R                Rotation: Euler angles (radians) of rotation of\n                       box\n  -h, --help           show this help message and exit","category":"page"},{"location":"script.html","page":"Script","title":"Script","text":"Examples:","category":"page"},{"location":"script.html","page":"Script","title":"Script","text":"# axis aligned bounding box\njulia segment.jl \"C:/Potree_projects.txt\" -o \"C:/partition.las\" --bbox \"0 0 0 1 1 1\"\n\n# JSON format\njulia segment.jl \"C:/Potree_projects.txt\" -o \"C:/partition.las\" --jsonfile \"C:/volume.json\"\n\n# position, scale, rotation\njulia segment.jl \"C:/Potree_projects.txt\" -o \"C:/partition.las\" --c \"0. 0. 0.\" --e \"1. 1. 1.\" --r \"1.5707963267948966 0. 0.\"","category":"page"},{"location":"script.html#slicing.jl","page":"Script","title":"slicing.jl","text":"","category":"section"},{"location":"script.html","page":"Script","title":"Script","text":"Point cloud slicing.","category":"page"},{"location":"script.html","page":"Script","title":"Script","text":"Return one LAS file per slice.","category":"page"},{"location":"script.html","page":"Script","title":"Script","text":"First slice is described with these parameters:","category":"page"},{"location":"script.html","page":"Script","title":"Script","text":"p1: start point\np2: end point\naxis: a versor of plane\nthickness: thickness","category":"page"},{"location":"script.html","page":"Script","title":"Script","text":"Step between slices can be constant or variable, as shown in Figure below. If not provided returns only first slice.","category":"page"},{"location":"script.html","page":"Script","title":"Script","text":"(Image: params)","category":"page"},{"location":"script.html","page":"Script","title":"Script","text":"Options:","category":"page"},{"location":"script.html","page":"Script","title":"Script","text":"$ julia slicing.jl -h   \n\npositional arguments:\n  source                A text file with Potree directories list or a\n                        single Potree directory\n\noptional arguments:\n  -p, --projectname PROJECTNAME\n                        Project name\n  -o, --output OUTPUT   Output folder\n  --bbin BBIN           Bounding box as 'x_min y_min z_min x_max y_max\n                        z_max' or Potree JSON volume model\n  --p1 P1               Start point\n  --p2 P2               End point\n  --axis AXIS           A vector in plane (default: \"0 0 1\")\n  --thickness THICKNESS\n                        Section thickness (type: Float64, default:\n                        0.1)\n  --step STEP           Constant distance between sections (type: Float64)\n  --n N                 Number of sections (type: Int64)\n  --steps STEPS         Distance between sections\n  -h, --help            show this help message and exit","category":"page"},{"location":"script.html","page":"Script","title":"Script","text":"Examples:","category":"page"},{"location":"script.html","page":"Script","title":"Script","text":"# One slice\njulia slicing.jl \"C:/Potree_projects.txt\" -o \"C:/folder\" -p \"My_Proj\" --bbin \"0 0 0 1 1 1\" --p1 \"0 0 0\" --p2 \"1 1 1\" --axis \"0 0 1\" --thickness 0.2\n\n# Costant distance between slice\njulia slicing.jl \"C:/Potree_projects.txt\" -o \"C:/folder\" -p \"My_Proj\" --bbin \"0 0 0 1 1 1\" --p1 \"0 0 0\" --p2 \"1 1 1\" --axis \"0 0 1\" --thickness 0.2 --step 1 --n 10\n\n# Variable distance between slice\njulia slicing.jl \"C:/Potree_projects.txt\" -o \"C:/folder\" -p \"My_Proj\" --bbin \"0 0 0 1 1 1\" --p1 \"0 0 0\" --p2 \"1 1 1\" --axis \"0 0 1\" --thickness 0.2 --steps \"1 1 2 3 1 1 5 6\"","category":"page"},{"location":"index.html#OrthographicProjection","page":"Home","title":"OrthographicProjection","text":"","category":"section"},{"location":"index.html","page":"Home","title":"Home","text":"OrthographicProjection.jl is a Julia library created for two main purposes:","category":"page"},{"location":"index.html","page":"Home","title":"Home","text":"generate orthophoto of a point cloud with respect to a chosen plane,\nsegment a point cloud.","category":"page"},{"location":"index.html#Getting-started","page":"Home","title":"Getting started","text":"","category":"section"},{"location":"index.html#Installation","page":"Home","title":"Installation","text":"","category":"section"},{"location":"index.html","page":"Home","title":"Home","text":"To install a Julia package you have to use the package manager Pkg. Enter the Pkg REPL by pressing ] from the Julia REPL and then use the command add.","category":"page"},{"location":"index.html","page":"Home","title":"Home","text":"This package is not in a registry, it can be added by instead of the package name giving the URL to the repository to add.","category":"page"},{"location":"index.html","page":"Home","title":"Home","text":"julia  (@v1.4) pkg> add https://github.com/marteresagh/OrthographicProjection.jl","category":"page"},{"location":"index.html#Dependencies","page":"Home","title":"Dependencies","text":"","category":"section"},{"location":"index.html","page":"Home","title":"Home","text":"(Image: grafo delle dipendenze)","category":"page"},{"location":"index.html","page":"Home","title":"Home","text":"OrthographicProjection.jl has the following dependencies:","category":"page"},{"location":"index.html","page":"Home","title":"Home","text":"Common.jl\nFileManager.jl\nImages.jl","category":"page"},{"location":"index.html#Structure-of-documentation","page":"Home","title":"Structure of documentation","text":"","category":"section"},{"location":"index.html","page":"Home","title":"Home","text":"This documentation is a collection of several parts:","category":"page"},{"location":"index.html","page":"Home","title":"Home","text":"The \"Description\" part explains the algorithm implemented.\nThe \"How to\" part gives you demonstrations of how to carry out specific tasks with OrthographicProjection.\nThe \"Script\" part describes how to launch a job from command line.\nThe \"Results\" part shows you the results of a specific job.\nThe \"References\" part is a collection of API function references provided by OrthographicProjection.","category":"page"},{"location":"refs.html#Reference","page":"References","title":"Reference","text":"","category":"section"}]
}
