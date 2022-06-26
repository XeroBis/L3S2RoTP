using JuMP, GLPK

function question_2_2_solveur_alternatif(solverSelected::DataType, nbObjet::Int64, m::Int64, t::Vector{Int64},t_types::Vector{Int64}, T::Int64)
    # nbObjet : le nombre d'objet différent
    # m : le nombre de bins maximum obtenu avec l'algo glouton
    # t : vecteur de la taille des types d'objets
    # t_types : nombre d'objet de chaque type
    # T : la taille des bins

    # Déclaration d'un modèle (initialement vide)
    model::Model = Model(solverSelected)

    # Déclaration des variables
    @variable(model, x[1:nbObjet, 1:m] >= 0, integer = true)
    @variable(model, y[1:m] >= 0, binary = true)

    # Déclaration de la fonction objectif (avec le sens d'optimisation)
    @objective(model, Min, sum(y[j] for j in 1:m))

    # Déclaration des contraintes
    @constraint(model, constr_chaque_obj_dans_bin[i=1:nbObjet], sum(x[i,j] for j in 1:m) == t_types[i])

    @constraint(model, constr_taille_bins[j=1:m], sum(t[i] * x[i,j] for i in 1:nbObjet) <= T * y[j])

    # Résolution
    optimize!(model)

    # Affichage des résultats (ici assez complet pour gérer certains cas d'"erreur")
    status = termination_status(model)

    if status == MOI.OPTIMAL
        println("Nombre de Bins minimum : ",objective_value(model)) # affichage de la valeur optimale
    elseif status == MOI.INFEASIBLE
        println("Problème impossible!")
    elseif status == MOI.INFEASIBLE_OR_UNBOUNDED
        println("Problème non borné!")
    end
    
end

function question_2_2_call_alternatif(d::donnees1D)
    # Déclaration des données
    
    # le nombre d'objets différents des données
    nbObjet::Int64 = d.nb

    # tableau des tailles de tout les types d'objet
    t::Vector{Int64} =  get_taille_of_types_objet_1d(d)

    # tableau du nombre d'objet de tout les types
    t_types::Vector{Int64} = get_nb_of_each_type_of_objet_1d(d)

    # l'algo glouton pour les données
    m::Int64 = algo_glouton_1D(d)

    # Création d'un modèle complété à partir des données
    question_2_2_solveur_alternatif(GLPK.Optimizer, nbObjet, m, t, t_types, d.T)
end


function get_taille_of_types_objet_1d(d::donnees1D)
    t::Vector{Int64} = Vector{Int64}()
    for i in 1:d.nb
        push!(t, d.tab[i].taille)
    end
    return t
end

function get_nb_of_each_type_of_objet_1d(d::donnees1D)
    nb::Vector{Int64} = Vector{Int64}()

    for i in 1:length(d.tab)
        push!(nb, d.tab[i].nb)
    end
    return nb
end