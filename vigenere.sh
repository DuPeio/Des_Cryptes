#!/bin/bash

#Partie du GOAT (Dylan)
vigenereMain() {
    echo "---------------------------------------------------------------"
    echo "                 Veuillez choisir une action:"
    echo "---------------------------------------------------------------"
    echo "                        Chiffrer (1)"
    echo "                       Dechiffrer (2)"
    echo "                         Retour (3)"
    echo "                         Quitter (4)"

    read choixVigenere

    case $choixVigenere in
        "1")
            echo "---------------------------------------------------------------"
            echo "                 Veuillez choisir une clé:"
            echo "---------------------------------------------------------------"
            echo "                     Choisir une clé (1)"
            echo "                 Utiliser une clé générée (2)"
            echo "                         Retour (3)"
            echo "                         Quitter (4)"

            read choixCle

            case $choixCle in
                "1")
                    ;;
                "2")
                    ;;
                "3")
                    ;;
                "4")
                    quitter
                    ;;  
                *)
                    ;;
            esac
            ;;

        "2")
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
            return 0
            ;;
    esac
}

chiffrementVigenere() {
    #Initialisation de toutes les variables
    sentence="$1"
    key="$2"
    ind=0
    res=""
    chara=""
    len_key=${#key}
    len_sentence=${#sentence}

    for (( i=0; i<len_sentence; i++ )); do
        chara=${key:ind % len_key:1}
        char=${sentence:i:1}

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

chiffrementVigenere "ma phrase" "castor"