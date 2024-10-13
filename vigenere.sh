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

    printf "Voulez-vous quitter le programme ? (y/n) "
    read rep
    printf "\n"

    clear

    if [[ $rep =~ [Yy] ]]; then
        quitter
    elif [[ $rep =~ [Nn] ]]; then
        vigenereMain
    else
        actionInvalide
        continuerYN
    fi
}

estFileInput() {
    local rep=""

    printf "Voulez-vous choisir un fichier en entrée ? (y/n) "
    read rep
    printf "\n"

    clear

    if [[ "$rep" =~ [Yy] ]]; then
        estFichierInput=1
    elif [[ "$rep" =~ [Nn] ]]; then
        estFichierInput=0
    else
        actionInvalide
        estFileInput
    fi
}

estFileOutput() {
    local rep=""

    printf "Voulez-vous choisir un fichier en sortie ? (y/n) "
    read rep
    printf "\n"

    clear

    if [[ "$rep" =~ [Yy] ]]; then
        estFichierOutput=1
    elif [[ "$rep" =~ [Nn] ]]; then
        estFichierOutput=0
    else
        actionInvalide
        estFileOutput
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
        printf "Voulez-vous écraser le fichier (1) ou ajouter la chaine de caractères à la fin (2) ?  "
        read choixOutput
        printf "\n"
        while ! [[ $choixOutput =~ [12] ]]; do
            actionInvalide
            printf "Voulez-vous ajouter la chaine de caractères à la fin (1) ou écraser le fichier (2) ?  "
            read choixOutput
            printf "\n"
        done
        clear
        if [[ $choixOutput == 2 ]]; then
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

        printf "Voulez-vous le créer ? (y/n) "
        read choixCreation
        printf "\n"
        clear

        while ! [[ $choixCreation =~ [yYnN] ]]; do
            actionInvalide
            printf "Voulez-vous le créer ? (y/n) "
            read choixCreation
            printf "\n"
        done

        if [[ $choixCreation =~ [yY] ]]; then
            fichierOutput=$rep
            touch $fichierOutput
        else
            choixFichierOutput
        fi
    fi
}

selectLigne() {
    local ind=0
    local phrs=""
    local choixPhrase=0
    local nbLignes=$(printf "%d" "$(grep -oP '^[0-9]+' <<< "$(wc -l $fichierInput)")")
    ((nbLignes++))

    printf "Voulez-vous chiffrer/déchiffrer le fichier en entier (1), ou juste une ligne (2) ?  "
    read choixPhrase
    printf "\n"
    while ! [[ $choixPhrase =~ [12] ]]; do
        actionInvalide
        printf "Voulez-vous chiffrer/déchiffrer le fichier en entier (1), ou juste une ligne (2) ?  "
        read choixPhrase
        printf "\n"
    done

    if [[ $choixPhrase == 1 ]]; then
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
    echo "+-------------------------------------------------------------+"
    echo "|                Veuillez choisir une action                  |"
    echo "+-------------------------------------------------------------+"
    echo "|                    Choisir une clé (1)                      |"
    echo "|                Utiliser une clé générée (2)                 |"
    echo "|                        Retour (3)                           |"
    echo "•                       Quitter  (4)                          •"

    echo ""
    local actionChif=""
    read actionChif
    clear

    case $actionChif in
        "1")
            choixCle
            clear
            if [[ $estFichierInput == 0 ]]; then
                choixPhrase
                clear
            else
                choixFichierInput
                clear
            fi
            estFileInput
            clear
            estFileOutput
            clear
            echo "Voici la clé: $cle"
            chiffrementVigenere "$cle" "$phrase"
            printf "\n"
            continuerYN
            ;;
        "2")
            echo ""
            genCle
            clear

            if [[ $estFichierInput == 0 ]]; then
                choixPhrase
                clear
            else
                choixFichierInput
                clear
            fi
            estFileInput
            clear
            estFileOutput
            clear
            echo "Voici la clé: $cle"
            chiffrementVigenere "$cle" "$phrase"
            printf "\n"
            continuerYN
            ;;
        "3")
            vigenereMain
            ;;
        "4")
            quitter
            ;;  
        *)
            actionInvalide
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

    local actionDechif=""
    read actionDechif
    clear

    case $actionDechif in
        "1")
            choixCle
            clear
            if [[ $estFichierInput == 0 ]]; then
                choixPhrase
                clear
            else
                choixFichierInput
                clear
            fi
            estFileInput
            clear
            estFileOutput
            clear
            echo "Voici la clé: $cle"
            dechiffrementVigenere "$cle" "$phrase"
            ;;
        "2")
            vigenereMain
            ;;
        "3")
            quitter
            ;;  
        *)
            actionInvalide
            dechiffrerVigenere
            ;;
    esac
}

vigenereMain_() {
    echo "+-------------------------------------------------------------+"
    echo "|                Veuillez choisir une action                  |"
    echo "+-------------------------------------------------------------+"
    echo "|                       Chiffrer (1)                          |"
    echo "|                      Dechiffrer (2)                         |"
    echo "|                        Retour (3)                           |"
    echo "•                       Quitter  (4)                          •"

    echo ""
    local choixVigenere=""
    cle=""
    read choixVigenere

    clear

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
            actionInvalide
            vigenereMain
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
    vigenereMain_
}