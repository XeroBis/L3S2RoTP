#= Ex 2.2 =#

using JuMP, GLPK
using Printf

# Fonction de modélisation implicite du problème
function model_solve(solverSelected::DataType, Pop::Dict{Char, Int64}, J::Dict{Char,Vector{Char}}, p::Int64, indVille::Vector{Char})
    # Déclaration d'un modèle (initialement vide)
    m::Model = Model(solverSelected)

    nbVar::Int64 = size(indVille, 1)
    # Déclaration des variables
    @variable(m, x[indVille], binary = true)

    @variable(m, y[indVille], binary = true)

    # Déclaration de la fonction objectif (avec le sens d'optimisation)
    @objective(m, Max, sum(y[i] * Pop[i] for i in indVille))

    # Déclaration des contraintes
    @constraint(m, contrNbUsine, sum(x[i] for i in indVille) == p)

    @constraint(m, contr2[i in indVille], sum(x[j] for j in J[i]) >= y[i])
    
    println(m)
    # Valeur retournée
    return m
end

function model_solve_tp2_2()
    # Déclaration des données
    indVille = collect('A':'M')


    J::Dict{Char,Vector{Char}} = Dict('A' => ['A','B','C','D'],
                                       'B' => ['A','B','C', 'D', 'E', 'F', 'G'],
                                       'C' => ['A','B','C', 'D'],
                                       'D' => ['A','B','C','D', 'E', 'F', 'G','J', 'K'],
                                       'E' => ['B','D','E','F','G','I', 'J', 'K'],
                                       'F' => ['B','D','E', 'F', 'G', 'I', 'J', 'K'],
                                       'G' => ['B','D', 'E', 'F', 'G', 'H', 'I', 'J', 'K'],
                                       'H' => ['G','H','I','J','K', 'L', 'M'],
                                       'I' => ['E','F','G', 'H', 'I', 'J', 'K', 'L'],
                                       'J' => ['D', 'E','F', 'G', 'H', 'I', 'J', 'K', 'L'],
                                       'K' => ['D', 'E', 'F','G', 'H', 'I', 'J', 'K', 'L'],
                                       'L' => ['H', 'I','J','K', 'L', 'M'],
                                       'M' => ['H', 'L', 'M'])
    
    P::Dict{Char, Int64} = Dict('A' => 53, 
                              'B' => 46,
                              'C' => 16,
                              'D' => 28,
                              'E' => 96,
                              'F' => 84,
                              'G' => 32,
                              'H' => 21,
                              'I' => 15,
                              'J' => 22,
                              'K' => 41,
                              'L' => 53,
                              'M' => 66)

    # Création d'un modèle complété à partir des données
    m::Model = model_solve(GLPK.Optimizer, P, J, 1, indVille)

    #print(m)

    # Résolution
    optimize!(m)

    # Affichage des résultats (ici assez complet pour gérer certains cas d'"erreur")
    status = termination_status(m)

    if status == MOI.OPTIMAL
        println("Problème résolu à l'optimalité")

        println("z = ",objective_value(m)) # affichage de la valeur optimale
        println("x = ",value.(m[:x])) # affichage des valeurs du vecteur de variables issues du modèle
        println("y = ",value.(m[:y])) # affichage des valeurs du vecteur de variables issues du modèle
    elseif status == MOI.INFEASIBLE
        println("Problème non-borné")

    elseif status == MOI.INFEASIBLE_OR_UNBOUNDED
        println("Problème impossible")
    end
end
