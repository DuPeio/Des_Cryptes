#!/bin/bash
source tools.sh
source morse.sh
source vigenere.sh
source caesar.sh

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
        echo "              Choisissez un mode de chiffrement"
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
                    ;;
            esac
        fi
    done
        # echo choix

    # done

    case $choixIndice in
        "0")     
            echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
            echo "             Vous avez choisi le Code Morse"
            morseMain
            main
            ;;
        "1")
            echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
            echo "             Vous avez choisi le Code Caesar"
            caesarMain
            ;;
        "2")
            echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
            echo "            Vous avez choisi le Code de Vigenère"
            vigenereMain
            ;;
        "3")
            echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
            echo "          Vous avez choisi de quitter le programme"
            quitter
            ;;
        *)
            # message="+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\n                Choix invalide. Veuillez réessayer.\n+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\n"
            main
    esac
    # echo $choix //Pour test
}

main