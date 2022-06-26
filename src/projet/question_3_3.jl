using JuMP, GLPK

function question_3_3_solveur(solverSelected::DataType, nbObjet::Int64, nbObjets::Vector{Int64}, nbMotif::Int64, vecteur::Vector{Vector{Int64}})
    # nbObjet : le nombre d'objet différent du problème
    # nbObjets : tableau du nombre d'objet de chaque type
    # nbMotif : le nombre de motif différent
    # vecteur : le nombre d'objet i dans un motif j

    # Déclaration d'un modèle (initialement vide)
    model::Model = Model(solverSelected)

    # Déclaration des variables
    @variable(model, x[1:nbMotif]>= 0 , integer = true)

    # Déclaration de la fonction objectif (avec le sens d'optimisation)
    @objective(model, Min, sum(x[i] for i in 1:nbMotif))

    # Déclaration des contraintes
    @constraint(model, constr[i=1:nbObjet], sum(vecteur[i][j] * x[j] for j in 1:nbMotif) >= nbObjets[i])

    # Résolution
    optimize!(model)

    # Affichage des résultats (ici assez complet pour gérer certains cas d'"erreur")
    status = termination_status(model)

    if status == MOI.OPTIMAL
        println("Nombre de bins minimum : ",objective_value(model)) # affichage de la valeur optimale
    elseif status == MOI.DUAL_INFEASIBLE
        println("Problème non borné")
    elseif status == MOI.INFEASIBLE
        println("Problème impossible!")
    elseif status == MOI.INFEASIBLE_OR_UNBOUNDED
        println("Problème non borné!")
    end
    
end

function question_3_3_call(d::donnees2D)
    # Déclaration des données
    
    nbObjet::Int64 = d.nb

    nbObjets::Vector{Int64} = get_nb_of_object_for_each_types(d)

    motifs::Vector{Vector{Int64}} = get_motifs(d)

    nbMotif::Int64 = size(motifs,1)
    println("Nombre de motifs :", nbMotif)

    vecteur::Vector{Vector{Int64}} = get_vector_object(nbObjet, motifs)

    # Création d'un modèle complété à partir des données
    question_3_3_solveur(GLPK.Optimizer, nbObjet, nbObjets, nbMotif, vecteur)
end

function get_nb_of_object_for_each_types(d::donnees2D)
    result::Vector{Int64} = []
    for i in 1:size(d.tab, 1)
        push!(result, d.tab[i].nb)
    end
    return result
end
