function get_motifs(d::donnees1D)

    motifs::Vector{Vector{Int64}} = []

    tab::Vector{objet1D} = d.tab

    tailleObjets::Vector{Int64} = get_taille_objet(tab)

    localM::Vector{Int64} = []

    motifs = calcul_motifs(1, 0, d.T,localM, tailleObjets, motifs)

    return motifs
end

# Fonction qui trouve effectivement les motifs
function calcul_motifs(l::Int64,somme::Int64,tailleBin::Int64, localMotif::Vector{Int64},tailleObjets::Vector{Int64}, motifs::Vector{Vector{Int64}})
    added::Bool = false
    for i in l:size(tailleObjets,1)
        if somme + tailleObjets[i] <= tailleBin
            added = true
            push!(localMotif, i)
            vcat(motifs, calcul_motifs(i, somme+tailleObjets[i], tailleBin, deepcopy(localMotif), tailleObjets, motifs))
            pop!(localMotif)
        end
    end
    if (!added)
        push!(motifs, localMotif)
    end
    return motifs

end


function get_vector_object(nbObjet::Int64, motifs::Vector{Vector{Int64}})
    result::Vector{Vector{Int64}} = []
    for i in 1:nbObjet
        currentResult::Vector{Int64} = []
        for j in 1:size(motifs, 1)
            push!(currentResult, count_occurence_of_number_in_vector(i, motifs[j]))
        end
        push!(result, deepcopy(currentResult))
    end
    return result
end

function count_occurence_of_number_in_vector(number::Int64, vector::Vector{Int64})
    total::Int64 = 0
    for i in 1:size(vector, 1)
        if vector[i] == number
            total = total + 1
        end
    end
    return total
end

function get_nb_of_objet_vector(d::donnees1D)
    result::Vector{Int64} = []
    for i in 1:size(d.tab, 1)
        push!(result, d.tab[i].nb)
    end
    return result
end

function get_taille_objet(tab::Vector{objet1D})
    result::Vector{Int64} = []
    for i in 1:size(tab,1)
        push!(result, tab[i].taille)
    end
    return result
end