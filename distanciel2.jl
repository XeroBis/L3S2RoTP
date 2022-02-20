#= Ex 2.2 problème de couverture d'ensemble modèle implicite
   Pour commencer, les indices des caméras sont remplacés par des entiers dans la modélisation
   (Il n'y a pas de moyen direct d'indicer un tableau avec autre chose que des entiers en Julia)
   Nous utilisons ici un vecteur de vecteurs de tuples {Int64,Int64} pour représenter une matrice creuse
   avec un accès DIRECT aux éléments de la matrice =#

   using JuMP, GLPK
   using Printf
   
   # Fonction de modélisation implicite du problème
   function model_musee_implicite3(solverSelected::DataType, A::Vector{Vector{Tuple{Int64,Int64}}}, b::Vector{Int64})
       # Déclaration d'un modèle (initialement vide)
       m::Model = Model(solverSelected)
   
       # Déduction du nombre de variables à partir des données
       nbVar::Int64 = length(b)

       nbContr::Int64 = length(A)
   
       # Déclaration des variables
       @variable(m, x[1:nbVar], binary = true)
   
       # Déclaration de la fonction objectif (avec le sens d'optimisation)
       @objective(m, Max, sum(x[j] * b[j] for j in 1:nbVar))
   
       # Déclaration des contraintes
       @constraint(m, contr[i=1:nbContr], sum(x[j] for (j,v) in A[i]) <= 1)
   
       # Valeur retournée
       return m
   end
   
   function model_solve_distanciel_2()
       # Déclaration des données
       # Saisie simple d'un vecteur de vecteurs d'entiers
       A::Vector{Vector{Tuple{Int64,Int64}}} = Vector{Vector{Tuple{Int64,Int64}}}(undef,11)
       A[1] = [(1,1),(5,1)]
       A[2] = [(2,1),(5,1)]
       A[3] = [(3,1),(5,1)]
       A[4] = [(3,1),(4,1)]
       A[5] = [(2,1),(7,1)]
       A[6] = [(5,1),(7,1)]
       A[7] = [(5,1),(4,1)]
       A[8] = [(6,1),(7,1)]
       A[9] = [(6,1),(8,1)]
       A[10] =[(8,1),(4,1)]
       A[11] =[(5,1),(9,1)]
   
       b::Vector{Int64} = [1,3,7,3,12,4,9,4,3]
   
       # Création d'un modèle complété à partir des données
       m::Model = model_musee_implicite3(GLPK.Optimizer,A,b)
   
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
   