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

codeMorse() {
    string=$1
    res=""
    for (( i=0; i<${#string}; i++ )); do
        trouve=0
        val=""
        char="${string:$i:1}"
        char=$(echo "$char" | tr '[:lower:]' '[:upper:]')
        for cle in "${!code_morse[@]}"; do
            if [[ "$cle" == "$char" ]]; then
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
    echo "$res"
}

erreur=0
morseMain(){
    clear
    echo "---------------------------------------------------------------"
    echo "                          MORSE"
    echo "---------------------------------------------------------------"
    echo "                        Chiffrer (1)    TEXT \t->\t MORSE"
    echo "                       Dechiffrer (2)   MORSE \t->\t TEXT"
    echo ""
    echo "                        Retour (4)"
    if [ $erreur == 1 ]
    then
        erreur=0
        echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
        echo "              Choix invalide. Veuillez réessayer."
    fi

    read choixMorse

    case $choixMorse in
        "1")     
            clear
            morseChiff
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

    if [ $erreur == 1 ]
    then
        erreur=0
        echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
        echo "              Choix invalide. Veuillez réessayer."
    fi

    read choixMorse

    case $choixMorse in
        "1")     
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