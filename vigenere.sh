#!/bin/bash

source tools.sh

#Partie du GOAT (Dylan)

cle=""
phrase=""
estFichierInput=0
estFichierOutput=0
fichierInput=""
fichierOutput=""
outputChoice="ajouter"
indexMenu=0
menu=()
selection="\033[34m"

#Création de la fonction vigenereMain pour les appels dans d'autres fonctions
vigenereMain() {
    echo "test"
}

actionInvalide() {
    clear
    echo ""
    echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
    echo "               Veuillez choisir une action valide"
    echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
    echo ""
    sleep 1.25
    clear
}

continuerYN() {
    local rep=""

    echo "---------------------------------------------------------------"
    echo "              Voulez-vous quitter le programme ?"
    echo "---------------------------------------------------------------"
    echo -e "                            ${menu[0]}Oui\033[0m"
    echo -e "                            ${menu[1]}Non\033[0m"

    read -rsn1 rep
    while ! [[ -z $rep ]]; do
        if [[ $rep == $'\x1b' ]]; then
            read -sn2 rep
            case "$rep" in
                '[A')
                    menu[$indexMenu]=" "
                    if [[ $indexMenu == 0 ]]; then
                        indexMenu=1
                    else
                        ((indexMenu--))
                    fi
                    menu[$indexMenu]=$selection
                    clear
                    echo "---------------------------------------------------------------"
                    echo "              Voulez-vous quitter le programme ?"
                    echo "---------------------------------------------------------------"
                    echo -e "                            ${menu[0]}Oui\033[0m"
                    echo -e "                            ${menu[1]}Non\033[0m"
                    ;;
                '[B')
                    menu[$indexMenu]=" "
                    if [[ $indexMenu == 1 ]]; then
                        indexMenu=0
                    else
                        ((indexMenu++))
                    fi
                    menu[$indexMenu]=$selection
                    clear
                    echo "---------------------------------------------------------------"
                    echo "              Voulez-vous quitter le programme ?"
                    echo "---------------------------------------------------------------"
                    echo -e "                            ${menu[0]}Oui\033[0m"
                    echo -e "                            ${menu[1]}Non\033[0m"
                    ;;
                *)
                    continue
                    ;;
            esac
        fi
        read -rsn1 rep
    done

    clear

    if [[ $indexMenu == 0 ]]; then
        quitter
    else
        vigenereMain
    fi
}

estFileInput() {
    local rep=""

    echo "---------------------------------------------------------------"
    echo "         Voulez-vous choisir un fichier en entrée ?"
    echo "---------------------------------------------------------------"
    echo -e "                            ${menu[0]}Oui\033[0m"
    echo -e "                            ${menu[1]}Non\033[0m"

    read -rsn1 rep
    while ! [[ -z $rep ]]; do
        if [[ $rep == $'\x1b' ]]; then
            read -sn2 rep
            case "$rep" in
                '[A')
                    menu[$indexMenu]=" "
                    if [[ $indexMenu == 0 ]]; then
                        indexMenu=1
                    else
                        ((indexMenu--))
                    fi
                    menu[$indexMenu]=$selection
                    clear
                    echo "---------------------------------------------------------------"
                    echo "         Voulez-vous choisir un fichier en entrée ?"
                    echo "---------------------------------------------------------------"
                    echo -e "                            ${menu[0]}Oui\033[0m"
                    echo -e "                            ${menu[1]}Non\033[0m"
                    ;;
                '[B')
                    menu[$indexMenu]=" "
                    if [[ $indexMenu == 1 ]]; then
                        indexMenu=0
                    else
                        ((indexMenu++))
                    fi
                    menu[$indexMenu]=$selection
                    clear
                    echo "---------------------------------------------------------------"
                    echo "         Voulez-vous choisir un fichier en entrée ?"
                    echo "---------------------------------------------------------------"
                    echo -e "                            ${menu[0]}Oui\033[0m"
                    echo -e "                            ${menu[1]}Non\033[0m"
                    ;;
                *)
                    continue
                    ;;
            esac
        fi
        read -rsn1 rep
    done

    clear

    if [[ $indexMenu == 0 ]]; then
        estFichierInput=1
    else
        estFichierInput=0
    fi
}

estFileOutput() {
    local rep=""

    echo "---------------------------------------------------------------"
    echo "         Voulez-vous choisir un fichier en sortie ?"
    echo "---------------------------------------------------------------"
    echo -e "                            ${menu[0]}Oui\033[0m"
    echo -e "                            ${menu[1]}Non\033[0m"

    read -rsn1 rep
    while ! [[ -z $rep ]]; do
        if [[ $rep == $'\x1b' ]]; then
            read -sn2 rep
            case "$rep" in
                '[A')
                    menu[$indexMenu]=" "
                    if [[ $indexMenu == 0 ]]; then
                        indexMenu=1
                    else
                        ((indexMenu--))
                    fi
                    menu[$indexMenu]=$selection
                    clear
                    echo "---------------------------------------------------------------"
                    echo "         Voulez-vous choisir un fichier en sortie ?"
                    echo "---------------------------------------------------------------"
                    echo -e "                            ${menu[0]}Oui\033[0m"
                    echo -e "                            ${menu[1]}Non\033[0m"
                    ;;
                '[B')
                    menu[$indexMenu]=" "
                    if [[ $indexMenu == 1 ]]; then
                        indexMenu=0
                    else
                        ((indexMenu++))
                    fi
                    menu[$indexMenu]=$selection
                    clear
                    echo "---------------------------------------------------------------"
                    echo "         Voulez-vous choisir un fichier en sortie ?"
                    echo "---------------------------------------------------------------"
                    echo -e "                            ${menu[0]}Oui\033[0m"
                    echo -e "                            ${menu[1]}Non\033[0m"
                    ;;
                *)
                    continue
                    ;;
            esac
        fi
        read -rsn1 rep
    done
    
    clear

    if [[ $indexMenu == 0 ]]; then
        estFichierOutput=1
    else
        estFichierOutput=0
    fi
}

choixFichierInput() {
    local rep=""

    printf "Veuillez choisir en entrée le nom ou chemin d\'un fichier: "
    read rep
    printf "\n"

    if ! [[ "${rep:0:2}" == "./" ]]; then
        rep="./$rep"
    fi

    if [[ -f "$rep" ]]; then
        fichierInput=$rep
        indexMenu=0
        menu=($selection " ")
        selectLigne
    else
        clear
        echo ""
        echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
        echo "                    Le fichier n\'existe pas"
        echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
        echo ""
        sleep 1
        clear
        choixFichierInput
    fi
}

choixFichierOutput() {
    local rep=""
    local choixCreation=""
    local choixOutput=""

    printf "Veuillez choisir en sortie le nom ou chemin (relatif) d\'un fichier: "
    read rep
    printf "\n"

    if ! [[ "${rep:0:2}" == "./" ]]; then
        rep="./$rep"
    fi

    if [[ -f "$rep" ]]; then
        fichierOutput="$rep"
        clear
        echo "--------------------------------------------------------------------------------"
        echo "  Voulez-vous écraser le fichier ou ajouter la chaine de caractères à la fin ?"
        echo "--------------------------------------------------------------------------------"
        echo -e "                                   ${menu[0]}Ecraser\033[0m"
        echo -e "                                   ${menu[1]}Ajouter\033[0m"

        read -rsn1 choixOutput
        while ! [[ -z $choixOutput ]]; do
            if [[ $choixOutput == $'\x1b' ]]; then
                read -sn2 choixOutput
                case "$choixOutput" in
                    '[A')
                        menu[$indexMenu]=" "
                        if [[ $indexMenu == 0 ]]; then
                            indexMenu=1
                        else
                            ((indexMenu--))
                        fi
                        menu[$indexMenu]=$selection
                        clear
                        echo "--------------------------------------------------------------------------------"
                        echo "  Voulez-vous écraser le fichier ou ajouter la chaine de caractères à la fin ?"
                        echo "--------------------------------------------------------------------------------"
                        echo -e "                                   ${menu[0]}Ecraser\033[0m"
                        echo -e "                                   ${menu[1]}Ajouter\033[0m"
                        ;;
                    '[B')
                        menu[$indexMenu]=" "
                        if [[ $indexMenu == 1 ]]; then
                            indexMenu=0
                        else
                            ((indexMenu++))
                        fi
                        menu[$indexMenu]=$selection
                        clear
                        echo "--------------------------------------------------------------------------------"
                        echo "  Voulez-vous écraser le fichier ou ajouter la chaine de caractères à la fin ?"
                        echo "--------------------------------------------------------------------------------"
                        echo -e "                                   ${menu[0]}Ecraser\033[0m"
                        echo -e "                                   ${menu[1]}Ajouter\033[0m"
                        ;;
                    *)
                        continue
                        ;;
                esac
            fi
            read -rsn1 choixOutput
        done

        clear

        if [[ $indexMenu == 0 ]]; then
            outputChoice="ecraser"
        fi

    else
        clear
        echo ""
        echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
        echo "                    Le fichier n\'existe pas"
        echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
        echo ""
        sleep 1
        clear
        
        echo "---------------------------------------------------------------"
        echo "                     Voulez-vous le créer ?"
        echo "---------------------------------------------------------------"
        echo -e "                             ${menu[0]}Oui\033[0m"
        echo -e "                             ${menu[1]}Non\033[0m"

        read -rsn1 choixCreation
        while ! [[ -z $choixCreation ]]; do
            if [[ $choixCreation == $'\x1b' ]]; then
                read -sn2 choixCreation
                case "$choixCreation" in
                    '[A')
                        menu[$indexMenu]=" "
                        if [[ $indexMenu == 0 ]]; then
                            indexMenu=1
                        else
                            ((indexMenu--))
                        fi
                        menu[$indexMenu]=$selection
                        clear
                        echo "---------------------------------------------------------------"
                        echo "                     Voulez-vous le créer ?"
                        echo "---------------------------------------------------------------"
                        echo -e "                             ${menu[0]}Oui\033[0m"
                        echo -e "                             ${menu[1]}Non\033[0m"
                        ;;
                    '[B')
                        menu[$indexMenu]=" "
                        if [[ $indexMenu == 1 ]]; then
                            indexMenu=0
                        else
                            ((indexMenu++))
                        fi
                        menu[$indexMenu]=$selection
                        clear
                        echo "---------------------------------------------------------------"
                        echo "                     Voulez-vous le créer ?"
                        echo "---------------------------------------------------------------"
                        echo -e "                             ${menu[0]}Oui\033[0m"
                        echo -e "                             ${menu[1]}Non\033[0m"
                        ;;
                    *)
                        continue
                        ;;
                esac
            fi
            read -rsn1 choixCreation
        done

        clear

        if [[ $indexMenu == 0 ]]; then
            fichierOutput=$rep
            touch $fichierOutput
        else
            indexMenu=0
            menu=($selection " ")
            choixFichierOutput
        fi
    fi
}

selectLigne() {
    local ind=0
    local phrs=""
    local choixPhrase=""
    local nbLignes=$(printf "%d" "$(grep -oP '^[0-9]+' <<< "$(wc -l $fichierInput)")")
    ((nbLignes++))

    echo "------------------------------------------------------------------------------" 
    echo "  Voulez-vous chiffrer/déchiffrer le fichier en entier, ou juste une ligne ?"
    echo "------------------------------------------------------------------------------"
    echo -e "                             ${menu[0]}Le fichier en entier\033[0m"
    echo -e "                             ${menu[1]}Juste une ligne\033[0m"

    read -rsn1 choixPhrase
    while ! [[ -z $choixPhrase ]]; do
        if [[ $choixPhrase == $'\x1b' ]]; then
            read -sn2 choixPhrase
            case "$choixPhrase" in
                '[A')
                    menu[$indexMenu]=" "
                    if [[ $indexMenu == 0 ]]; then
                        indexMenu=1
                    else
                        ((indexMenu--))
                    fi
                    menu[$indexMenu]=$selection
                    clear
                    echo "------------------------------------------------------------------------------" 
                    echo "  Voulez-vous chiffrer/déchiffrer le fichier en entier, ou juste une ligne ?"
                    echo "------------------------------------------------------------------------------"
                    echo -e "                             ${menu[0]}Le fichier en entier\033[0m"
                    echo -e "                             ${menu[1]}Juste une ligne\033[0m"
                    ;;
                '[B')
                    menu[$indexMenu]=" "
                    if [[ $indexMenu == 1 ]]; then
                        indexMenu=0
                    else
                        ((indexMenu++))
                    fi
                    menu[$indexMenu]=$selection
                    clear
                    echo "------------------------------------------------------------------------------" 
                    echo "  Voulez-vous chiffrer/déchiffrer le fichier en entier, ou juste une ligne ?"
                    echo "------------------------------------------------------------------------------"
                    echo -e "                             ${menu[0]}Le fichier en entier\033[0m"
                    echo -e "                             ${menu[1]}Juste une ligne\033[0m"
                    ;;
                *)
                    continue
                    ;;
            esac
        fi
        read -rsn1 choixPhrase
    done

    clear

    if [[ $indexMenu == 0 ]]; then
        phrs="$(cat $fichierInput)"
    else
        printf "Veuillez choisir la ligne que vous voulez chiffrer/déchiffrer (de 1 à $nbLignes): "
        read ind
        printf "\n"
        while (($ind > $nbLignes || $ind < 1)); do
            actionInvalide
            printf "Veuillez choisir la ligne que vous voulez chiffrer/déchiffrer (de 1 à $nbLignes): "
            read ind
            printf "\n"
        done

        for ((i = 0; i < $ind; i++)); do
            read -r phrs
        done < "$fichierInput"
    fi

    phrase=$phrs
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
        printf "\n"
    done

    cle=$choix
}

choixPhrase() {
    local phrs=""
    
    printf "Veuillez écrire une phrase: "
    read phrs
    printf "\n"

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
    local len_key=${#key}       #taille de key
    local len_sentence=${#sentence}     #taille de sentence

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
            char=$((  $(printf '%d' "'$char") + $(printf '%d' "'$chara") - $(printf '%d' "'a")*2 ))
            ((char%=26))
            ((char+=$(printf '%d' "'a")))
            res+=$(printf "\\$(printf '%03o' "$char" )")       #Ajout du caractère crypté dans le résultat
            ((ind++))

        elif [[ "$char" =~ [A-Z] ]]; then
            char=$((  $(printf '%d' "'$char") + $(printf '%d' "'$chara") - $(printf '%d' "'a") - $(printf '%d' "'A") ))
            ((char%=26))
            ((char+=$(printf '%d' "'A")))
            res+=$(printf "\\$(printf '%03o' "$char" )")       #Ajout du caractère crypté dans le résultat
            ((ind++))
            
        elif [[ "$char" =~ [0-9] ]]; then
            res+=$((($char+$ind)%10))       #Ajout du chiffre crypté
            ((ind++))

        else
            res+="$char"        #Ajout des caractères non cryptables
        fi
    done

    if [[ $estFichierOutput == 1 ]]; then      #Vérifie si le type de output
        if [[ "$outputChoice" == "ajouter" ]]; then     #Vérifie si le choix d'output dans un fichier
            echo -e "$res" >> "$fichierOutput"      #Ajout de la phrase à la fin du fichier
        else
            echo -e "$res" > "$fichierOutput"       #Ecrasement du fichier puis ajout de la phrase
        fi
    else
        echo "Voici la phrase chiffrée: $res"     #Affichage de la phrase cryptée
    fi
}

dechiffrementVigenere() {
    #Initialisation de toutes les variables
    local key="$1"
    local sentence="$2"
    local ind=0
    local res=""
    local chara=""
    local char=""
    local len_key=${#key}       #taille de key
    local len_sentence=${#sentence}     #taille de sentence
    local resAscii=0
    local nb=0

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
            resAscii=$((  $(printf '%d' "'$char") - $(printf '%d' "'$chara")  ))
            while ((resAscii < 0)); do
                ((resAscii+=26))
            done
            ((resAscii+=$(printf '%d' "'a")))
            res+=$(printf "\\$(printf '%03o' "$resAscii")")       #Ajout du caractère décrypté dans le résultat
            ((ind++))
        elif [[ "$char" =~ [A-Z] ]]; then
            resAscii=$(( ( ($(printf '%d' "'$char") - $(printf '%d' "'A")) - ($(printf '%d' "'$chara") - $(printf '%d' "'A")) ) ))
            while ((resAscii < 0)); do
                ((resAscii+=26))
            done
            ((resAscii+=$(printf '%d' "'A")))
            res+=$(printf "\\$(printf '%03o' $resAscii)")      #Ajout du caractère crypté dans le résultat
            ((ind++))
        elif [[ "$char" =~ [0-9] ]]; then
            ((nb=$char-$(printf '%d' "'$chara")+$(printf '%d' "'a")))
            while ((nb < 0)); do
                ((nb+=10))
            done
            res+=$nb       #Ajout du chiffre décrypté
            ((ind++))
        else
            res+="$char"        #Ajout des caractères non décryptables
        fi
    done

    if [[ $estFichierOutput == 1 ]]; then      #Vérifie si le type de output
        if [[ "$outputChoice" == "ajouter" ]]; then     #Vérifie si le choix d'output dans un fichier
            echo -e "$res" >> "$fichierOutput"      #Ajout de la phrase à la fin du fichier
        else
            echo -e "$res" > "$fichierOutput"       #Ecrasement du fichier puis ajout de la phrase
        fi
    else
        echo "Voici la phrase déchiffrée: $res"     #Affichage de la phrase décryptée
    fi
}

chiffrerVigenere() {
    echo "---------------------------------------------------------------"
    echo "                  Veuillez choisir une action"
    echo "---------------------------------------------------------------"
    echo -e "                    ${menu[0]}Choisir une clé\033[0m"
    echo -e "                    ${menu[1]}Utiliser une clé générée\033[0m"
    echo -e "                    ${menu[2]}Retour\033[0m"
    echo -e "                    ${menu[3]}Quitter\033[0m"
    local actionChif=""

    read -rsn1 actionChif
    while ! [[ -z $actionChif ]]; do
        if [[ $actionChif == $'\x1b' ]]; then
            read -sn2 actionChif
            case "$actionChif" in
                '[A')
                    menu[$indexMenu]=" "
                    if [[ $indexMenu == 0 ]]; then
                        indexMenu=3
                    else
                        ((indexMenu--))
                    fi
                    menu[$indexMenu]=$selection
                    clear
                    echo "---------------------------------------------------------------"
                    echo "                  Veuillez choisir une action"
                    echo "---------------------------------------------------------------"
                    echo -e "                    ${menu[0]}Choisir une clé\033[0m"
                    echo -e "                    ${menu[1]}Utiliser une clé générée\033[0m"
                    echo -e "                    ${menu[2]}Retour\033[0m"
                    echo -e "                    ${menu[3]}Quitter\033[0m"
                    ;;
                '[B')
                    menu[$indexMenu]=" "
                    if [[ $indexMenu == 3 ]]; then
                        indexMenu=0
                    else
                        ((indexMenu++))
                    fi
                    menu[$indexMenu]=$selection
                    clear
                    echo "---------------------------------------------------------------"
                    echo "                  Veuillez choisir une action"
                    echo "---------------------------------------------------------------"
                    echo -e "                    ${menu[0]}Choisir une clé\033[0m"
                    echo -e "                    ${menu[1]}Utiliser une clé générée\033[0m"
                    echo -e "                    ${menu[2]}Retour\033[0m"
                    echo -e "                    ${menu[3]}Quitter\033[0m"
                    ;;
                *)
                    continue
                    ;;
            esac
        fi
        read -rsn1 actionChif
    done

    clear

    case $indexMenu in
        "0")
            choixCle
            clear
            indexMenu=0
            menu=($selection " ")
            estFileInput
            clear
            indexMenu=0
            menu=($selection " ")
            estFileOutput
            clear
            if [[ $estFichierInput == 0 ]]; then
                choixPhrase
                clear
            else
                choixFichierInput
                clear
            fi
            if [[ $estFichierOutput == 1 ]]; then
                indexMenu=0
                menu=($selection " ")
                choixFichierOutput
            fi
            echo "Voici la clé: $cle"
            chiffrementVigenere "$cle" "$phrase"
            printf "\n"
            indexMenu=0
            menu=($selection " ")
            continuerYN
            ;;
        "1")
            echo ""
            genCle
            clear
            indexMenu=0
            menu=($selection " ")
            estFileInput
            clear
            indexMenu=0
            menu=($selection " ")
            estFileOutput
            clear
            if [[ $estFichierInput == 0 ]]; then
                choixPhrase
                clear
            else
                choixFichierInput
                clear
            fi
            if [[ $estFichierOutput == 1 ]]; then
                indexMenu=0
                menu=($selection " ")
                choixFichierOutput
            fi
            echo "Voici la clé: $cle"
            chiffrementVigenere "$cle" "$phrase"
            printf "\n"
            indexMenu=0
            menu=($selection " ")
            continuerYN
            ;;
        "2")
            vigenereMain
            ;;
        "3")
            quitter
            ;;  
        *)
            actionInvalide
            indexMenu=0
            menu=($selection " " " " " ")
            chiffrerVigenere
            ;;
    esac
}

dechiffrerVigenere() {
    echo "---------------------------------------------------------------"
    echo "                   Veuillez choisir une action"
    echo "---------------------------------------------------------------"
    echo -e "                         ${menu[0]}Choisir une clé\033[0m"
    echo -e "                         ${menu[1]}Retour\033[0m"
    echo -e "                         ${menu[2]}Quitter\033[0m"

    local actionDechif=""

    read -rsn1 actionDechif
    while ! [[ -z $actionDechif ]]; do
        if [[ $actionDechif == $'\x1b' ]]; then
            read -sn2 actionDechif
            case "$actionDechif" in
                '[A')
                    menu[$indexMenu]=" "
                    if [[ $indexMenu == 0 ]]; then
                        indexMenu=2
                    else
                        ((indexMenu--))
                    fi
                    menu[$indexMenu]=$selection
                    clear
                    echo "---------------------------------------------------------------"
                    echo "                   Veuillez choisir une action"
                    echo "---------------------------------------------------------------"
                    echo -e "                         ${menu[0]}Choisir une clé\033[0m"
                    echo -e "                         ${menu[1]}Retour\033[0m"
                    echo -e "                         ${menu[2]}Quitter\033[0m"
                    ;;
                '[B')
                    menu[$indexMenu]=" "
                    if [[ $indexMenu == 2 ]]; then
                        indexMenu=0
                    else
                        ((indexMenu++))
                    fi
                    menu[$indexMenu]=$selection
                    clear
                    echo "---------------------------------------------------------------"
                    echo "                   Veuillez choisir une action"
                    echo "---------------------------------------------------------------"
                    echo -e "                         ${menu[0]}Choisir une clé\033[0m"
                    echo -e "                         ${menu[1]}Retour\033[0m"
                    echo -e "                         ${menu[2]}Quitter\033[0m"
                    ;;
                *)
                    continue
                    ;;
            esac
        fi
        read -rsn1 actionDechif
    done

    clear

    case $indexMenu in
        "0")
            choixCle
            clear
            indexMenu=0
            menu=($selection " ")
            estFileInput
            clear
            indexMenu=0
            menu=($selection " ")
            estFileOutput
            clear
            if [[ $estFichierInput == 0 ]]; then
                choixPhrase
                clear
            else
                choixFichierInput
                clear
            fi
            if [[ $estFichierOutput == 1 ]]; then
                indexMenu=0
                menu=($selection " ")
                choixFichierOutput
            fi
            echo "Voici la clé: $cle"
            dechiffrementVigenere "$cle" "$phrase"
            printf "\n"

            indexMenu=0
            menu=($selection " ")
            continuerYN
            ;;
        "1")
            vigenereMain
            ;;
        "2")
            quitter
            ;;  
        *)
            actionInvalide
            indexMenu=0
            menu=($selection " " " ")
            dechiffrerVigenere
            ;;
    esac
}

vigenereMain_() {
    echo "---------------------------------------------------------------"
    echo "                  Veuillez choisir une action"
    echo "---------------------------------------------------------------"
    echo -e "                        ${menu[0]}Chiffrer\033[0m"
    echo -e "                        ${menu[1]}Dechiffrer\033[0m"
    echo -e "                        ${menu[2]}Retour\033[0m"
    echo -e "                        ${menu[3]}Quitter\033[0m"

    

    local choixVigenere=""
    cle=""
    read -rsn1 choixVigenere
    while ! [[ -z $choixVigenere ]]; do
        if [[ $choixVigenere == $'\x1b' ]]; then
            read -sn2 choixVigenere
            case "$choixVigenere" in
                '[A')
                    menu[$indexMenu]=" "
                    if [[ $indexMenu == 0 ]]; then
                        indexMenu=3
                    else
                        ((indexMenu--))
                    fi
                    menu[$indexMenu]=$selection
                    clear
                    echo "---------------------------------------------------------------"
                    echo "                  Veuillez choisir une action"
                    echo "---------------------------------------------------------------"
                    echo -e "                        ${menu[0]}Chiffrer\033[0m"
                    echo -e "                        ${menu[1]}Dechiffrer\033[0m"
                    echo -e "                        ${menu[2]}Retour\033[0m"
                    echo -e "                        ${menu[3]}Quitter\033[0m"
                    ;;
                '[B')
                    menu[$indexMenu]=" "
                    if [[ $indexMenu == 3 ]]; then
                        indexMenu=0
                    else
                        ((indexMenu++))
                    fi
                    menu[$indexMenu]=$selection
                    clear
                    echo "---------------------------------------------------------------"
                    echo "                Veuillez choisir une action"
                    echo "---------------------------------------------------------------"
                    echo -e "                        ${menu[0]}Chiffrer\033[0m"
                    echo -e "                        ${menu[1]}Dechiffrer\033[0m"
                    echo -e "                        ${menu[2]}Retour\033[0m"
                    echo -e "                        ${menu[3]}Quitter\033[0m"
                    ;;
                *)
                    continue
                    ;;
            esac
        fi
        read -rsn1 choixVigenere
    done

    clear

    case "$indexMenu" in
        "0")
            indexMenu=0
            menu=($selection " " " " " ")
            chiffrerVigenere
            ;;
        "1")
            indexMenu=0
            menu=($selection " " " " " ")
            dechiffrerVigenere
            ;;
        "2")
            indexMenu=0
            main
            ;;
        "3")
            indexMenu=0
            quitter
            ;;
    esac
}

vigenereMain() {
    clear
    cle=""
    phrase=""
    estFichierInput=0
    estFichierOutput=0
    fichierInput=""
    fichierOutput=""
    outputChoice="ajouter"
    indexMenu=0
    menu=($selection " " " " " ")
    vigenereMain_
}

vigenereMain