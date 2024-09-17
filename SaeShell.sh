#!/bin/bash


source morse.sh
source vigenere.sh
source caesar.sh
source tools.sh

#Partie Globale : Main
main() {
    # clear
    echo "---------------------------------------------------------------"
    echo "              Choisissez un mode de chiffrement"
    echo "---------------------------------------------------------------"
    echo "                        Code Morse (1)"
    echo "                        Code Caesar (2)"
    echo "                      Code de Vigenère (3)"
    echo "                    Quitter le programme (4)"

    read choix

    case $choix in
        "1")     
            echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
            echo "             Vous avez choisi le Code Morse"
            morseMain
            ;;
        "2")
            echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
            echo "             Vous avez choisi le Code Caesar"
            caesarMain
            ;;
        "3")
            echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
            echo "            Vous avez choisi le Code de Vigenère"
            vigenereMain
            ;;
        "4")
            echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
            echo "          Vous avez choisi de quitter le programme"
            quitter
            ;;
        *)
            echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
            echo "             Choix invalide. Veuillez réessayer."
            main
    esac
    main
    # echo $choix //Pour test
}

main
