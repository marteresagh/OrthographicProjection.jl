# Script Usage

## orthophoto.jl

Orthographic projection of 3D point cloud.

#### Input parameters description:
 - PO: projection plane and sight direction. Option: "XY+","XY-","XZ+","XZ-","YZ+","YZ-"
 - output: output filename for image
 - source: Potree projects
 - bbin: volume
 - GSD: ground sampling distance
 - bgcolor: background color of image
 - quote: quote of section
 - thickness: thickness of section
 - ucs: Path to UCS JSON file. If not provided is the identity matrix
 - epsg: EPSG code
 - pc: if true clip point cloud


#### Options:

```
$ julia orthophoto.jl -h   

positional arguments:
  source               A text file with Potree directories list or a
                       single Potree directory

optional arguments:
 -o, --output OUTPUT   Output image
 --bbin BBIN           Bounding box as 'x_min y_min z_min x_max y_max
                       z_max' or Potree JSON volume model
 --po PO               Projection plane: XY+, XY-, XZ+, XZ-, YZ+, YZ-
                       (default: "XY+")
 --gsd GSD             Resolution (type: Float64, default: 0.3)
 --quote QUOTE         Distance of plane from origin (type: Float64)
 --thickness THICKNESS
                       Section thickness (type: Float64)
 --pc                  If true a pc of extracted model is saved in a
                       LAS file
 --ucs UCS             Path to UCS JSON file. If not provided is the
                       Identity matrix
 --bgcolor BGCOLOR     Background color
 --epsg EPSG           EPSG code (type: Int64)
 -h, --help            show this help message and exit
```

#### Examples:

    # Orthographic projection of top view
    julia orthophoto.jl "C:/Potree_projects.txt" -o "C:/image.jpg" --bbin "0 0 0 1 1 1" --bgcolor "0 0 0"

    # Orthographic projection of left view and slice extraction
    julia orthophoto.jl "C:/Potree_projects.txt" -o "C:/image.jpg" --bbin "0 0 0 1 1 1" --po "YZ-" --quote 0.0 --thickness 1.0 --pc

    # Orthographic projection of horizontal section (UCS applied)
    julia orthophoto.jl "C:/Potree_projects.txt" -o "C:/image.jpg" --bbin "0 0 0 1 1 1" --po "XY+" --ucs "C:/ucs.json" --quote 0.0 --thickness 1.0
