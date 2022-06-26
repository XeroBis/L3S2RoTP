using JuMP, GLPK

function question_3_1_solveur(solverSelected::DataType, r::Int64, l_h::Vector{Vector{Int64}}, L::Int64, H::Int64)
    # r : le nombre d'objet
    # l_h : tableau de la taille de chaque objet
    # L : largeur de la bin
    # H : hauteur de la bin

    # Déclaration d'un modèle (initialement vide)
    model::Model = Model(solverSelected)

    # Déclaration des variables
    @variable(model, x[1:r]>= 0, integer = true)
    @variable(model, y[1:r]>= 0, integer = true)

    @variable(model, b1[1:r, 1:r], binary = true)
    @variable(model, b2[1:r, 1:r], binary = true)
    @variable(model, b3[1:r, 1:r], binary = true)
    @variable(model, b4[1:r, 1:r], binary = true)

    # Déclaration des contraintes
    @constraint(model, constrL[i=1:r], x[i]+ l_h[i][1] <= L)
    @constraint(model, constrH[i=1:r], y[i]+ l_h[i][2] <= H)

    @constraint(model, constrBin1[i=1:r,j=1:r; i<j], x[i] + l_h[i][1] <= x[j] + H*L * (1- b1[i, j]))
    @constraint(model, constrBin2[i=1:r,j=1:r; i<j], x[j] + l_h[j][1] <= x[i] + H*L * (1- b2[i, j]))
    @constraint(model, constrBin3[i=1:r,j=1:r; i<j], y[i] + l_h[i][2] <= y[j] + H*L * (1- b3[i, j]))
    @constraint(model, constrBin4[i=1:r,j=1:r; i<j], y[j] + l_h[j][2] <= y[i] + H*L * (1- b4[i, j]))

    @constraint(model, constrSommeB[i=1:r, j=1:r], b1[i,j] + b2[i,j] + b3[i,j] + b4[i,j] .>= 1)

    # Résolution
    optimize!(model)

    # Affichage des résultats (ici assez complet pour gérer certains cas d'"erreur")
    status = termination_status(model)

    if status == MOI.OPTIMAL
        return true
    else
        return false
    end
    
end

function question_3_1_call(d::donnees2D)
    question_3_1_sub_call(d.tab, d.L, d.H)
end

function question_3_1_sub_call(tab::Vector{objet2D}, L::Int64, H::Int64)
    # Déclaration des données
    r::Int64 = get_number_of_objets(tab) # le nombre d'objets totale
    l_h::Vector{Vector{Int64}} = get_l_and_h_of_every_objets(tab)

    # Création d'un modèle complété à partir des données
    return question_3_1_solveur(GLPK.Optimizer, r, l_h, L, H)
end

function get_number_of_objets(tab::Vector{objet2D})
    result::Int64 = 0
    for i in 1:size(tab,1)
        result = result + tab[i].nb
    end
    return result
end

function get_l_and_h_of_every_objets(tab::Vector{objet2D})
    result::Vector{Vector{Int64}} = []
    for i in 1:size(tab,1)
        currentResult::Vector{Int64} = []
        for j in 1:tab[i].nb
            push!(currentResult, deepcopy(tab[i].l))
            push!(currentResult, deepcopy(tab[i].h))
            push!(result, deepcopy(currentResult))
            currentResult = []
        end
    end
    return result
end