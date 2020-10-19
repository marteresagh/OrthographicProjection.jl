#TODO fare altri test ma sembra funzionare
function plane2model(rot_mat::Matrix, constant::Float64, thickness::Float64, aabb::AABB)
	verts,_ = getmodel(aabb)
	rotation = Common.matrix2euler(rot_mat)
	center_model = [(aabb.x_max+aabb.x_min)/2,(aabb.y_max+aabb.y_min)/2,(aabb.z_max+aabb.z_min)/2]
	quota = rot_mat[:,3]*constant
	position = center_model+(quota-Lar.dot(rot_mat[:,3],center_model)*rot_mat[:,3])
	newverts = rot_mat'*verts
	x_range = extrema(newverts[1,:])
	y_range = extrema(newverts[2,:])
	#extrema of newverts x e y
	scale = [x_range[2]-x_range[1],y_range[2]-y_range[1],thickness]
	volume = Volume(scale,position,rotation)
	model = Common.volume2LARmodel(volume)
	return model
end
