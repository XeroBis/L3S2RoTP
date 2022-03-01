#= Ex 2.3 =#

using JuMP, GLPK
using Printf

# Fonction de modélisation implicite du problème
function model_solve(solverSelected::DataType, ZP::Vector{Tuple{Int64, Int64}}, nbSLIC::Int64)
    # Déclaration d'un modèle (initialement vide)
    m::Model = Model(solverSelected)

    nbVar::Int64 = nbSLIC
    # Déclaration des variables
    @variable(m, x[1:nbVar], binary = true)

    # Déclaration de la fonction objectif (avec le sens d'optimisation)
    @objective(m, Min, sum(x[i] for i in 1:nbVar))

    # Déclaration des contraintes
    @constraint(m, contrZP[(i,j)=ZP], x[i] + x[j] >= 1)

    @constraint(m, contrLConsec[i=8:12], x[i] + x[i+1] <= 1)

    @constraint(m, contrC1L8, x[1] + x[8] >= 1)

    @constraint(m, contrMoreInNorth, sum(x[i] for i in 1:7) >= 0.5 * sum(x[j] for j in 1:13))


    
    # Valeur retournée
    return m
end

function model_solve_tp2_3()
    # Déclaration des données
    nbSLIC::Int64 = 13

    ZP::Vector{Tuple{Int64, Int64}} = [(1,11), (2,11), (3,9), (4,8), (4,13), (5,10), (6,11)]

    # Création d'un modèle complété à partir des données
    m::Model = model_solve(GLPK.Optimizer, ZP, nbSLIC)

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
