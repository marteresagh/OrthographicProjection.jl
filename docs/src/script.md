# Script Usage

## orthophoto.jl

Orthographic projection of 3D point cloud.

Options:

```
$ julia orthophoto.jl -h   

positional arguments:
  source                A text file with Potree directory list

optional arguments:
  -o, --output OUTPUT   Output image
  --bbin BBIN           Bounding box as 'x_min y_min z_min x_max y_max
                        z_max' or Potree JSON volume model
  --po PO               Orthographic projection: XY+, XY-, XZ+, XZ-,
                        YZ+, YZ- (default: "XY+")
  --gsd GSD             Resolution (type: Float64, default: 0.3)
  --quote QUOTE         Distance of plane from origin (type: Float64)
  --thickness THICKNESS
                        Section thickness (type: Float64)
  --pc                  If true a pc of extracted model is saved in a
                        LAS file
  --bgcolor BGCOLOR     Background color
  -h, --help            show this help message and exit
```

Examples:

    # Orthographic projection of top view
    julia orthophoto.jl C:/Potree_projects.txt -o C:/image.jpg --bbin "0 0 0 1 1 1" --bgcolor "0 0 0"



    # Script Usage

    ## orthophoto.jl

    Orthographic projection of 3D point cloud.

    Options:

    ```
    $ julia orthophoto.jl -h   

    positional arguments:
      source               A text file with Potree directories list or a
                           single Potree directory

    optional arguments:
      -o, --output OUTPUT   Output image
      --bbin BBIN           Bounding box as 'x_min y_min z_min x_max y_max
                            z_max' or Potree JSON volume model
      --po PO               Projection plane: XY+, XY-, XZ+, XZ-,
                            YZ+, YZ- (default: "XY+")
      --gsd GSD             Resolution (type: Float64, default: 0.3)
      --quote QUOTE         Distance of plane from origin (type: Float64)
      --thickness THICKNESS
                            Section thickness (type: Float64)
      --pc                  If true a point cloud of extracted model is saved in a
                            LAS file
      --bgcolor BGCOLOR     Background color
      -h, --help            show this help message and exit
    ```

    Examples:

        # Orthographic projection of top view
        julia orthophoto.jl C:/Potree_projects.txt -o C:/image.jpg --bbin "0 0 0 1 1 1" --bgcolor "0 0 0"


## segment.jl

Point cloud segmentation.

Cut points contained in a volume described by:
 - *bbox*: axis aligned bounding box
 - *jsonfile*: JSON format
 - *c,e,r*: position, scale, rotation

Options:

```
$ julia segment.jl -h   

positional arguments:
  source               A text file with Potree directories list or a
                       single Potree directory

optional arguments:
  -o, --output OUTPUT  Output file: LAS format
  --bbox BBOX          Bounding box as 'x_min y_min z_min x_max y_max
                       z_max'
  --jsonfile JSONFILE  Path to Potree JSON volume model
  --c C                Position: center of volume
  --e E                Scale: size of box
  --r R                Rotation: Euler angles (radians) of rotation of
                       box
  -h, --help           show this help message and exit
```

Examples:

    # axis aligned bounding box
    julia segment.jl C:/Potree_projects.txt -o C:/partition.las --bbox "0 0 0 1 1 1"

    # JSON format
    julia segment.jl C:/Potree_projects.txt -o C:/partition.las --jsonfile "C:/volume.json"

    # position, scale, rotation
    julia segment.jl C:/Potree_projects.txt -o C:/partition.las --c "0. 0. 0." --e "1. 1. 1." --r "1.5707963267948966 0. 0."

## slicing.jl

## slicing_listpoints.jl
