#!/bin/bash

source tools.sh

#Partie du GOAT (Dylan)
vigenereMain() {
    echo "+-------------------------------------------------------------+"
    echo "|                Veuillez choisir une action                  |"
    echo "+-------------------------------------------------------------+"
    echo "|                       Chiffrer (1)                          |"
    echo "|                      Dechiffrer (2)                         |"
    echo "|                        Retour (3)                           |"
    echo "•                       Quitter  (4)                          •"

    read choixVigenere

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

    read actionChif

    case $actionChif in
        "1")
            cle="$(choixCle)"
            phrase="$(choixPhrase)"
            chiffrementVigenere "$cle" "$phrase"
            ;;
        "2")
            phrase="$(choixPhrase)"
            ;;
        "3")
            vigenereMain
            ;;
        "4")
            quitter
            ;;  
        *)
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
            chiffrerVigenere
            ;;
    esac
}

choixCle() {

}

choixPhrase() {

}

chiffrementVigenere() {
    #Initialisation de toutes les variables
    key="$1"
    sentence="$2"
    ind=0
    res=""
    chara=""
    char=""
    len_key=${#key}
    len_sentence=${#sentence}

    if ! [[ "$key" =~ .*[a-zA-Z]+.* ]]; then
        vigenereMain
    fi

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

# vigenereMain

# chiffrementVigenere "castor" "lorem ipsum dolor"
# chiffrementVigenere "CaSt69420or/." "lorem ipsum dolor"
# chiffrementVigenere "69450" "lorem ipsum dolor"
