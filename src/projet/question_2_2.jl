function question_2_2_solveur(solverSelected::DataType, nbObjet::Int64, m::Int64, t::Vector{Int64}, T::Int64)
    # nbObjet : le nombre d'objet totale qu'il faudra rentrer dans les bins
    # m : le nombre de bins maximum obtenu avec l'algo glouton
    # t : vecteur de la taille des objets
    # T : la taille des bins

    # Déclaration d'un modèle (initialement vide)
    model::Model = Model(solverSelected)

    # Déclaration des variables
    @variable(model, x[1:nbObjet, 1:m], binary = true)
    @variable(model, y[1:m], binary = true)

    # Déclaration de la fonction objectif (avec le sens d'optimisation)
    @objective(model, Min, sum(y[j] for j in 1:m))

    # Déclaration des contraintes
    @constraint(model, constr_chaque_obj_dans_bin[i=1:nbObjet], sum(x[i,j] for j in 1:m) == 1)

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

function question_2_2_call(d::donnees1D)
    # Déclaration des données

    # on récupère le nombre d'objet totale
    nbObjet::Int64 = get_nb_of_objet_1d(d)

    #on récupère la taille de chaque objet 
    t::Vector{Int64} =  get_taille_of_objet_1d(d)

    # on résout le problème en algo glouton
    m::Int64 = algo_glouton_1D(d)

    # Création d'un modèle complété à partir des données
    question_2_2_solveur(GLPK.Optimizer, nbObjet, m, t, d.T)
end

# Fonction qui sert à récupérer la taille de tout les objets de données 1D
function get_taille_of_objet_1d(d::donnees1D)
    t::Vector{Int64} = Vector{Int64}()
    for i in 1:length(d.tab)
        for j in 1:d.tab[i].nb
            push!(t, d.tab[i].taille)
        end
    end
    return t
end
# Fonction qui sert à récupérer le nombre d'objet total des données 1D
function get_nb_of_objet_1d(d::donnees1D)
    nb::Int64 = 0
    for i in 1:length(d.tab)
        nb += d.tab[i].nb
    end
    return nb
end