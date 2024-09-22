#!/bin/bash

source tools.sh

#Partie du GOAT (Dylan)
vigenereMain() {
    clear

    echo "+-------------------------------------------------------------+"
    echo "|                Veuillez choisir une action                  |"
    echo "+-------------------------------------------------------------+"
    echo "|                       Chiffrer (1)                          |"
    echo "|                      Dechiffrer (2)                         |"
    echo "|                        Retour (3)                           |"
    echo "•                       Quitter  (4)                          •"

    echo ""
    local choixVigenere=""
    read choixVigenere

    clear

    case $choixVigenere in
        "1")
            chiffrerVigenere
            ;;

        "2")
            dechiffrerVigenere
            ;;

        "3")
            main
            ;;

        "4")
            quitter
            ;;

        *)
            echo "Veuillez choisir une action valide"
            vigenereMain
            ;;
    esac
}

chiffrerVigenere() {
    echo "+-------------------------------------------------------------+"
    echo "|                Veuillez choisir une action                  |"
    echo "+-------------------------------------------------------------+"
    echo "|                    Choisir une clé (1)                      |"
    echo "|                Utiliser une clé générée (2)                 |"
    echo "|                        Retour (3)                           |"
    echo "•                       Quitter  (4)                          •"

    echo ""
    local actionChif=""
    local cle=""
    local phrase=""
    read actionChif

    clear

    case $actionChif in
        "1")
            cle="$(choixCle)"
            phrase="$(choixPhrase)"
            echo "$cle"
            chiffrementVigenere "$cle" "$phrase"
            ;;
        "2")
            echo ""
            cle="$(genCle)"
            phrase="$(choixPhrase)"
            chiffrementVigenere "$cle" "$phrase"
            ;;
        "3")
            vigenereMain
            ;;
        "4")
            quitter
            ;;  
        *)
            echo "Veuillez choisir une action valide"
            chiffrerVigenere
            ;;
    esac
}

dechiffrerVigenere() {
    echo "+-------------------------------------------------------------+"
    echo "|                Veuillez choisir une action                  |"
    echo "+-------------------------------------------------------------+"
    echo "|                    Choisir une clé (1)                      |"
    echo "|                        Retour (2)                           |"
    echo "•                       Quitter  (3)                          •"

    local actionDechif=""
    read actionDechif

    case $actionDechif in
        "1")
            ;;
        "2")
            vigenereMain
            ;;
        "3")
            quitter
            ;;  
        *)
            echo "Veuillez choisir une action valide"
            dechiffrerVigenere
            ;;
    esac
}

choixCle() {
    local cle=""
    
    printf "Veuillez choisir une clé: " >&2
    read cle

    while ! [[ "$cle" =~ ^[a-zA-Z]+$ ]]; do
        clear
        cle=""
        printf "La clé doit contenir uniquement des lettres\n\n" >&2
        printf "Veuillez choisir une clé: " >&2
        read cle
        printf "\n" >&2
    done

    echo "$cle"
}

choixPhrase() {
    local phrase=""
    
    printf "Veuillez écrire une phrase: " >&2
    read phrase
    printf "\n" >&2

    echo "$phrase"
}

genCle() {
    local cle=""
    local taille=$(((RANDOM + 1) % 69))

    for ((i=0; i<taille; i++)); do
        printf "%03o \n" 97
        # cle+=$(printf "%c" $((RANDOM % 26 + 97)))
    done
    # printf "%s" $cle >&2
    # echo "$cle"
}

chiffrementVigenere() {
    #Initialisation de toutes les variables
    local key="$1"
    local sentence="$2"
    local ind=0
    local res=""
    local chara=""
    local char=""
    local len_key=${#key}
    local len_sentence=${#sentence}
    printf "%s\n" $key >&2

    for (( i=0; i<len_sentence; i++ )); do
        chara=${key:ind % len_key:1}
        char=${sentence:i:1}

        while ! [[ "$chara" =~ [a-zA-Z] ]]; do
            ((ind++))
            chara=${key:ind % len_key:1}
        done
        if [[ "$chara" =~ [A-Z] ]]; then
            chara=$(echo "$chara" | tr '[:upper:]' '[:lower:]')
        fi

        #Vérification si le caractère est une lettre minuscule, majuscule, ou un chiffre, sinon ajouter sans changement
        if [[ "$char" =~ [a-z] ]]; then
            res+=$(printf "\\$(printf '%03o' $(( ( $(printf '%d' "'$chara") - $(printf '%d' "'a") + $(printf '%d' "'$char") - $(printf '%d' "'a") ) % 26 + $(printf '%d' "'a") )) )")       #Ajout du caractère crypté dans le résultat
            ((ind++))
        elif [[ "$char" =~ [A-Z] ]]; then
            res+=$(printf "\\$(printf '%03o' $(( ( $(printf '%d' "'$chara") - $(printf '%d' "'A") + $(printf '%d' "'$char") - $(printf '%d' "'A") ) % 26 + $(printf '%d' "'A") )) )")       #Ajout du caractère crypté dans le résultat
            ((ind++))
        elif [[ "$char" =~ [0-9] ]]; then
            res+=$((($char+$ind)%10))       #Ajout du chiffre crypté
            ((ind++))
        else
            res+="$char"        #Ajout des caractères non cryptables
        fi
    done

    echo "$res"     #Affichage de la phrase crypté
}

dechiffrementVigenere() {
    echo "test"
}

# vigenereMain
# genCle
# choixCle

# chiffrementVigenere "castor" "lorem ipsum dolor"
# chiffrementVigenere "CaSt69420or/." "lorem ipsum dolor"
# chiffrementVigenere "69450" "lorem ipsum dolor"
