using Distributed

function accel()
	@distributed for i in 1:100
		folder = "C:/Users/marte/Documents/GEOWEB/TEST/parallel_loop"
	    io = open(joinpath(folder,"prova_$i.txt"),"w")
		for j = 1:100
			write(io, "$j \n")
		end
		close(io)
	end
end


function no_accel()
	for i in 1:100
		folder = "C:/Users/marte/Documents/GEOWEB/TEST/parallel_loop"
	    io = open(joinpath(folder,"prova_$i.txt"),"w")
		for j = 1:100
			write(io, "$j \n")
		end
		close(io)
	end
end

@time accel()
@time no_accel()
