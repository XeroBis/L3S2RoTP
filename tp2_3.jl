#= Ex 2.3 =#

using JuMP, GLPK
using Printf

# Fonction de modélisation implicite du problème
function model_solve(solverSelected::DataType, ZP::Vector{Tuple{Int64, Int64}}, ZC::Vector{Tuple{Int64, Int64}}, CNord::Vector{Int64}, COuest::Vector{Int64}, nbSLIC::Int64)
    # Déclaration d'un modèle (initialement vide)
    m::Model = Model(solverSelected)

    nbVar::Int64 = nbSLIC
    # Déclaration des variables
    @variable(m, x[1:nbVar], binary = true)

    # Déclaration de la fonction objectif (avec le sens d'optimisation)
    @objective(m, Min, sum(x[i] for i in 1:nbVar))

    # Déclaration des contraintes
    @constraint(m, contrZP[(i,j) in ZP], x[i] + x[j] >= 1)

    @constraint(m, contrLConsec[i in COuest[1]:COuest[end]-1], x[i] + x[i+1] <= 1)

    @constraint(m, contrArbitraire[(i, j) in ZC], x[i] + x[j] >= 1)

    @constraint(m, contrMoreInNorth, sum(x[i] for i in CNord) >= 0.5 * sum(x[j] for j in 1:nbSLIC))

    # println(m)
    
    # Valeur retournée
    return m
end

function model_solve_tp2_3()
    # Déclaration des données
    nbSLIC::Int64 = 13

    CNord::Vector{Int64} = [1, 2, 3, 4, 5, 6, 7]
    COuest::Vector{Int64} = [8, 9, 10, 11, 12, 13]

    ZP::Vector{Tuple{Int64, Int64}} = [(1,11), (2,11), (3,9), (4,8), (4,13), (5,10), (6,11)]

    ZC::Vector{Tuple{Int64, Int64}} = [(1, 8)]

    # Création d'un modèle complété à partir des données
    m::Model = model_solve(GLPK.Optimizer, ZP, ZC, CNord, COuest, nbSLIC)

    #print(m)

    # Résolution
    optimize!(m)

    # Affichage des résultats (ici assez complet pour gérer certains cas d'"erreur")
    status = termination_status(m)

    if status == MOI.OPTIMAL
        println("Problème résolu à l'optimalité")

        println("z = ",objective_value(m)) # affichage de la valeur optimale
        println("x = ",value.(m[:x])) # affichage des valeurs du vecteur de variables issues du modèle
    elseif status == MOI.INFEASIBLE
        println("Problème non-borné")

    elseif status == MOI.INFEASIBLE_OR_UNBOUNDED
        println("Problème impossible")
    end
end
