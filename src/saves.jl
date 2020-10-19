"""
Save point cloud extracted.
"""
function savepointcloud(
	params::Union{ParametersOrthophoto,ParametersExtraction},
	n::Int64,
	temp,
	)

	flushprintln("Point cloud: saving ...")

	params.mainHeader.records_count = n
	pointtype = LasIO.pointformat(params.mainHeader)

	flushprintln("Extracted $n points")

	open(temp) do s
		open(params.outputfile,"w") do t
			write(t, LasIO.magic(LasIO.format"LAS"))
			write(t,params.mainHeader)

			LasIO.skiplasf(s)
			for i=1:n
				p = read(s, pointtype)
				write(t,p)
			end
		end
	end

	rm(temp)
	flushprintln("Point cloud: done ...")
end



"""
Save orthophoto.
"""
function saveorthophoto(params::ParametersOrthophoto)

	flushprintln("Image: saving ...")

	if params.PO == "XY+"
		FileManager.save_tfw(params.outputimage, params.GSD, params.refX, params.refY)
	end

	save(params.outputimage, Images.colorview(RGB, params.RGBtensor))
	flushprintln("Image: done ...")
end
