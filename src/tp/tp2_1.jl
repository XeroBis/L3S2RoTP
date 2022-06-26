#= Ex 2.1 =#

   using JuMP, GLPK
   using Printf
   
   # Fonction de modélisation implicite du problème
   function model_solve(solverSelected::DataType, A::Array{Int64, 2})
       # Déclaration d'un modèle (initialement vide)
       m::Model = Model(solverSelected)
   
       # Déduction du nombre de variables à partir des données

       nbVar::Int64 = 6
   
       # Déclaration des variables
       @variable(m, x[1:nbVar,1:nbVar], binary = true)
   
       # Déclaration de la fonction objectif (avec le sens d'optimisation)
       @objective(m, Max, sum(sum(x[j,i] * A[j,i] for j in 1:nbVar) for i in 1: nbVar))
   
       # Déclaration des contraintes
       @constraint(m, contr1[i=1:nbVar], sum(x[j,i] for j in 1:nbVar) == 1)

       @constraint(m, contr2[j=1:nbVar], sum(x[j,i] for i in 1:nbVar) == 1)
       
       # Valeur retournée
       return m
   end
   
   function model_solve_tp2_1()
       # Déclaration des données

       A::Array{Int64,2} = [13 24 31 19 40 29;
                            18 25 30 15 43 22;
                            20 20 27 25 34 33;
                            23 26 28 18 37 30;
                            28 33 34 17 38 20;
                            19 36 25 27 45 24]

       # Création d'un modèle complété à partir des données
       m::Model = model_solve(GLPK.Optimizer,A)
   
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
   