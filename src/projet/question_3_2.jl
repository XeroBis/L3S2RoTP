function get_motifs(d::donnees2D)
    motifs::Vector{Vector{Int64}} = []

    tab::Vector{objet2D} = d.tab

    localM::Vector{Int64} = []
    # vecteur d'objet2d, chacque objet 2D aura nb à 1
    tailleObjets::Vector{objet2D} = tab
    somme::Vector{objet2D} = []

    motifs = calcul_motifs(1, somme, d.L, d.H, localM, tailleObjets, motifs)
    return motifs
end

function calcul_motifs(l::Int64, 
    somme::Vector{objet2D}, 
    L_bin::Int64,
    H_bin::Int64,
    localMotif::Vector{Int64},
    tailleObjets::Vector{objet2D},
    motifs::Vector{Vector{Int64}})
    added::Bool = false
    for i in l:size(tailleObjets, 1)
        realSomme::Vector{objet2D} = deepcopy(somme)
        push!(realSomme, objet2D(tailleObjets[i].l, tailleObjets[i].h, 1))
        if (question_3_1_sub_call(realSomme, L_bin, H_bin))
            added = true
            push!(localMotif, i)
            vcat(motifs, calcul_motifs(i,realSomme,L_bin, H_bin, deepcopy(localMotif), tailleObjets, motifs))
            pop!(localMotif)
        end
        newSomme = []
    end
    if (!added)
        push!(motifs, localMotif)
    end
    return motifs
end

function addObjet2D(somme::Vector{objet2D},obj::objet2D)
    for i in 1:size(somme,1)
        if somme[i].l == obj.l && somme[i].h == obj.h
            somme[i]  = objet2D(obj.l, obj.h, somme[i].nb+1)
            return somme
        end
    end
    push!(somme, deepcopy(obj))
    return somme
end