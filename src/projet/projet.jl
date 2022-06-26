# Alan

using JuMP, GLPK # On va utiliser JuMP et GLPK


# Structures contenant les données d'un problème de bin-packing mono-dimensionnel
struct objet1D
	taille::Int64 # Taille de l'objet
	nb::Int64 # Nombre d'objets de la même taille
end

struct donnees1D
	T::Int64 # Taille d'un bin
    nb::Int64 # Nombre de tailles d'objet différents
	tab::Vector{objet1D} # Tableau des objets à insérer dans les bins
end


# Structures contenant les données d'un problème de bin-packing bi-dimensionnel
struct objet2D
	l::Int64 # Largeur de la pièce
	h::Int64 # Hauteur de la pièce
	nb::Int64 # Nombre d'objets dans ce format
end

struct donnees2D
	L::Int64 # Largeur d'un bin
	H::Int64 # Hauteur d'un bin
    nb::Int64 # Nombre de types d'objet différents
	tab::Vector{objet2D} # Tableau des objets à insérer dans les bins
end


# Fonction prenant en entrée un nom de fichier et retournant les données d'une instance de problème de bin-packing mono-dimensionnel
function parser_data1D(nomFichier::String)
    # Ouverture d'un fichier en lecture
    f = open(nomFichier,"r")

    # Lecture de la première ligne pour connaître la taille d'un bin et le nombre de tailles différentes pour les objets à ranger
    s::String = readline(f) # lecture d'une ligne et stockage dans une chaîne de caractères
    ligne::Vector{Int64} = parse.(Int64,split(s," ",keepempty = false)) # Segmentation de la ligne en plusieurs entiers, à stocker dans un tableau
    T::Int64 = ligne[1]
    nb::Int64 = ligne[2]

    # Allocation mémoire pour le tableau des objets
    tab = Vector{objet1D}(undef,nb)

    # Lecture des infos sur les objets (sur chaque ligne : taille + nombre)
    for i in 1:nb
        s = readline(f)
        ligne = parse.(Int64,split(s," ",keepempty = false))
        tab[i] = objet1D(ligne[1],ligne[2])
    end

    # Fermeture du fichier
    close(f)

    # Retour des donnees
    return donnees1D(T,nb,tab)
end

# Fonction prenant en entrée un nom de fichier et retournant les données d'une instance de problème de bin-packing bi-dimensionnel
function parser_data2D(nomFichier::String)
    # Ouverture d'un fichier en lecture
    f = open(nomFichier,"r")

    # Lecture de la première ligne pour connaître la largeur et la hauteur d'un bin et le nombre de types d'objets différents à ranger
    s::String = readline(f) # lecture d'une ligne et stockage dans une chaîne de caractères
    ligne::Vector{Int64} = parse.(Int64,split(s," ",keepempty = false)) # Segmentation de la ligne en plusieurs entiers, à stocker dans un tableau
    L::Int64 = ligne[1]
	H::Int64 = ligne[2]
    nb::Int64 = ligne[3]

    # Allocation mémoire pour le tableau des objets
    tab = Vector{objet2D}(undef,nb)

    # Lecture des infos sur les objets (sur chaque ligne : largeur + hauteur + nombre)
    for i in 1:nb
        s = readline(f)
        ligne = parse.(Int64,split(s," ",keepempty = false))
        tab[i] = objet2D(ligne[1],ligne[2],ligne[3])
    end
    # Fermeture du fichier
    close(f)
    # Retour des donnees
    return donnees2D(L,H,nb,tab)
end

