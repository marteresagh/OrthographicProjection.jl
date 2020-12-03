using OrthographicProjection
using Test


workdir = dirname(@__FILE__)
filename = "files/directory.txt" # point format 0

@testset "util" begin
    @testset "get_potree_dirs" begin
        potreedirs = OrthographicProjection.get_potree_dirs(joinpath(workdir,filename))
        @test potreedirs[1] == "C:\\Users\\Documents\\PROJ1"
        @test potreedirs[2] == "C:\\Users\\Documents\\PROJ2"
        @test potreedirs[3] == "C:\\Users\\Documents\\PROJ3"
        @test potreedirs[4] == "C:\\Users\\Documents\\PROJ4"
    end

    @testset "init" begin
        outfile = "outfile.las"
        model = OrthographicProjection.Lar.cuboid([1,1,1])
        params = OrthographicProjection.init(joinpath(workdir,filename), outfile, model)

        @test typeof(params) == OrthographicProjection.ParametersExtraction
        @test params.outputfile == outfile
        @test params.model == model
        @test typeof(params.mainHeader) == OrthographicProjection.LasIO.LasHeader
        AABB = OrthographicProjection.FileManager.las2aabb(params.mainHeader)
        @test AABB.x_max == 1.0
        @test AABB.x_min == 0.0
        @test AABB.y_max == 1.0
        @test AABB.y_min == 0.0
        @test AABB.z_max == 1.0
        @test AABB.z_min == 0.0
    end

    @testset "PO" begin
        PO = "XY+"
        @test OrthographicProjection.PO2matrix(PO) == [ 1.0  0.0  0.0; 0.0  1.0  0.0; 0.0  0.0  1.0]

        PO = "XY-"
        @test OrthographicProjection.PO2matrix(PO) == [ -1.0  0.0   0.0; 0.0  1.0   0.0; 0.0  0.0  -1.0]

        PO = "XZ+"
        @test OrthographicProjection.PO2matrix(PO) == [  -1.0  0.0  0.0; 0.0  0.0  1.0; 0.0  1.0  0.0]

        PO = "XZ-"
        @test OrthographicProjection.PO2matrix(PO) == [  1.0   0.0  0.0; 0.0   0.0  1.0; 0.0  -1.0  0.0]

        PO = "YZ+"
        @test OrthographicProjection.PO2matrix(PO) == [ 0.0  1.0  0.0; 0.0  0.0  1.0; 1.0  0.0  0.0]

        PO = "YZ-"
        @test OrthographicProjection.PO2matrix(PO) == [ 0.0  -1.0  0.0; 0.0   0.0  1.0; -1.0   0.0  0.0]
    end

    @testset "Raster array" begin
        PO = "XY+"
        coordsystemmatrix = OrthographicProjection.PO2matrix(PO)
        GSD = 0.1
        V,(VV,EV,FV,CV) = OrthographicProjection.Lar.cuboid([1, 1, 1],true)
        model = V, EV, FV
        BGcolor = rand(3)

        RGBtensor, rasterquote, ref_X, ref_Y = OrthographicProjection.init_raster_array(coordsystemmatrix, GSD, model, BGcolor)
        @test RGBtensor[1,:,:] == fill(BGcolor[1],size(RGBtensor[1,:,:]))
        @test RGBtensor[2,:,:] == fill(BGcolor[2],size(RGBtensor[2,:,:]))
        @test RGBtensor[3,:,:] == fill(BGcolor[3],size(RGBtensor[3,:,:]))
        @test rasterquote == fill(-Inf,size(RGBtensor[1,:,:]))
        @test ref_X == 0.
        @test ref_Y == 1.
    end
end
