#!/bin/bash

source tools.sh

#Partie du GOAT (Dylan)

cle=""
phrase=""

actionInvalide() {
    echo ""
    echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
    echo "               Veuillez choisir une action valide"
    echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
    echo ""
    sleep 1
    clear
}

vigenereMain() {
    clear
    vigenereMain_
}

vigenereMain_() {
    echo "+-------------------------------------------------------------+"
    echo "|                Veuillez choisir une action                  |"
    echo "+-------------------------------------------------------------+"
    echo "|                       Chiffrer (1)                          |"
    echo "|                      Dechiffrer (2)                         |"
    echo "|                        Retour (3)                           |"
    echo "•                       Quitter  (4)                          •"

    echo ""
    local choixVigenere=""
    cle=""
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
            actionInvalide
            vigenereMain_
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
    read actionChif

    clear

    case $actionChif in
        "1")
            choixCle
            clear
            choixPhrase
            clear
            echo "Voici la clé: $cle"
            chiffrementVigenere "$cle" "$phrase"
            ;;
        "2")
            echo ""
            genCle
            choixPhrase
            clear
            echo "Voici la clé: $cle"
            chiffrementVigenere "$cle" "$phrase"
            ;;
        "3")
            vigenereMain_
            ;;
        "4")
            quitter
            ;;  
        *)
            actionInvalide
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

    clear

    case $actionDechif in
        "1")
            choixCle
            choixPhrase
            ;;
        "2")
            vigenereMain_
            ;;
        "3")
            quitter
            ;;  
        *)
            actionInvalide
            dechiffrerVigenere
            ;;
    esac
}

choixCle() {
    local choix=""

    printf "Veuillez choisir une clé: "
    read choix

    while ! [[ "$choix" =~ ^[a-zA-Z]+$ ]]; do       #Tant que le choix ne contient pas uniquement des lettres, alors on redemande de saisir une clé
        clear
        choix=""
        echo ""
        echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
        echo "         La clé doit contenir uniquement des lettres"
        echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
        echo ""
        sleep 1
        clear
        printf "Veuillez choisir une clé: "
        read choix
        echo "\n"
    done

    cle=$choix
}

choixPhrase() {
    local phrs=""
    
    printf "Veuillez écrire une phrase: "
    read phrs
    echo "\n"

    phrase=$phrs
}

genCle() {
    local res=""
    local taille=$((RANDOM % 69 + 1))

    for ((i=0; i<taille; i++)); do
        res+=$(printf "\\$(printf '%o' $((RANDOM % 26 + 97)))")
    done

    cle=$res
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

    for (( i=0; i<len_sentence; i++ )); do
        chara=${key:ind % len_key:1}        #caractère de key à l'index ind
        char=${sentence:i:1}        #caractère de sentence à l'index i

        #Tant que le caractère n'est pas utilisable en tant que clé, le prochain sera utilisé, et si on atteint la fin, on retourne au début
        while ! [[ "$chara" =~ [a-zA-Z] ]]; do
            ((ind++))
            chara=${key:ind % len_key:1}
        done
        if [[ "$chara" =~ [A-Z] ]]; then
            chara=$(echo "$chara" | tr '[:upper:]' '[:lower:]')     #Passage de majuscule vers minuscule des lettres de la clé
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

    echo "Voici la phrase chiffrée: $res"     #Affichage de la phrase crypté
}

dechiffrementVigenere() {
    echo "test"
}