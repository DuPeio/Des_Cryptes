#!/bin/bash

declare -A code_morse # Lettre : morse
declare -A decode_morse # Morse : lettre

# sed -i -e 's/\r$//' ./SaeShell.sh

# Construction des Tables
while  read -r ligne
do
    # /"+."+|"+[_.]{1,6}"+/
    if [[ $ligne =~ \"([^\"]+)\"[[:space:]]*:[[:space:]]*\"([^\"]+)\" ]] # Teste si ligne correspond à une entrée JSON
    then
        cle="${BASH_REMATCH[1]}" # Premier Groupe entre ()
        valeur="${BASH_REMATCH[2]}" # Deuxieme Groupe entre ()
        
        code_morse["$cle"]="$valeur" # Ajoute les éléments a la liste d'associatioon
        decode_morse["$valeur"]="$cle"
    fi
done < 'morse.json'

erreur=0 # Variable globale pour les messages dans les menus
erreurFunc() { 
    # Fonction pour afficher des messages dans le menu
    if [ $1 == 1 ]
    then
        echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
        echo "              Choix invalide. Veuillez réessayer."
    elif [ $1 == 2 ]
    then
        echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
        echo "                $choixFichier n'existe pas..."
    elif [ $1 == 3 ]
    then
        echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
        echo "              FICHIER SAUVEGARDE AVEC SUCCES !"
    fi
    # erreur=0
}

codeMorse() {
    # Fonction qui à partir d'une string en parametre, retourne son équivalent en morse.
    nbErreurs=0
    string=$1 # Recupére la String en parametre
    # string=$(echo "$string" | grep -o "[A-Za-z0-9 ><\u002E\u002C\u0021\u003F\u003B\u003A\u0027\u0022\u0028\u0029\u002D\u00E0\u00F9\u003D\u002B\u0024\u0026\u00E9\u00E7\u002E\u002C\u0021\u003F\u003B\u003A\u0027\u0022\u0028\u0029\u005F\u00E8\u00F9\u0023\u007B\u007D\u005B\u007C\u0060\u005E\u0040\u007E\u20AC]")
    res=""
    noise=""
    for (( i=0; i<${#string}; i++ )) # Pour chaque char dans la String
    do
        trouve=0
        val=""
        char="${string:$i:1}" # On recupere le char
        char=$(echo "$char" | tr '[:lower:]' '[:upper:]') # Ce char est mis en majuscule
        
        for cle in "${!code_morse[@]}" # Pour chaque élément de la liste d'association
        do
            if [[ "$cle" == "$char" ]] # Si c'est l'élément que l'on cherche
            then
                trouve=1 # On indique qu'il a été trouvé
                val=${code_morse[$cle]} # et on met la valeur de val à son equivalent morse
                break
            fi
        done

        if [ $trouve -eq 1 ] # S'il a été trouvé
        then
            res="$res $val" # On l'ajoute à la chaine resultat
        else
            ((nbErreurs++)) # Sinon on augmente le nombre d'erreurs     NB : Utile pour du Debug
            if [[ "${string:$i:1}" == "*" ]] # J'ai ajouté cette condition parce que cela m'affichait le nom des fichiers dans le resulat
            then
                res="$res \*" # On annule l'effet de '*'
            # elif [[ "${string:$i:1}" =~ [A-Za-z0-9\u002E\u002C\u0021\u003F\u003B\u003A\u0027\u0022\u0028\u0029\u002D\u00E0\u00F9\u003D\u002B\u0024\u0026\u00E9\u00E7\u002E\u002C\u0021\u003F\u003B\u003A\u0027\u0022\u0028\u0029\u005F\u00E8\u00F9\u0023\u007B\u007D\u005B\u007C\u0060\u005E\u0040\u007E\u20AC] ]]
            # then
            else
                res="$res ${string:$i:1}" # Sinon on ajoute le char sans le coder
            fi
        fi
    done

    # Cette partie était pour faire du bruit mais ce n'est pas très concluant...
    for (( i=0; i<${#res}; i++ ))
    do
        char="${res:$i:1}"
        if [[ "$char" == "." ]]
        then 
            noise="$noise\a "
        elif [[ "$char" == "_" ]]
        then
            noise="$noise \a\a\a "
        fi
    done

    # echo -ne "$noise"
    echo -e "$res" # On affiche le resultat
    # echo ""
}

decodeMorse() {
    # Fonction qui à partir d'une string en parametre en morse, retourne son équivalent décodé.
    nbErreurs=0
    string=$1 # Récupére la String en parametre
    arr=(${string//" "/ }) # Split par des espaces
    res=""
    for val in "${arr[@]}"; # Pour chaque élément dans la liste arr
    do
        trouve=0
        txt=""
        
        if [[ -n decode_morse[$val] ]] # Si c'est notre code morse
        then
            trouve=1 # On indique qu'on l'a trouvé
            txt=$cle  # On met la valeur txt à son équivalent texte
            break
        fi

        if [ $trouve -eq 1 ] # Si on l'a trouvé
        then
            res="$res$txt" # On l'ajoute à la chaine resultat
        else
            ((nbErreurs++)) # Sinon on incrément la variable nbErreurs      NB : Utile pour Debug
            if [[ $val == "\*" ]] # On annule le pouvoir de l'étoile :D
            then
                res="$res*"
            else
                res="$res$val" # On ajoute l'élément qui n'est pas dans la liste d'Association à la chaine resultat
            fi
        fi
    done
    echo -e "$res" # On affiche le résultat
    # echo ""
}


decodeMorseRecursiveStart() {
    # Fonction qui permet d'initialiser la transformation morse/texte de maniere récursive
    string="$1" # On recupére la string
    arr=(${string//" "/ }) # On la découpe pour en faire une liste
    res=""

    decodeMorseRecursive 0 ${#arr[@]} "$res" "${arr[@]}" # On lance la fonction récursive avec l'indice courrant à 0, la taille de la liste, la chaine résultat (ici vide) et la chaine découpée
}

decodeMorseRecursive() {
    index=$1 # On récupére l'indice courant
    size=$2 # On récupére la taille de la liste
    res=$3 # On récupére le résultat
    arr=("${@:4}")  # On récupere la liste             # NB : $4 ne marche pas, faut recuperer tous les éléments à partir du 4eme (toute la liste donc)

    if [[ $index -ge $size ]] # CAS D'ARRET. Si notre indice courant est >= à la taille de la liste on s'arrete
    then
        echo -e "$res" # On affiche le résultat
        return 0 # On arrete le code ici
    fi

    val="${arr[$index]}" # On récupére l'élément à décoder
    trouve=0
    txt=""
    
    for cle in "${!code_morse[@]}" # On parcours les éléments de la liste d'association
    do
        if [[ "${code_morse[$cle]}" == "$val" ]] # Si la valeur à décoder est = cet élément de la liste
        then
            trouve=1 # On indique qu'il a été trouvé
            txt=$cle # On met la valeur décodée dans txt
            break
        fi
    done
    
    if [ $trouve -eq 1 ] # S'il a été trouvé 
    then
        res="$res$txt" # On l'ajoute au résultat
    else
        res="$res$val" # Sinon on ajoute la valeur non décodée 
    fi

    decodeMorseRecursive $((index + 1)) $size "$res" "${arr[@]}" # On continue la récursion mais à l'indice suivant
}


chiffrementFichierMorse() {
    # Fonction qui permet de transformer le contenu du fichier en premier Parametre, en morse dans le second fichier en parametre
    # NB : Ne teste absolument pas si les fichiers sont valides ici (pas son role)
    fichierEntree=$1 # Le chemin vers le fichier d'entrée
    fichierSortie=$2 # Le chemin vers le fichier de sortie

    cat "$fichierEntree" | while read -r ligne || [[ -n "$ligne" ]] # Lit le fichier fichier ligne par ligne + derniere ligne
    do
        ligneMorse=$(codeMorse "$ligne") # Convertit la ligne en version morse
        echo -e "$ligneMorse" >> "$fichierSortie" # Ajoute la version morse dans le fichier de sortie
    done

}
dechiffrementFichierMorse() {
    # Fonction qui permet de transformer le contenu du fichier en morse en premier parametre, dans le second fichier en parametre
    # NB : Ne teste absolument pas si les fichiers sont valides ici (pas son role)
    fichierEntree=$1 # Le chemin vers le fichier d'entrée
    fichierSortie=$2 # Le chemin vers le fichier de sortie

    cat "$fichierEntree" | while read -r ligneMorse || [[ -n "$ligneMorse" ]] # Lit le fichier fichier ligne par ligne + derniere ligne
    do
        ligne=$(decodeMorse "$ligneMorse") # Décode la ligne
        echo -e "$ligne" >> "$fichierSortie" # Ajoute le résultat au fichier de sortie
    done

}

titre=""
options=()
choixMorse=0

affichageScreen(){
    clear
    choixMorse=0
    taille=${#options[@]}
    # touche="   "

    affichage(){
        echo "---------------------------------------------------------------"
        echo "$titre"
        echo "---------------------------------------------------------------"
        for (( i=0; i<$taille; i++ ))
        do
            elmt=${options[$i]}  
            if [ $i -eq $choixMorse ]; then
                echo -e "\033[33m$elmt  <\033[0m"
            else
                echo "$elmt"
            fi
        done
        erreurFunc $erreur
        read -sn1 touche
    }
    

    
    affichage
    erreurFunc $erreur

    while [ "$touche" != "" ]; do
        if [ $touche = $'\x1b' ]; then
            read -sn2 touche
            case $touche in
                "[A")
                    clear
                    choixMorse=$((choixMorse-1))
                    while [ "${options[$choixMorse]}" == "" ]
                    do
                        choixMorse=$((choixMorse-1))
                        if [ $choixMorse -lt 0 ]; then 
                            choixMorse=$(($taille-1))
                        fi
                    done
                    if [ $choixMorse -lt 0 ]; then 
                        choixMorse=$(($taille-1))
                    fi
                    affichage
                    ;;
                "[B")
                    clear
                    choixMorse=$((choixMorse+1))
                    while [ "${options[$choixMorse]}" == "" ]
                    do
                        choixMorse=$((choixMorse+1))
                        if [ $choixMorse -gt $(($taille-1)) ]; then 
                            choixMorse=0
                        fi
                    done
                    if [ $choixMorse -gt $(($taille-1)) ]; then 
                        choixMorse=0
                    fi
                    affichage
                    ;;
                "*")
                    clear
                    affichage
                    ;;
            esac
        else
            clear
            affichage
        fi
    done
    erreur=0

}

morseMain(){

    options=("                        Chiffrer" "                       Dechiffrer" "" "                        Retour")
    titre="                          MORSE"
    affichageScreen

    case $choixMorse in
        "0")     
            clear
            morseMenu 0 # Lance un second sous menu en version chiffrer
            return 0 
            ;;
        "1")
            clear
            morseMenu 1 # Lance un second sous menu en version déchiffrer
            return 0
            ;;
        "3")
            clear # Ferme le menu
            ;;
        *)
            erreur=1 # Met erreur à 1 = choix incorrect
            morseMain # relance le menu
    esac
}

morseInput() {
    # Fonction qui lance le chiffrement ou déchiffrement selon l'option depuis l'input console

    clear

    opt=$1  # 0 = Chiffrement, #1 = Dechiffrement       Permet d'éviter d'avoir 2 fonctions différentes pour un travail très similaire

    echo "---------------------------------------------------------------"
    if [ $opt == 0 ]
    then
        echo "                  CHIFFREMENT MORSE INPUT"
    else
        echo "                  DECHIFFREMENT MORSE INPUT"
    fi
    echo "                 POUR QUITTER FAITES /exit"
    echo "---------------------------------------------------------------"
    exit=0
    while [ $exit -eq 0 ] # Tant que la condition de sortie n'est pas validée
    do
        read line # Lit la ligne dans la console
        case $line in
            "/exit")
                exit=1 # Si cette ligne est égale à "/exit" on met exit à 1 pour sortir de la boucle
                ;;
            *)
                if [ $opt == 0 ] # Sinon on code ou décode
                then
                    codeMorse "$line" # code la ligne en morse
                else
                    decodeMorseRecursiveStart "$line" # décode la ligne
                fi
                ;;
        esac
    done
}

choixFichierSortie="" # Variable globale pour le choix du fichier de sortie
choixFichier="" # Variable globale pour le choix du fichier d'entrée
morseFile() {
    # Fonction qui demande à l'utilisateur un fichier d'entrée et un fichier de sortie
    clear
    echo "---------------------------------------------------------------"
    echo "                     CHOIX DU FICHIER"
    echo "---------------------------------------------------------------"
    echo -ne " VOTRE CHOIX : "
    
    read choixFichier # Lit le choix de l'utilisateur
    echo ""
    if [ -f "$choixFichier" ] # Si le chemin correspond à un fichier d'entrée
    then
        fichierOK=0 # Variable qui indique si le fichier de sortie a été choisi
        while [ $fichierOK == 0 ] # Tant qu'il n'a pas été choisi
        do
            echo -ne " NOM DU FICHIER DE SORTIE : "
            read choixFichierSortie # On lit le chemin
            echo ""
            if [ -f "$choixFichierSortie" ] # Si le fichier existe déjà
            then
                echo -ne " CE FICHIER EXISTE DEJA, VOULEZ-VOUS LE SUPPRIMER ? (Y/N) : "
                read supprimer # On demande s'il faut le remplacer
                echo ""
                if [[ "$supprimer" == "Y" ]]
                then
                    rm -f "$choixFichierSortie" # On le supprime            # NB : -f pour ne pas demander de confirmation
                    fichierOK=1 # On indique que le fichier a été choisi
                fi
            elif [[ "$choixFichierSortie" =~ [\/] ]] # On teste si le nom ne contient pas de caracteres interdits
            then
                echo "NOM DE FICHIER INCORRECT. CARACTERES INTERDITS."
            elif [ ${#choixFichierSortie} -gt 255 ] # On teste si le nom n'est pas trop long
            then
                echo "TAILLE DU NOM DE FICHIER TROP GRANDE."
            elif [ ${#choixFichierSortie} -lt 2 ] # si le nom n'est pas trop petit
            then
                echo "TAILLE DU NOM DE FICHIER TROP PETITE."
            else
                fichierOK=1 # Sinon on indique qu'il est valide
            fi
        done
        touch "$choixFichierSortie" # Le fichier est créé


    else
        erreur=2 # Sinon on indique que le fichier d'entrée est introuvable
        return 2 # Valeur de sortie pour : Le fichier n'existe pas 
    fi
    return 0 # Valeur de sortie pour : tout est ok
}


morseMenu() {
    # Fonction qui permet d'afficher le menu de selection de ce qu'il faut coder ou décoder (input ou fichier)
    clear

    opt=$1 # 0 Chiffrement, 1 Dechiffrement

    if [ $opt -eq 0 ]
    then
        titre="                    CHIFFREMENT MORSE"
    else
        titre="                   DECHIFFREMENT MORSE"
    fi

    options=("                  Via Un Fichier Externe" "                       Via l'Input" "" "                        Retour")
    affichageScreen

    case $choixMorse in
        "0")
            morseFile # On lance le menu pour choisir les fichiers
            if [ $? != 0 ] # Si tout ne s'est pas passé correctement
            then
                morseMain # on retourne au menu principal du morse
                return 0
            fi

            if [ $opt == 0 ] # Sinon on chiffre ou déchiffre
            then
                echo "CHIFFREMENT EN COURS, VEUILLEZ PATIENTER ..."
                chiffrementFichierMorse "$choixFichier" "$choixFichierSortie" # code le contenu du fichier d'entrée dans le fichier de sortie
            else
                echo "DECHIFFREMENT EN COURS, VEUILLEZ PATIENTER ..."
                dechiffrementFichierMorse "$choixFichier" "$choixFichierSortie" # décode le contenu du fichier d'entrée dans le fichier de sortie
            fi
            erreur=3  # Valeur pour indiquer comme message que tout s'est passé correctement
            clear
            ;;
        "1")
            morseInput $opt # Lance le menu code ou décode via l'input console
            ;;
        "3")
            clear # On quitte le menu
            ;;
        *)
            erreur=1 # On indique un choix incorrect
            morseMenu # On relance le menu
            return 0
    esac
    morseMain # On retourne au menu principal
}