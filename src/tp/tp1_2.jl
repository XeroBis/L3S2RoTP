#= BIGNON ALAN 685L =#
using JuMP, GLPK

function model_solve_medoc_implicite(solverSelected::DataType, b::Vector{Int64})
    # Déclaration d'un modèle (initialement vide)
    m::Model = Model(solverSelected)

    # Déclaration des variables
    @variable(m,x[1:12] >= 0, integer = true)
    @variable(m, s[1:12] >= 0, integer = true)

    # Déclaration de la fonction objectif (avec le sens d'optimisation)
    @objective(m, Min, sum(s[j] for j in 1:12))

    # Déclaration des contraintes
    # (leur donner un nom est ici obligatoire pour grouper des contraintes en une seule déclaration)
    @constraint(m, Toxine[i=1:12], x[i] + x[((i+7)%12 +1) ] + x[((i+8)%12 +1)] + x[((i+10)%12 +1 )] + s[((i + 6)%12 + 1)] >= b[i])
    @constraint(m, nbInf, sum(x[i] for i in 1:12) <= 80)
    @constraint(m, xsupS, sum(x[i] for i in 1:12) >= sum(s[i] for i in 1 : 12))

    # Résolution
    optimize!(m)

    # Affichage des résultats (ici assez complet pour gérer certains cas d'"erreur")
    status = termination_status(m)

    if status == MOI.OPTIMAL
        println("Problème résolu à l'optimalité")
        println("z = ",objective_value(m)) # affichage de la valeur optimale
        println("x = ",value.(x))
        println("s = ", value.(s))
    elseif status == MOI.INFEASIBLE
        println("Problème impossible!")
    elseif status == MOI.INFEASIBLE_OR_UNBOUNDED
        println("Problème non borné!")
    end
    
end

# fonction initialisant des données avant de faire appel à la fonction model_solve_medoc_implicite
# C'est cette fonction qu'on appellera dans le REPL
function model_solve_tp_2()
    # Déclaration des données

    b::Vector{Int64} = [35,40,40,35,30,30,35,30,20,15,15,15]

    # Création d'un modèle complété à partir des données
    model_solve_medoc_implicite(GLPK.Optimizer, b)
end
