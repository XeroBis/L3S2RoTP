#= Ex 2.2 =#

using JuMP, GLPK
using Printf

# Fonction de modélisation implicite du problème
function model_solve(solverSelected::DataType, Pop::Vector{Int64}, J::Vector{Vector{Char}}, p::Int64)
    # Déclaration d'un modèle (initialement vide)
    m::Model = Model(solverSelected)

    # Déduction du nombre de variables à partir des données

    nbVar::Int64 = length(Pop)

    # Déclaration des variables
    @variable(m, x[1:nbVar], binary = true)
    @variable(m, y[1:nbVar], binary = true)

    # Déclaration de la fonction objectif (avec le sens d'optimisation)
    @objective(m, Max, sum(y[i] * Pop[i] for i in 1: nbVar))

    # Déclaration des contraintes
    @constraint(m, contrNbUsine, sum(x[i] for i in 1:nbVar )== p)

    @constraint(m, contr2[j=1:nbVar], sum(x[j] for j in 1:nbVar) >= y[i])
    
    # Valeur retournée
    return m
end

function model_solve_tp2_2()
    # Déclaration des données

    J = Vector{Vector{Char}}(undef,13)
    J[1] = ['A','B','C','D']
    J[2] = ['A','B','C', 'D', 'E', 'F', 'G']
    J[3] = ['A','B','C', 'D']
    J[4] = ['A','B','C','D', 'E', 'F', 'G','J', 'K']
    J[5] = ['B','D','E','F','G','I', 'J', 'K']
    J[6] = ['B','D','E', 'F', 'G', 'I', 'J', 'K']
    J[7] = ['B','D', 'E', 'F', 'G', 'H', 'I', 'J', 'K']
    J[8] = ['G','H','I','J','K', 'L', 'M']
    J[9] = ['E','F','G', 'H', 'I', 'J', 'K', 'L']
    J[10] = ['E','F', 'G', 'H', 'I', 'J', 'K', 'L']
    J[11] = ['D', 'E', 'F','G', 'H', 'I', 'J', 'K', 'L']
    J[12] = ['H', 'I','J','K', 'L', 'M']
    J[13] = ['H', 'M']
    
    P = Vector{Int64} = [53,46, 16, 28, 96, 84, 32,21, 15, 22, 41, 53, 66];

    # Création d'un modèle complété à partir des données
    m::Model = model_solve(GLPK.Optimizer,J, P, 2)

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
