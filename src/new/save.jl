function saveAsset(params::OrthophotoArguments)
    println(" ")
    println("========= SAVES =========")

    # saves image
    print("Image: saving ...")
    # save tfw
    save_tfw(params.outputimage, params.GSD, params.refX, params.refY)

    # save image
    save(params.outputimage, Images.colorview(RGB, params.RGBtensor))
    println("Done.")

    # save mask
    print("Mask: saving ...")
    channels, rows, columns =  size(params.RGBtensor)
    BWImage = ones(channels, rows, columns)
    for i in 1:rows
        for j in 1:columns
            colorRGB = params.RGBtensor[:, i, j]
            if colorRGB == BGcolor
                BWImage[:, i, j] = bgVoid
            else
                BWImage[:, i, j] = bgFull
            end
        end
    end
    save(joinpath(proj_folder,"mask.jpg"), Images.colorview(RGB, BWImage))
    println("Done.")

    # saves point cloud extracted
    if pc
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
