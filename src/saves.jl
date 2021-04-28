"""
file tfw
"""
function save_tfw(output::String, GSD::Float64, lx::Float64, uy::Float64)
	fname = splitext(output)[1]
	io = open(fname*".tfw","w")
	write(io, "$(Float64(GSD))\n")
	write(io, "0.000000000000000\n")
	write(io, "0.000000000000000\n")
	write(io, "-$(Float64(GSD))\n")
	L=@sprintf("%f", lx)
	U=@sprintf("%f", uy)
	write(io, "$L\n")
	write(io, "$U\n")
	close(io)
end

"""
Save point cloud extracted file .las.
"""
function savepointcloud(
	params::Union{ParametersOrthophoto,ParametersExtraction},
	n::Int64,
	temp::String,
	)

	flushprintln("Point cloud: saving ...")

	# update header metadata
	params.mainHeader.records_count = n # update number of points in header

	#update header bounding box
	flushprintln("Point cloud: update bbox ...")
	params.mainHeader.x_min = params.header_bb.x_min
	params.mainHeader.y_min = params.header_bb.y_min
	params.mainHeader.z_min = params.header_bb.z_min
	params.mainHeader.x_max = params.header_bb.x_max
	params.mainHeader.y_max = params.header_bb.y_max
	params.mainHeader.z_max = params.header_bb.z_max

	# write las file
	pointtype = LasIO.pointformat(params.mainHeader) # las point format

	if n != 0 # if n == 0 nothing to save
		# in temp : list of las point records
		open(temp) do s
			# write las
			open(params.outputfile,"w") do t
				write(t, LasIO.magic(LasIO.format"LAS"))
				write(t,params.mainHeader)

				LasIO.skiplasf(s)
				for i = 1:n
					p = read(s, pointtype)
					write(t,p)
				end
			end
		end
	end

	rm(temp) # remove temp
	flushprintln("Point cloud: done ...")
end

"""
Save orthoprojection image.
"""
function saveimage(params::ParametersOrthophoto)
	flushprintln("Image: saving ...")
	# save tfw
	save_tfw(params.outputimage, params.GSD, params.refX, params.refY)

	# save image
	save(params.outputimage, Images.colorview(RGB, params.RGBtensor))

	flushprintln("Image: done ...")
end
