#!/bin/bash

declare -A code_morse # Lettre : morse
# declare -A decode_morse # Morse : Lettre

# Construction des Tables
while  read -r ligne
do
    # echo $ligne
    # /"+."+|"+[_.]{1,6}"+/
    if [[ $ligne =~ \"([^\"]+)\"[[:space:]]*:[[:space:]]*\"([^\"]+)\" ]]
    then
        # echo $ligne
        cle="${BASH_REMATCH[1]}" # Premier Groupe entre ()
        valeur="${BASH_REMATCH[2]}" # Deuxieme Groupe entre ()
        
        code_morse["$cle"]="$valeur"
        # echo "Clé: $cle, Valeur: ${code_morse[$cle]}"
        # decode_morse["$valeur"]="$cle"
    fi
done < 'morse.json'

#DEBUG
# echo "Clé: A, Valeur: ${code_morse["A"]}"
# for cle in "${!code_morse[@]}"; do
#     echo "Clé: $cle, Valeur: ${code_morse[$cle]}"
# done

erreurFunc() {
    if [ $1 == 1 ]
    then
        echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
        echo "              Choix invalide. Veuillez réessayer."
    elif [ $1 == 2 ]
    then
        echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
        echo "              Le Fichier n'existe pas..."
    fi
}

codeMorse() {
    string=$1
    res=""
    noise=""
    for (( i=0; i<${#string}; i++ )); do
        trouve=0
        val=""
        char="${string:$i:1}"
        char=$(echo "$char" | tr '[:lower:]' '[:upper:]')
        for cle in "${!code_morse[@]}"
        do
            if [[ "$cle" == "$char" ]]
            then
                trouve=1
                val=${code_morse[$cle]}
                break
            fi
        done
        if [ $trouve -eq 1 ]
        then
            res="$res $val"
        else
            res="$res ${string:$i:1}"
        fi
    done
    for (( i=0; i<${#res}; i++ ))
    do
        char="${res:$i:1}"
        if [[ "$char" == "." ]]
        then 
            noise="$noise\a "
        elif [[ "$char" == "_" ]]
        then
            noise="$noise \007\007\007 "
        fi
    done
    # echo -ne "$noise"
    echo "$res"
}



erreur=0
morseMain(){
    clear
    echo "---------------------------------------------------------------"
    echo "                          MORSE"
    echo "---------------------------------------------------------------"
    echo -ne "                        Chiffrer (1)    \tTEXT \t->\t MORSE\n"
    echo -ne "                       Dechiffrer (2)   \tMORSE \t->\t TEXT\n"
    echo ""
    echo "                        Retour (4)"

    erreurFunc $erreur
    erreur=0
    echo -ne " VOTRE CHOIX : "
    read choixMorse
    echo ""

    case $choixMorse in
        "1")     
            clear
            morseChiff
            return 0
            ;;
        "2")
            clear
            ;;
        "4")
            clear
            ;;
        *)
            erreur=1
            morseMain
    esac
}

morseChiff() {
    clear
    echo "---------------------------------------------------------------"
    echo "                    CHIFFREMENT MORSE"
    echo "---------------------------------------------------------------"
    echo "                  Via Un Fichier Externe (1)   "
    echo "                       Via l'Input (2)"
    echo ""
    echo "                        Retour (4)"

    erreurFunc $erreur
    erreur=0
    echo -ne " VOTRE CHOIX : "
    read choixMorse
    echo ""
    case $choixMorse in
        "1")
            morseChiffFile     
            clear
            ;;
        "2")
            # clear
            morseChiffInput
            ;;
        "4")
            clear
            ;;
        *)
            erreur=1
            morseChiff
            return 0
    esac
    morseMain
}

morseChiffInput() {
    clear
    echo "---------------------------------------------------------------"
    echo "                  CHIFFREMENT MORSE INPUT"
    echo "                 POUR QUITTER FAITES /exit"
    echo "---------------------------------------------------------------"
    exit=0
    while [ $exit -eq 0 ]
    do
        read line
        case $line in
            "/exit")
                exit=1
                ;;
            *)
                codeMorse "$line"
                ;;
        esac
    done
    # morseChiff
}

morseChiffFile() {
    clear
    echo "---------------------------------------------------------------"
    echo "                     CHOIX DU FICHIER"
    echo "---------------------------------------------------------------"
    echo -ne " VOTRE CHOIX : "

    choixFichierSortie=""

    read choixFichier
    echo ""
    if [ -f "$choixFichier" ]
    then
        fichierOK=0
        while [ $fichierOK == 0 ]
        do
            echo -ne " NOM DU FICHIER DE SORTIE : "
            read choixFichierSortie
            echo ""
            if [ -f "$choixFichierSortie" ]
            then
                echo -ne " CE FICHIER EXISTE DEJA, VOULEZ-VOUS LE SUPPRIMER ? (Y/N) : "
                read supprimer
                echo ""
                if [[ "$supprimer" == "Y" ]]
                then
                    rm -f "$choixFichierSortie"
                    fichierOK=1
                fi
            elif [[ "$choixFichierSortie" =~ [\/] ]]
            then
                echo "NOM DE FICHIER INCORRECT. CARACTERES INTERDITS."
            elif [ ${#nom_fichier} -gt 255 || ${#nom_fichier} -eq 0 ]
            then
                echo "TAILLE DU NOM DE FICHIER INCORRECTE."
            else
                fichierOK=1
            fi
        done



    else
        erreur=2
    fi
}