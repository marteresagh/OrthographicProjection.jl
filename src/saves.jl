"""
file tfw
"""
function save_tfw(output::String, GSD::Float64, lx::Float64, uy::Float64)
    fname = splitext(output)[1]
    io = open(fname * ".tfw", "w")
    write(io, "$(Float64(GSD))\n")
    write(io, "0.000000000000000\n")
    write(io, "0.000000000000000\n")
    write(io, "-$(Float64(GSD))\n")
    L = @sprintf("%f", lx)
    U = @sprintf("%f", uy)
    write(io, "$L\n")
    write(io, "$U\n")
    close(io)
end

"""
Save point cloud extracted file .las.
"""
function savepointcloud(params::ParametersOrthophoto, temp::String)

    println("Point cloud: saving ...")

    # update number of points in header
    params.mainHeader.records_count = params.numPointsProcessed

    # update header bounding box
    println("Point cloud: update bbox ...")
    params.mainHeader.x_min = params.tightBB.x_min
    params.mainHeader.y_min = params.tightBB.y_min
    params.mainHeader.z_min = params.tightBB.z_min
    params.mainHeader.x_max = params.tightBB.x_max
    params.mainHeader.y_max = params.tightBB.y_max
    params.mainHeader.z_max = params.tightBB.z_max

    # write las file
    pointtype = LasIO.pointformat(params.mainHeader) # las point format

    if params.numPointsProcessed != 0 # if n == 0 nothing to save
        # in temp : list of las point records
        open(temp) do s
            # write las
            open(params.outputfile, "w") do t
                write(t, LasIO.magic(LasIO.format"LAS"))
                write(t, params.mainHeader)

                # LasIO.skiplasf(s)
                for i = 1:params.numPointsProcessed
                    p = read(s, pointtype)
                    write(t, p)
                    if i%10000 == 0
                        flush(t)
                    end
                end
            end
        end
    end

    rm(temp) # remove temp
    println("Point cloud: done ...")
end

"""
Save orthoprojection image.
"""
function saveimage(params::ParametersOrthophoto)
    print("Image: saving ...")
    # save tfw
    save_tfw(params.outputimage, params.GSD, params.refX, params.refY)

    # save image
    save(params.outputimage, Images.colorview(RGB, params.RGBtensor))

    println("Done.")
end

"""
Save orthoprojection image.
"""
function saveimages(params::ParametersPlanOrthophoto)
    print("Images: saving ...")
    # save image
    img_rgb = Images.colorview(RGB, params.RGBtensor)
    save(joinpath(params.out_folder,"imageRGB.jpg"), img_rgb)
    img_gray = Images.Gray.(img_rgb)
    save(joinpath(params.out_folder,"imageGray.jpg"), img_gray)
    println("Done.")
end



function newPointRecord(
    point::Point,
    type::LasIO.DataType,
    header::LasIO.LasHeader;
    affineMatrix = Matrix(Common.I, 4, 4),
)

    position = Common.apply_matrix(affineMatrix, point.position)
    x = LasIO.xcoord(position[1], header)
    y = LasIO.ycoord(position[2], header)
    z = LasIO.zcoord(position[3], header)
    intensity = UInt16(0)
    flag_byte = UInt8(0)
    raw_classification = UInt8(0)
    scan_angle = Int8(0)
    user_data = UInt8(0)
    pt_src_id = UInt16(0)

    if type == LasIO.LasPoint0
        return type(
            x,
            y,
            z,
            intensity,
            flag_byte,
            raw_classification,
            scan_angle,
            user_data,
            pt_src_id,
        )

    elseif type == LasIO.LasPoint1
        gps_time = Float64(0)
        return type(
            x,
            y,
            z,
            intensity,
            flag_byte,
            raw_classification,
            scan_angle,
            user_data,
            pt_src_id,
            gps_time,
        )

    elseif type == LasIO.LasPoint2
        red = point.color[1]
        green = point.color[2]
        blue = point.color[3]
        return type(
            x,
            y,
            z,
            intensity,
            flag_byte,
            raw_classification,
            scan_angle,
            user_data,
            pt_src_id,
            red,
            green,
            blue,
        )

    elseif type == LasIO.LasPoint3
        gps_time = Float64(0)
        red = rgb[1]
        green = rgb[2]
        blue = rgb[3]
        return type(
            x,
            y,
            z,
            intensity,
            flag_byte,
            raw_classification,
            scan_angle,
            user_data,
            pt_src_id,
            gps_time,
            red,
            green,
            blue,
        )

    end

end
