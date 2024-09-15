#!/bin/bash

declare -A code_morse # Lettre : morse

# Construction des Tables
while  read -r ligne
do
    # /"+."+|"+[_.]{1,6}"+/
    if [[ $ligne =~ \"([^\"]+)\"[[:space:]]*:[[:space:]]*\"([^\"]+)\" ]]
    then
        cle="${BASH_REMATCH[1]}" # Premier Groupe entre ()
        valeur="${BASH_REMATCH[2]}" # Deuxieme Groupe entre ()
        
        code_morse["$cle"]="$valeur"
    fi
done < 'morse.json'


erreurFunc() {
    if [ $1 == 1 ]
    then
        echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
        echo "              Choix invalide. Veuillez réessayer."
    elif [ $1 == 2 ]
    then
        echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
        echo "                $choixFichier n'existe pas..."
    elif [ $1 == 3 ]
    then
        echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
        echo "              FICHIER SAUVEGARDE AVEC SUCCES !"
    fi
}
codeMorse() {
    nbErreurs=0
    string=$1
    # string=$(echo "$string" | grep -o "[A-Za-z0-9 ><\u002E\u002C\u0021\u003F\u003B\u003A\u0027\u0022\u0028\u0029\u002D\u00E0\u00F9\u003D\u002B\u0024\u0026\u00E9\u00E7\u002E\u002C\u0021\u003F\u003B\u003A\u0027\u0022\u0028\u0029\u005F\u00E8\u00F9\u0023\u007B\u007D\u005B\u007C\u0060\u005E\u0040\u007E\u20AC]")
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
            ((nbErreurs++))
            if [[ "${string:$i:1}" == "*" ]]
            then
                res="$res \*"
            # elif [[ "${string:$i:1}" =~ [A-Za-z0-9\u002E\u002C\u0021\u003F\u003B\u003A\u0027\u0022\u0028\u0029\u002D\u00E0\u00F9\u003D\u002B\u0024\u0026\u00E9\u00E7\u002E\u002C\u0021\u003F\u003B\u003A\u0027\u0022\u0028\u0029\u005F\u00E8\u00F9\u0023\u007B\u007D\u005B\u007C\u0060\u005E\u0040\u007E\u20AC] ]]
            # then
            else
                res="$res ${string:$i:1}"
            fi
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
            noise="$noise \a\a\a "
        fi
    done
    # echo -ne "$noise"
    echo -e "$res"
    # echo ""
}

decodeMorse() {
    nbErreurs=0
    string=$1
    arr=(${string//" "/ }) # Split par des espaces
    res=""
    for val in "${arr[@]}";
    do
        trouve=0
        txt=""
        for cle in "${!code_morse[@]}"
        do
            if [[ "${code_morse[$cle]}" == $val ]]
            then
                trouve=1
                txt=$cle
                break
            fi
        done
        if [ $trouve -eq 1 ]
        then
            res="$res$txt"
        else
            ((nbErreurs++))
            if [[ $val == "\*" ]]
            then
                res="$res*"
            else
                res="$res$val"
            fi
        fi
    done
    echo -e "$res"
    # echo ""
}


decodeMorseRecursiveStart() {
    string="$1"
    arr=(${string//" "/ })
    res=""

    decodeMorseRecursive 0 ${#arr[@]} "$res" "${arr[@]}"
}

decodeMorseRecursive() {
    index=$1
    size=$2
    res=$3
    arr=("${@:4}")  # Note à moi même : $4 ne marche pas, faut recuperer tous les éléments à partir du 4eme

    if [[ $index -ge $size ]]
    then
        echo -e "$res"
        return 0
    fi

    val="${arr[$index]}"
    trouve=0
    txt=""
    
    for cle in "${!code_morse[@]}"
    do
        if [[ "${code_morse[$cle]}" == "$val" ]]
        then
            trouve=1
            txt=$cle
            break
        fi
    done
    
    if [ $trouve -eq 1 ]
    then
        res="$res$txt"
    else
        if [[ $val == "*" ]]
        then
            res="$res*"
        else
            res="$res$val"
        fi
    fi
    decodeMorseRecursive $((index + 1)) $size "$res" "${arr[@]}"
}


chiffrementFichierMorse() {
    fichierEntree=$1
    fichierSortie=$2

    cat "$fichierEntree" | while read -r ligne || [[ -n "$ligne" ]]
    do
        ligneMorse=$(codeMorse "$ligne")
        echo -e "$ligneMorse" >> "$fichierSortie"
    done

}
dechiffrementFichierMorse() {
    fichierEntree=$1
    fichierSortie=$2

    cat "$fichierEntree" | while read -r ligneMorse || [[ -n "$ligneMorse" ]]
    do
        ligne=$(decodeMorse "$ligneMorse")
        echo -e "$ligne" >> "$fichierSortie"
    done

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
            morseMenu 0
            return 0
            ;;
        "2")
            morseMenu 1
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

morseInput() {
    clear

    opt=$1  # 0 = Chiffrement, #1 = Dechiffrement

    echo "---------------------------------------------------------------"
    if [ $opt == 0 ]
    then
        echo "                  CHIFFREMENT MORSE INPUT"
    else
        echo "                  DECHIFFREMENT MORSE INPUT"
    fi
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
                if [ $opt == 0 ]
                then
                    codeMorse "$line"
                else
                    decodeMorseRecursiveStart "$line"
                fi
                ;;
        esac
    done
    # morseChiff
}

choixFichierSortie=""
choixFichier=""
morseFile() {
    clear
    echo "---------------------------------------------------------------"
    echo "                     CHOIX DU FICHIER"
    echo "---------------------------------------------------------------"
    echo -ne " VOTRE CHOIX : "

    

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
            elif [ ${#choixFichierSortie} -gt 255 ]
            then
                echo "TAILLE DU NOM DE FICHIER TROP GRANDE."
            elif [ ${#choixFichierSortie} -lt 2 ]
            then
                echo "TAILLE DU NOM DE FICHIER TROP PETITE."
            else
                fichierOK=1
            fi
        done
        touch "$choixFichierSortie"


    else
        erreur=2
        return 2
    fi
    return 0
}


morseMenu() {
    clear

    opt=$1 # 0 Chiffrement, 1 Dechiffrement

    echo "---------------------------------------------------------------"
    if [ $opt -eq 0 ]
    then
        echo "                    CHIFFREMENT MORSE"
    else
        echo "                   DECHIFFREMENT MORSE"
    fi
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
            morseFile
            if [ $? != 0 ]
            then
                morseMain
                return 0
            fi

            if [ $opt == 0 ] 
            then
                echo "CHIFFREMENT EN COURS, VEUILLEZ PATIENTER ..."
                chiffrementFichierMorse "$choixFichier" "$choixFichierSortie"
            else
                echo "DECHIFFREMENT EN COURS, VEUILLEZ PATIENTER ..."
                dechiffrementFichierMorse "$choixFichier" "$choixFichierSortie"
            fi
            erreur=3    
            clear
            ;;
        "2")
            # clear
            morseInput $opt
            ;;
        "4")
            clear
            ;;
        *)
            erreur=1
            morseMenu
            return 0
    esac
    morseMain
}