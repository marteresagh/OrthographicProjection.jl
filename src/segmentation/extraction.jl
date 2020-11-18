"""
save points in a temporary file
"""
function updatepointsif!(params::ParametersExtraction, file::String, s, n::Int64)
	h, laspoints =  FileManager.read_LAS_LAZ(file)
    for laspoint in laspoints
        point = FileManager.xyz(laspoint,h)
        if Common.inmodel(params.model)(point) # se il punto è interno allora
			n = updatepoints_core(params,laspoint,h,s,n)
        end
    end
	return n
end

function updatepoints!(params::ParametersExtraction, file::String, s, n::Int64)
	h, laspoints = FileManager.read_LAS_LAZ(file)
    for laspoint in laspoints
		n = updatepoints_core(params,laspoint,h,s,n)
    end
	return n
end


function updatepoints_core(params::ParametersExtraction, laspoint::LasIO.LasPoint, h::LasIO.LasHeader, s, n::Int64)
	point = FileManager.xyz(laspoint,h)
	p = params.coordsystemmatrix*point
	plas = FileManager.newPointRecord(laspoint,h,LasIO.LasPoint2,params.mainHeader)
	write(s,plas)
	n=n+1
	return n
end
