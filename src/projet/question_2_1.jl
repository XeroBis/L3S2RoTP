# Fonction qui crée un tableau d'objets 1D, et qui le renvoie trié 
function trie_tableau_1D(d::donnees1D)
    tab::Vector{objet1D} = d.tab
    tab_trié::Vector{objet1D} = Vector{objet1D}()
    max::Int64 = 0
    idMax::Int64 = 0
    for i in 1:length(d.tab)
        for j in 1:length(tab)
            if tab[j].taille > max
                max = tab[j].taille
                idMax = j
            end
        end
        push!(tab_trié, tab[idMax])
        splice!(tab, idMax)
        idMax = 0
        max = 0
    end
    tab_trié
end

#Notre algo glouton
function algo_glouton_1D(d::donnees1D)
    tab::Vector{objet1D} = trie_tableau_1D(d)

    Bins::Vector{Int64} = Vector{Int64}()

    for i in 1:size(tab, 1)
        for j in 1:tab[i].nb
            Bins = add_object_to_bins(tab[i].taille, Bins, d.T)
        end
    end
    return size(Bins, 1)
end

# Fonction qui ajoute un objet au bins présente ou l'ajoute dans une nouvelle bin si l'objet ne peut pas être ajouter
function add_object_to_bins(taille::Int64, bins::Vector{Int64}, tailleBin::Int64)
    index::Int64 = 0
    maxFutureSize::Int64 = 0
    for i in 1:size(bins, 1)
        if bins[i] + taille <= tailleBin
            bins[i] = bins[i] + taille
            return bins
        end
    end
    append!(bins,[0])
    bins[size(bins, 1)] = taille
    return bins
end