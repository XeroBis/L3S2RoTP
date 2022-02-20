
#= Première modélisation vue en cours
   Afin de pouvoir réutiliser le modèle (on pourrait avoir d'autres médicaments et d'autres toxines),
   on le déclare indépendamment des données dans une fonction.
   Il s'agit ici d'une modélisation implicite =#

# On utilisera les packages suivants
using JuMP, GLPK

#= fonction instanciant un modèle dépendant de données en entrée (on parle de modélisation implicite car les données sont séparées) et enchaînant sa résolution
    c représente le vecteur des coefficients de la fonction objectif
    A représente la matrice des contraintes
    b représente les membres de droite des contraintes
    solverSelected est un paramètre permettant de choisir le solveur utilisé pour résoudre le problème =#

function model_solve_medoc_implicite(solverSelected::DataType, c::Vector{Int64}, A::Matrix{Float64},b::Vector{Int64})
    # Déclaration d'un modèle (initialement vide)
    m::Model = Model(solverSelected)

    # Déduction du nombre de variables et du nombre de contraintes à partir des données
    nbcontr::Int64 = size(A,1) # taille de la matrice A sur la première dimension = nombre de lignes de A
    nbvar::Int64 = size(A,2) # taille de la matrice A sur la deuxième dimension = nombre de colonnes de A

    #= Alternative possible (une fonction en Julia peut retourner plusieurs valeurs)
    nbcontr, nbvar = size(A) =#

    # Déclaration des variables
    @variable(m,x[1:nbvar] >= 0, integer = true)

    # Déclaration de la fonction objectif (avec le sens d'optimisation)
    @objective(m, Max, sum(c[j]x[j] for j in 1:nbvar))

    # Déclaration des contraintes
    # (leur donner un nom est ici obligatoire pour grouper des contraintes en une seule déclaration)
    @constraint(m, Toxine[i=1:nbcontr], sum(A[i,j]x[j] for j in 1:nbvar) <= b[i])

    # Résolution
    optimize!(m)

    # Affichage des résultats (ici assez complet pour gérer certains cas d'"erreur")
    status = termination_status(m)

    if status == MOI.OPTIMAL
        println("Problème résolu à l'optimalité")
        println("z = ",objective_value(m)) # affichage de la valeur optimale
        println("x = ",value.(x))
    elseif status == MOI.INFEASIBLE
        println("Problème impossible!")
    elseif status == MOI.INFEASIBLE_OR_UNBOUNDED
        println("Problème non borné!")
    end
end

# fonction initialisant des données avant de faire appel à la fonction model_solve_medoc_implicite
# C'est cette fonction qu'on appellera dans le REPL
function model_solve_distanciel()
    # Déclaration des données

    c::Vector{Int64} = [12,20]
    A::Matrix{Float64} = [0.2 0.4;
                        0.2 0.6]
    b::Vector{Int64} = [400,800]

    # Création d'un modèle complété à partir des données
    model_solve_medoc_implicite(GLPK.Optimizer,c,A,b)
end
