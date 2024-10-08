#!/bin/bash


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

    # if [[ $estFichierOutput ]]; then      #Vérifie si le type de output
    #     if [[ "$outputChoice" == "ajouter" ]]; then     #Vérifie si le choix d'output dans un fichier
    #         echo -e "$res" >> "$fichierOutput"      #Ajout de la phrase à la fin du fichier
    #     else
    #         echo -e "$res" > "$fichierOutput"       #Ecrasement du fichier puis ajout de la phrase
    #     fi
    # fi
    echo "$res"     #Affichage de la phrase crypté
}

chiffrementFichierVigenere() {
    # Fonction qui permet de transformer le contenu du fichier en premier Parametre, en morse dans le second fichier en parametre
    # NB : Ne teste absolument pas si les fichiers sont valides ici (pas son role)
    fichierEntree=$1 # Le chemin vers le fichier d'entrée
    fichierSortie=$2 # Le chemin vers le fichier de sortie

    cat "$fichierEntree" | while read -r ligne || [[ -n "$ligne" ]] # Lit le fichier fichier ligne par ligne + derniere ligne
    do
        ligneVigenere=$(chiffrementVigenere "$cle" "$ligne") # Convertit la ligne en version morse
        echo -e "$ligneVigenere" >> "$fichierSortie" # Ajoute la version morse dans le fichier de sortie
    done

}

erreur=0 # Variable globale pour les messages dans les menus
erreurFunc() { 
    # Fonction pour afficher des messages dans le menu
    if [ $1 == 1 ]
    then
        echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
        echo "              Choix invalide. Veuillez réessayer."
    elif [ $1 == 2 ]
    then
        echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
        echo "                $choixFichierVig n'existe pas..."
    elif [ $1 == 3 ]
    then
        echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
        echo "              FICHIER SAUVEGARDE AVEC SUCCES !"
    fi
    # erreur=0
}

titre=""
options=()
choixVigenere=0

affichageScreenVig(){
    clear
    choixVigenere=0
    taille=${#options[@]}
    # touche="   "

    affichage(){
        echo "---------------------------------------------------------------"
        echo "$titre"
        echo "---------------------------------------------------------------"
        for (( i=0; i<$taille; i++ ))
        do
            elmt=${options[$i]}  
            if [ $i -eq $choixVigenere ]; then
                echo -e "\033[33m$elmt  <\033[0m"
            else
                echo "$elmt"
            fi
        done
        erreurFunc $erreur
        read -sn1 touche
    }
    

    
    affichage
    erreurFunc $erreur

    while [ "$touche" != "" ]; do
        if [ $touche = $'\x1b' ]; then
            read -sn2 touche
            case $touche in
                "[A")
                    clear
                    choixVigenere=$((choixVigenere-1))
                    while [ "${options[$choixVigenere]}" == "" ]
                    do
                        choixVigenere=$((choixVigenere-1))
                        if [ $choixVigenere -lt 0 ]; then 
                            choixVigenere=$(($taille-1))
                        fi
                    done
                    if [ $choixVigenere -lt 0 ]; then 
                        choixVigenere=$(($taille-1))
                    fi
                    affichage
                    ;;
                "[B")
                    clear
                    choixVigenere=$((choixVigenere+1))
                    while [ "${options[$choixVigenere]}" == "" ]
                    do
                        choixVigenere=$((choixVigenere+1))
                        if [ $choixVigenere -gt $(($taille-1)) ]; then 
                            choixVigenere=0
                        fi
                    done
                    if [ $choixVigenere -gt $(($taille-1)) ]; then 
                        choixVigenere=0
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
    erreur=0

}

choixFichierSortieVigVig="" # Variable globale pour le choix du fichier de sortie
choixFichierVig="" # Variable globale pour le choix du fichier d'entrée
vigenereFile() {
    # Fonction qui demande à l'utilisateur un fichier d'entrée et un fichier de sortie
    clear
    echo "---------------------------------------------------------------"
    echo "                     CHOIX DU FICHIER"
    echo "---------------------------------------------------------------"
    echo -ne " VOTRE CHOIX : "
    
    read choixFichierVig # Lit le choix de l'utilisateur
    echo ""
    if [ -f "$choixFichierVig" ] # Si le chemin correspond à un fichier d'entrée
    then
        fichierOK=0 # Variable qui indique si le fichier de sortie a été choisi
        while [ $fichierOK == 0 ] # Tant qu'il n'a pas été choisi
        do
            echo -ne " NOM DU FICHIER DE SORTIE : "
            read choixFichierSortieVig # On lit le chemin
            echo ""
            if [ -f "$choixFichierSortieVig" ] # Si le fichier existe déjà
            then
                echo -ne " CE FICHIER EXISTE DEJA, VOULEZ-VOUS LE SUPPRIMER ? (Y/N) : "
                read supprimer # On demande s'il faut le remplacer
                echo ""
                if [[ "$supprimer" == "Y" ]]
                then
                    rm -f "$choixFichierSortieVig" # On le supprime            # NB : -f pour ne pas demander de confirmation
                    fichierOK=1 # On indique que le fichier a été choisi
                fi
            elif [[ "$choixFichierSortieVig" =~ [\/] ]] # On teste si le nom ne contient pas de caracteres interdits
            then
                echo "NOM DE FICHIER INCORRECT. CARACTERES INTERDITS."
            elif [ ${#choixFichierSortieVig} -gt 255 ] # On teste si le nom n'est pas trop long
            then
                echo "TAILLE DU NOM DE FICHIER TROP GRANDE."
            elif [ ${#choixFichierSortieVig} -lt 2 ] # si le nom n'est pas trop petit
            then
                echo "TAILLE DU NOM DE FICHIER TROP PETITE."
            else
                fichierOK=1 # Sinon on indique qu'il est valide
            fi
        done
        touch "$choixFichierSortieVig" # Le fichier est créé


    else
        erreur=2 # Sinon on indique que le fichier d'entrée est introuvable
        return 2 # Valeur de sortie pour : Le fichier n'existe pas 
    fi
    return 0 # Valeur de sortie pour : tout est ok
}


vigenereMain(){

    options=("                        Chiffrer" "                       Dechiffrer" "                        Retour" "                        Quitter")
    titre="                Veuillez choisir une action"
    affichageScreenVig

    case $choixVigenere in
        "0")     
            clear
            chiffrerVigenere
            return 0 
            ;;
        "1")
            clear
            morseMenu 1 # Lance un second sous menu en version déchiffrer
            return 0
            ;;
        "2")
            clear # Ferme le menu
            ;;
        "3")
            quitter
            ;;
        *)
            erreur=1 # Met erreur à 1 = choix incorrect
            vigenereMain # relance le menu
    esac
}

vigenereChiffrementInput() {
    # Fonction qui lance le chiffrement ou déchiffrement selon l'option depuis l'input console

    clear
    echo "---------------------------------------------------------------"
    echo "                 CHIFFREMENT VIGENERE INPUT"
    echo "                 POUR QUITTER FAITES /exit"
    echo "              POUR AFFICHER LA CLE FAITES /key"
    echo "---------------------------------------------------------------"
    exit=0
    while [ $exit -eq 0 ] # Tant que la condition de sortie n'est pas validée
    do
        read line # Lit la ligne dans la console
        case $line in
            "/exit")
                exit=1 # Si cette ligne est égale à "/exit" on met exit à 1 pour sortir de la boucle
                ;;
            "/key")
                echo "$cle"
                ;;
            *)
                chiffrementVigenere "$cle" "$line"
                ;;
        esac
    done
}

chiffrerVigenere() {

    options=("               Choisir une clé" "               Générer une clé aléatoire" "               Afficher la clé" "               Chiffrer un fichier" "               Via l'Input" "               Retour" "               Quitter")
    titre="                Veuillez choisir une action"
    affichageScreenVig

    case $choixVigenere in
        "0")
            choixCle
            clear
            echo "Voici la clé: $cle"
            # chiffrementVigenere "$cle" "$phrase"
            printf "\nAppuyez sur entree pour continuer...\n"
            read qdsdkqdhqs
            chiffrerVigenere
            return 0
            ;;
        "1")
            echo ""
            genCle
            clear
            echo "Voici la clé: $cle"
            printf "\nAppuyez sur entree pour continuer...\n"
            read qdsdkqdhqs
            chiffrerVigenere
            return 0
            ;;
        "2")
            echo ""
            echo "Voici la clé: $cle"
            printf "\nAppuyez sur entree pour continuer...\n"
            read qdsdkqdhqs
            chiffrerVigenere
            return 0
            ;;
        "3")
            vigenereFile
            if [ $? != 0 ] # Si tout ne s'est pas passé correctement
            then
                vigenereMain # on retourne au menu principal du morse
                return 0
            fi
            chiffrementFichierVigenere "$choixFichierVig" "$choixFichierSortieVig"
            erreur=3
            clear
            ;;
        "4")
            vigenereChiffrementInput
            ;;
        "5")
            vigenereMain
            ;;
        "6")
            quitter
            ;;  
        *)
            erreur=1
            chiffrerVigenere
            ;;
    esac
}