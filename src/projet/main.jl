include("projet.jl")
include("question_2_1.jl")
include("question_2_2.jl")
include("question_2_2_alternatif.jl")
include("question_2_3_1.jl")
include("question_2_3_2.jl")
include("question_3_1.jl")
include("question_3_2.jl")
include("question_3_3.jl")

using Dates


# other files are not meant to be launcheable, only this one should be include in julia

function main()
    test_algo_glouton_1d()
    test_question_2_3_2()
    test_question_3_2()
    test_question_3_3()
end

function get_data_1d(c::String, i::Int64)
    name::String = string(c, i)
    filename::String = string("Instances/1Dim/", c, "/", name, ".dat")
    return parser_data1D(filename)
end

function get_data_2d(c::String, i::Int64)
    name::String = string(c, i)
    filename::String = string("Instances/2Dim/", c, "/", name, ".dat")
    return parser_data2D(filename)
end

function test_algo_glouton_1d()
    println("----------------------------------------------------")
    println("DEBUT QUESTION 2_1 : ")
    for i in 4:10
        println("algo glouton pour la data A", i , " : ", @time algo_glouton_1D(get_data_1d("A",i)))
    end
    println("algo glouton pour la data A", 15 , " : ", @time algo_glouton_1D(get_data_1d("A",15)))
    println("algo glouton pour la data A", 20 , " : ", @time algo_glouton_1D(get_data_1d("A",20)))

    for i in 4:10
        println("algo glouton pour la data B", i , " : ", @time algo_glouton_1D(get_data_1d("B", i)))
    end
    println("algo glouton pour la data B", 15 , " : ", @time algo_glouton_1D(get_data_1d("B", 15)))
    println("algo glouton pour la data B", 20 , " : ", @time algo_glouton_1D(get_data_1d("B", 20)))
    println("----------------------------------------------------")
end

function test_question_2_3_2()
    println("----------------------------------------------------")
    println("DEBUT QUESTION 2_3_2 : ")
    for i in 4:10
        println("data A", i , " : ")
        @time question_2_3_2_call(get_data_1d("A", i))
    end
    println("data A", 15 , " : ")
    @time question_2_3_2_call(get_data_1d("A", 15))
    println("data A", 20 , " : " )
    @time question_2_3_2_call(get_data_1d("A", 20))

    for i in 4:10
        println("ata B", i , " : ")
        @time question_2_3_2_call(get_data_1d("B",i))
    end
    println("data B", 15 , " : ")
    @time question_2_3_2_call(get_data_1d("B",15))
    println("data B", 20 , " : ")
    @time question_2_3_2_call(get_data_1d("B",20))
    println("----------------------------------------------------")
end

function test_question_3_2()
    println("----------------------------------------------------")
    println("DEBUT QUESTION 3_2 : ")
    for i in 4:10
        println("data A", i , ", Nombre de motifs : ", @time size(get_motifs(get_data_2d("A", i)), 1))
    end

    println("data B4, Nombre de motifs : ", @time size(get_motifs(get_data_2d("B",4)), 1))
    println("data B7, Nombre de motifs : ", @time size(get_motifs(get_data_2d("B",7)), 1))
    println("data B8, Nombre de motifs : ", @time size(get_motifs(get_data_2d("B",8)), 1))
    println("data B10, Nombre de motifs : ", @time size(get_motifs(get_data_2d("B",10)), 1))

    println("----------------------------------------------------")
end

function test_question_3_3()
    println("----------------------------------------------------")
    println("DEBUT QUESTION 3_3 : ")
    for i in 4:10
        println("data A", i , " : ")
        @time question_3_3_call(get_data_2d("A", i))
    end
    println("data B4 : ")
    @time question_3_3_call(get_data_2d("B",4))
    println("data B7 : ")
    @time question_3_3_call(get_data_2d("B",7))
    println("data B8 : ")
    @time question_3_3_call(get_data_2d("B",8))
    println("data B10 : ")
    @time question_3_3_call(get_data_2d("B",10))

end