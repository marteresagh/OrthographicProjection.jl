"""
update params
"""
function updateif!(params::ParametersExtraction, file::String, s, n::Int64)
	h, laspoints =  FileManager.read_LAS_LAZ(file)
    for laspoint in laspoints
        point = FileManager.xyz(laspoint,h)
        if Common.inmodel(params.model)(point) # se il punto è interno allora
			n = update_core(params,laspoint,h,s,n)
        end
    end
	return n
end

function update!(params::ParametersExtraction, file::String, s, n::Int64)
	h, laspoints = FileManager.read_LAS_LAZ(file)
    for laspoint in laspoints
		n = update_core(params,laspoint,h,s,n)
    end
	return n
end

function update_core(params::ParametersExtraction, laspoint::LasIO.LasPoint, h::LasIO.LasHeader, s, n::Int64)
	plas = FileManager.newPointRecord(laspoint,h,LasIO.LasPoint2,params.mainHeader)
	write(s,plas)
	n = n+1
	return n
end
