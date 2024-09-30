#!/bin/bash

# Pouvoir utiliser les fonctions des autres fichiers
source tools.sh
source morse.sh
source vigenere.sh
source caesar.sh

# Pierre MAGIEU, Sebastian CARON, Dylan BRUN

#Partie Globale : Main
main() {
    clear
    choixTab=("                          Code Morse" "                          Code Caesar" "                       Code de Vigenère"  "                      Quitter le programme")
    choixIndice=0
    choix="${choixTab[choixIndice]}"
    
    # while [ choisi -ne true ]; do
    affichage(){
        choix="${choixTab[choixIndice]}"
        echo "---------------------------------------------------------------"
        echo "                Choisissez un mode de codage"
        echo "---------------------------------------------------------------"
        for elmt in "${choixTab[@]}"; do
            if [ "$choix" = "$elmt" ]; then
                echo -e "\033[33m$elmt  <\033[0m"
            else
                echo "$elmt"
            fi
        done
        read -sn1 touche
    }
    

    
    affichage
    while [ "$touche" != "" ]; do
    

        if [ $touche = $'\x1b' ]; then
            read -sn2 touche
            case $touche in
                "[A")
                    clear
                    choixIndice=$((choixIndice-1))
                    if [ $choixIndice -lt 0 ]; then 
                        choixIndice=3
                    fi
                    affichage
                    ;;
                "[B")
                    clear
                    choixIndice=$((choixIndice+1))
                    if [ $choixIndice -gt 3 ]; then 
                        choixIndice=0
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

    case $choixIndice in
        "0")     
            morseMain
            main
            ;;
        "1")
            caesarMain
            ;;
        "2")
            vigenereMain
            ;;
        "3")
            quitter
            ;;
        *)
            main
    esac
}

main