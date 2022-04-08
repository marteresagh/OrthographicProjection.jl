function saveAsset(params::OrthophotoArguments, temp::String)
    println(" ")
    println("========= SAVES =========")

    # saves image
    print("Image: saving ...")
    # save tfw
    save_tfw_new(joinpath(params.destinationDir,"image.tfw"), params.GSD, params.refX, params.refY)

    # save image
    save(joinpath(params.destinationDir,"image.jpg"), Images.colorview(RGB, params.RGBtensor))
    println("Done.")

    # save mask
    print("Mask: saving ...")
    channels, rows, columns =  size(params.RGBtensor)
    MaskImage = ones(channels, rows, columns)
    for i in 1:rows
        for j in 1:columns
            colorRGB = params.RGBtensor[:, i, j]
            if colorRGB == params.BGcolor
                MaskImage[:, i, j] = params.ColorMask[1]
            else
                MaskImage[:, i, j] = params.ColorMask[2]
            end
        end
    end
    save(joinpath(params.destinationDir,"mask.jpg"), Images.colorview(RGB, MaskImage))
    println("Done.")

    # saves point cloud extracted
    if params.clip
        savepointcloud(params, temp)
    end

end


function saveAsset(params::PlanArguments)
    println(" ")
    println("========= SAVES =========")

    # saves image
    print("Images: saving ...")
    img_rgb = Images.colorview(RGB, params.RGBtensor)
    save(joinpath(params.destinationDir, "imageRGB.jpg"), img_rgb)
    img_gray = Images.Gray.(img_rgb)
    save(joinpath(params.destinationDir, "imageGray.jpg"), img_gray)
    println("Done.")

    ##### blend image

    rows, columns =  size(params.raster_points)
    image_rgb_blending_alpha_heigth = fill(RGBA(0.,0.,0.,0.), rows, columns)
	image_rgb_blending_alpha_fixed = fill(RGBA(0.,0.,0.,0.), rows, columns)

	image_gray_blending_alpha_heigth = fill(RGBA(0.,0.,0.,0.), rows, columns)
	image_gray_blending_alpha_fixed = fill(RGBA(0.,0.,0.,0.), rows, columns)
	image_gray = fill(RGBA(0.,0.,0.,0.), rows, columns)

	alpha_fixed = 0.2
    for i in 1:rows
        for j in 1:columns
			tuples_rgbh = params.raster_points[i,j]
			sort!(tuples_rgbh, by = x-> x[2])
			n_points = length(tuples_rgbh)
            if n_points > 0

				list_rgba_heigth = []
				list_gray = []

				for ((red,green,blue),h) in tuples_rgbh
					alpha = mapping((params.min_h,params.max_h),(0.1,0.5))(h)
					push!(list_rgba_heigth, [red,green,blue,alpha])
					push!(list_gray, [0.2,0.2,0.2,0.2])
				end

			### RGB
				### blending with heigth
                image_rgb_blending_alpha_heigth[i,j] = RGBA(blendColors(list_rgba_heigth...)...)
				### blending with fixed alpha
				image_gray[i,j] = RGBA(blendColors(list_gray...)...)
            end
        end
    end
	print("Blending: saving ...")
	# map(clamp01nan, Image_Blending)
    save(joinpath(params.destinationDir,"blendRGB.png"), image_rgb_blending_alpha_heigth)
	save(joinpath(params.destinationDir,"blendGray.png"), image_gray)
	# save(joinpath(params.out_folder,"image_rgb_noalpha.png"), Image_rgb)
    println("Done.")

end


function savepointcloud(params::OrthophotoArguments, temp::String)

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
            open(joinpath(params.destinationDir, "clipping.las"), "w") do t
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


function save_tfw_new(fname::String, GSD::Float64, lx::Float64, uy::Float64)
    io = open(fname, "w")
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
