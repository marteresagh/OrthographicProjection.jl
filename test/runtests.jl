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
        V = [ 0.0  0.0  0.0  0.0  1.0  1.0  1.0  1.0;
              0.0  0.0  1.0  1.0  0.0  0.0  1.0  1.0;
              0.0  1.0  0.0  1.0  0.0  1.0  0.0  1.0]
        EV = [[1, 2], [3, 4], [5, 6], [7, 8], [1, 3], [2, 4], [5, 7],
              [6, 8], [1, 5], [2, 6], [3, 7], [4, 8]]
        FV = [[1, 2, 3, 4], [5, 6, 7, 8], [1, 2, 5, 6], [3, 4, 7, 8],
              [1, 3, 5, 7], [2, 4, 6, 8]]
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
