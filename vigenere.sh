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

        "2")

        "3")

        "4")

        *)
            echo "Veuillez choisir une action valide"
            ;;
}