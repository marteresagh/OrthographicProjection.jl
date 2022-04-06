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
