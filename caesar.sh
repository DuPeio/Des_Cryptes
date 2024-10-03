#!/bin/bash

#Pierre MAGIEU
# Partie Peio : Code Ceasar
# Menu 
caesarMain() {
    clear
    # choix du menu principal Caesar
    choixTabMain=("                            Coder" "                           Décoder" "               Choisir un autre mode de codage" "                      Quitter le programme")
    choixIndiceMain=0
    affichageMain
    # Menu principal Caesar interractif 
    while [ "$touche" != "" ]; do #La touche entrée permet de sortir de la boucle et de valider le choix

        if [ $touche = $'\x1b' ]; then 
            read -sn2 touche
            case $touche in
            # Fleche du haut
                "[A")
                    clear
                    choixIndiceMain=$[choixIndiceMain-1]
                    if [ $choixIndiceMain -lt 0 ]; then #Permet de faire boucler le menu interractif
                        choixIndiceMain=3
                    fi
                    affichageMain
                    ;;
            # Fleche du bas
                "[B")
                    clear
                    choixIndiceMain=$[choixIndiceMain+1]
                    if [ $choixIndiceMain -gt 3 ]; then #Permet de faire boucler le menu interractif
                        choixIndiceMain=0
                    fi
                    affichageMain
                    ;;
                "*")
                    affichageMain
                    ;;
            esac
        fi
    done

    message=""

    case $choixIndiceMain in
        "0")
            clear
            echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
            echo "           Vous avez choisi de coder vos données            "
            echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
            # Lancement menu prncipal du codage Caesar
            caesarChif
            ;;
        "1")
            clear
            echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
            echo "           Vous avez choisi de décoder vos données             "
            echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
            # Lancement menu prncipal du décodage Caesar
            caesarDechif
            ;;
        "2")
            # Retour au menu des différents types de codage
            clear
            main
            ;;
        "3")
            # Quitte le programme avec un exit 0    
            quitter
            ;;
        *)
            message="+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\n                Choix invalide. Veuillez réessayer.\n+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\n"
            # On boucle si il y une réponse qui n'est pas prévue
            caesarMain
    esac
}

cleCaesarChif=1 #Elle est en globale sinon elle se réinitialise à chaque fois qu'on lance caesarChif

# Chiffrment choix
caesarChif(){
    # choix du menu principal codage Caesar
    choixTabChif=("            Coder le contenu d'un fichier externe" "                     Coder une phrase" "     Changer la clé de codage, elle est égale à $cleCaesarChif" "                   Retour au menu Caesar")
    choixIndiceChif=0
    
    affichageChif
    # Menu principal codage Caesar interractif 
    while [ "$touche" != "" ]; do
        if [ $touche = $'\x1b' ]; then
            read -sn2 touche
            case $touche in
            # Flèche du haut
                "[A")
                    clear
                    choixIndiceChif=$[choixIndiceChif-1]
                    if [ $choixIndiceChif -lt 0 ]; then 
                        choixIndiceChif=3
                    fi
                    affichageChif
                    ;;
            # Flèche du bas
                "[B")
                    clear
                    choixIndiceChif=$[choixIndiceChif+1]
                    if [ $choixIndiceChif -gt 3 ]; then 
                        choixIndiceChif=0
                    fi
                    affichageChif
                    ;;
                "*")
                    affichageChif
                    ;;
            esac
        fi
    done

    # Réinitialise le message pour ne rien afficher
    message=""
    case $choixIndiceChif in
        "0")
            # Coder un fichier
            clear   
            echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
            echo "  Vous avez choisi de coder le contenu d'un fichier externe"
            echo "           Entrez le chemin de votre fichier..."
            echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"

            read caesarCheminChif
            #Vérification que le fichier existe bien
            if [ ! -e "$caesarCheminChif" ] || [ ! -f "$caesarCheminChif" ]; then
                clear
                message="+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\n                   Chemin incorrect...\n+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\n"
                caesarChif
            fi
            
            # Choix du codage Caesar pour un fichier
            choixTabChifLig=("                           Tout" "                  Choisissez les lignes" "                          Retour")
            choixIndiceChifLig=0

            affichageChifLig
            # Menu interractif du codage Caesar pour un fichier
            while [ "$touche" != "" ];do
                if [ $touche = $'\x1b' ]; then
                    read -sn2 touche
                    case $touche in
                    # Flèche du haut
                        "[A")
                            clear
                            choixIndiceChifLig=$[choixIndiceChifLig-1]
                            if [ $choixIndiceChifLig -lt 0 ]; then 
                                choixIndiceChifLig=2
                            fi
                            affichageChifLig
                            ;;
                    # Flèche du bas
                        "[B")
                            clear
                            choixIndiceChifLig=$[choixIndiceChifLig+1]
                            if [ $choixIndiceChifLig -gt 2 ]; then 
                                choixIndiceChifLig=0
                            fi
                            affichageChifLig
                            ;;
                        "*")
                            affichageChifLig
                            ;;
                    esac
                fi
            done

             # Réinitialise le message pour ne rien afficher
            message=""
            case $choixIndiceChifLig in
                "0")

                    clear
                    echo "       Un fichier contenant votre texte codé va être créer"
                    echo "_______________________________________________________________"
                    message="              Fichier codé avec succès"
                    codeDecodeFichierCaesar "$caesarCheminChif" #Créer le fichier avec le contenu codé
                    ;;

                "1")
                    clear
                    nbLignes=$(wc -l < "$caesarCheminChif") # On récupère le nombre de ligne que contient le fichier
                    echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
                    echo "        Quelles lignes du fichier voulez-vous coder ?" 
                    echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"

                    # Il faut voir si les lignes sont valides 
                    echo "        Quelle est le numéro de la première ligne ?"

                    
                    read choixLignesCaesar1
                    if [ $choixLignesCaesar1 -gt $nbLignes ]; then
                        message="+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\n                   Choix incorrect...\n+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\n"
                        caesarChif
                    fi

                    echo "        Quelle est le numéro de la dernière ligne ?"
                    read choixLignesCaesar2
                    if [ $choixLignesCaesar2 -gt $nbLignes ]; then
                        message="+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\n                   Choix incorrect...\n+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\n"
                        caesarChif
                    fi

                    echo "_______________________________________________________________"
                    echo "                       Codage en cours..."
                    echo "_______________________________________________________________"
                    message="                 Fichier codé avec succès"
                    #Créer le fichier avec le lignes choisis codées
                    lignesFichierCaesar "$choixLignesCaesar1" "$choixLignesCaesar2" "$caesarCheminChif"
                    ;;

                "2")
                    clear
                    message="~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n                 Retour au menu de codage....\n~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n"
                    # Retour au menu de codage Caesar
                    caesarChif
                    ;;

                *)
                    message="+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\n                Choix invalide. Veuillez réessayer.\n+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\n"
                    caesarChif
                    ;;

            esac
            ;;
        
        "1")     
        # Codage d'une phrase
            clear
            echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
            echo "          Vous avez choisi de coder une phrase"
            echo "       Entrez la phrase que vous souhaitez coder..."
            echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"

            read phraseCaesar #Récupération de l'input de l'utilisateur
            	
            echo "_______________________________________________________________"
            echo "                  Voici votre phrase codée"
            codeDecodeCaesar "$phraseCaesar"  #Codage de l'input
            caesarChif  #Rappel de la fonction pour retourner au menu de codage
            ;;
        
        "2")
        # Choisir une clé de codage
            clear
            echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
            echo "                Choisissez une clé de codage"
            echo "                       Aléatoire (0)"
            echo "              Autre, entrez la valeur de la clé"
            echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"

            read choixCleCaesarChiff

            if [ "$choixCleCaesarChiff" == "0" ]; then
                cleCaesarChif=$(aleatoire) #Aleatoirement grâce à la fonction aleatoire()
            else
                cleCaesarChif=$choixCleCaesarChiff #On récupère l'input de l'utilisateur
            fi
            caesarChif
            ;;

        "3")
            message="~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n                     Retour au menu Caesar...\n~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n"
            caesarMain
            ;;

        *) 
            clear
            message="+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\n                Choix invalide. Veuillez réessayer.\n+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\n"
            caesarChif
            ;;

    esac
}

# Dechiffrement choix
caesarDechif(){
    # choix du menu principal décodage Caesar
    choixTabDechif=("                Le contenu d'un fichier externe" "                         Une phrase" "                   Retour au menu Caesar")
    choixIndiceDechif=0
    
    affichageDechif
     # Menu principal décodage Caesar interractif 
    while [ "$touche" != "" ]; do
        if [ $touche = $'\x1b' ]; then
            read -sn2 touche
            case $touche in
            # Flèche du haut
                "[A")
                    clear
                    choixIndiceDechif=$[choixIndiceDechif-1]
                    if [ $choixIndiceDechif -lt 0 ]; then 
                        choixIndiceDechif=2
                    fi
                    affichageDechif
                    ;;
                # Flèche du bas
                "[B")
                    clear
                    choixIndiceDechif=$[choixIndiceDechif+1]
                    if [ $choixIndiceDechif -gt 2 ]; then 
                        choixIndiceDechif=0
                    fi
                    affichageDechif
                    ;;
                "*")
                    affichageDechif
                    ;;
            esac
        fi
    done
 # Réinitialise le message pour ne rien afficher
    message=""
    case $choixIndiceDechif in
        "0")
        # Décoder un fichier
            clear     
            echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
            echo "  Vous avez choisi de décoder le contenu d'un fichier externe"
            echo "             Entrez le chemin de votre fichier..."
            echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"

            read caesarCheminDechif
            #Vérification que le fichier existe bien
            if [ ! -e "$caesarCheminDechif" ] || [ ! -f "$caesarCheminDechif" ]; then
                clear
                message="+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\n                   Chemin incorrect...\n+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\n"
                caesarDechif
            fi
            
             # Choix du codage Caesar pour un fichier
            choixTabDechifLig=("                           Tout" "                  Choisissez les lignes" "                          Retour")
            choixIndiceDechifLig=0

            affichageDechifLig
            # Menu interractif du décodage Caesar pour un fichier
            while [ "$touche" != "" ]; do
                if [ $touche = $'\x1b' ]; then
                    read -sn2 touche
                    case $touche in
                        "[A")
                        # Flèche du haut
                            clear
                            choixIndiceDechifLig=$[choixIndiceDechifLig-1]
                            if [ $choixIndiceDechifLig -lt 0 ]; then 
                                choixIndiceDechifLig=2
                            fi
                            affichageDechifLig
                            ;;
                        # Flèche du bas
                        "[B")
                            clear
                            choixIndiceDechifLig=$[choixIndiceDechifLig+1]
                            if [ $choixIndiceDechifLig -gt 2 ]; then 
                                choixIndiceDechifLig=0
                            fi
                            affichageDechifLig
                            ;;
                        "*")
                            affichageDechifLig
                            ;;
                    esac
                fi
            done
             # Réinitialise le message pour ne rien afficher
            message=""
            clear
            case $choixIndiceDechifLig in
                "0")     
                    echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
                    echo "       Entrez la clé pour décoder le texte du fichier"
                    read cleCaesarDechif
                    echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"

                    echo "     Un fichier contenant votre texte decodé va être créé     "
                    echo "_______________________________________________________________"
                    message="                Fichier décodé avec succès"
                    codeDecodeFichierCaesar "$caesarCheminDechif" "$cleCaesarDechif" #Créer le fichier avec le contenu décodé grâce à la clé
                    
                    ;;

                "1")
                    nbLignes=$(wc -l < "$caesarCheminDechif") # Oc récupère le nombre de ligne que contient le fichier
                    echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
                   
                    echo "      Quelles lignes du fichier voulez-vous décoder ?"
                    
                    # Il faut voir si les lignes sont valides 
                    echo "        Quelle est le numéro de la première ligne ?"

                    
                    read choixLignesCaesar1
                    if [ $choixLignesCaesar1 -gt $nbLignes ]; then
                        message="+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\n                   Choix incorrect...\n+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\n"
                        caesarDechif
                    fi

                    echo "        Quelle est le numéro de la dernière ligne ?"
                    read choixLignesCaesar2
                    if [ $choixLignesCaesar2 -gt $nbLignes ]; then
                        message="+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\n                   Choix incorrect...\n+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\n"
                        caesarDechif
                    fi
                     # Doit choisir la clé de déchiffrement
                    echo "          Entrez la clé pour décoder cette phrase"
                    echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
                    read cleCaesarDechif 
                    
                    echo "_______________________________________________________________"
                    message="              Fichier décodé avec succès"
                    #Créer le fichier avec le lignes choisis décodées avec la clé
                    lignesFichierCaesar "$choixLignesCaesar1" "$choixLignesCaesar2" "$caesarCheminDechif" "$cleCaesarDechif"
                    ;;

                "2")
                    message="~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n                   Retour au menu de décodage...\n~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n"
                     # Retour au menu de décodage Caesar
                    caesarDechif
                    ;;

                *)
                    clear
                    message="+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\n                Choix invalide. Veuillez réessayer.\n+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\n"
                    caesarDechif
                    ;;

            esac
            ;;
        
        "1")
        # Décodage d'une phrase
            clear
            echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
            echo "           Vous avez choisi de décoder une phrase"
            echo "         Entrez la phrase que vous souhaitez décoder.."
            echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
            read phraseCaesar  #Récupération de l'input de l'utilisateur
            echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"            
            echo "           Entrez la clé pour décoder cette phrase"
            echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"


            read cleCaesarDechif
            echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
            
            echo "_______________________________________________________________"
            echo "                Voici votre phrase décodée"
            codeDecodeCaesar "$phraseCaesar" "$cleCaesarDechif" #décodage de l'input avec la clé
            caesarDechif #Retour au menu de décodage
            ;;
        
        "2")
            clear
            message="~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n                     Retour au menu Caesar...\n~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n"
            caesarMain
            ;;
        
        *)
            clear
            message="+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\n                Choix invalide. Veuillez réessayer.\n+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\n"
            caesarDechif
            ;;

    esac
}


codeDecodeFichierCaesar(){ #Fonction qui permet de coder et décoder un fichier
    chemin="$1" #On récupère le fichier à décoder/coder
    cle="$2" #On récupère la clé pour décoder
    if [ $cle ];then # Si le cle n'est pas vide
        fichier=$(creerFichierCaesar "$chemin" "false") # On décode
    else
        fichier=$(creerFichierCaesar "$chemin" "true") # On code
    fi

    cat "$chemin" | while read -r ligne || [[ -n "$ligne" ]]; do #Ligne par ligne 
        if [ $cle ];then
        
            ligneC=$(codeDecodeCaesar "$ligne" "$cle")
        
        else
            ligneC=$(codeDecodeCaesar "$ligne" )
        fi
        echo -e "$ligneC" >> "$fichier" #On ecrit le résultat dans l'output
    done
    
    # On relance la boucle du menu du codage ou du décodage en fonction de la clé
    if [ $cle ];then 
        caesarDechif
    else
        caesarChif
    fi
}

codeDecodeCaesar(){ #Fonction qui permet de coder et décoder
    chaine="$1" #On récupère le fichier à décoder/coder
    cleCaesarDechif="$2" #On récupère la clé pour décoder
	res="" #Initialisation du résultat
	
	for ((i=0; i<${#chaine}; i++)); do #Boucle dans le mot...
	
		lettre=${chaine:$i:1} #...Pour récupérer lettre par lettre
		
		asciiLettre=$(printf "%d" "'$lettre") #Récupération du code ascii de la lettre 
		
		#Lettres majuscules
		if [ $asciiLettre -ge 65 ] && [ $asciiLettre -le 90 ]; then
            if [ -z $cleCaesarDechif ];then # Si clé est vide, on code 
                asciiLettre=$[asciiLettre+cleCaesarChif] # Addition du code ascii de la lettre et de la clé de codage
                while [ $asciiLettre -gt 90 ]; do
                    asciiLettre=$[asciiLettre-26] #Au cas où ça dépasse, on fait -26 pour boucler grâce au nombre de lettre de l'alphabet
                done
            else #On décode 
                asciiLettre=$[asciiLettre-cleCaesarDechif] # Soustraction du code ascii de la lettre et de la clé de décodage
                while [ $asciiLettre -lt 65 ]; do
                    asciiLettre=$[asciiLettre+26] #Au cas où ça dépasse, on fait +26 pour boucler grâce au nombre de lettre de l'alphabet
                done
            fi

		#Lettres minuscules
		elif [ $asciiLettre -ge 97 ] && [ $asciiLettre -le 122 ]; then
            if [ -z $cleCaesarDechif ];then
                asciiLettre=$[asciiLettre+cleCaesarChif]
                while [ $asciiLettre -gt 122 ]; do
                    asciiLettre=$[asciiLettre-26]
                done
            else
                asciiLettre=$[asciiLettre-cleCaesarDechif]
                while [ $asciiLettre -lt 97 ]; do
                    asciiLettre=$[asciiLettre+26] 
                done
            fi

		#Chiffres
		elif [ $asciiLettre -ge 48 ] && [ $asciiLettre -le 57 ]; then
            if [ -z $cleCaesarDechif ];then
                asciiLettre=$[asciiLettre+cleCaesarChif]
                while [ $asciiLettre -gt 57 ]; do
                    asciiLettre=$[asciiLettre-10] 
                done
            else
                asciiLettre=$[asciiLettre-cleCaesarDechif]
                while [ $asciiLettre -lt 48 ]; do
                    asciiLettre=$[asciiLettre+10] 
                done
            fi
			
		fi
        lettre=$(printf "\\$(printf '%03o' $asciiLettre)") # récupération de la lettre qui correspond au code ascii
		res+=$lettre
	done
	echo "$res"
}



lignesFichierCaesar(){
    ligne1="$1" #Récupération de la premiere ligne à coder/décoder
    ligne2="$2" #Récupération de la dernière ligne à coder/décoder
    chemin="$3" #Fichier à coder/décoder
    cle="$4" #Récupération de la clé de décodage
    
    if [ -z $cle ];then  #Si la clé ne contient pas de valeur
        fichier=$(creerFichierCaesar "$chemin" "true") #On créer l'output de codage
    else
        fichier=$(creerFichierCaesar "$chemin" "false") #On créer l'output de décodage
    fi
    

    sed -n "${ligne1},${ligne2}p" "$chemin" | while read -r ligne  #On regarde ligne par ligne et on récupère la ligne
    do
        if [ -z $cle ];then
            ligneC=$(codeDecodeCaesar "$ligne") #On la code
        else
            ligneC=$(codeDecodeCaesar "$ligne" "$cle") #On la décode
        fi
        echo -e "$ligneC" >> "$fichier" #On l'envoie dans le fichier output
    done

    if [ -z $cle ];then
        caesarChif
    else
        caesarDechif
    fi
}


creerFichierCaesar(){ #Permet de créer le fichier output 
    chemin="$1" #Chemin de l'input
    chif="$2" #Variable pour savoir si on veut un output ou le texte sera codé ou décodé
    nomFichier=$(basename "$chemin") #Récupération du nom du fichier seul
    dossierFichier=$(dirname "$chemin") #Récupération du chemin du dossier contenant l'input 

    nomSansExt="${nomFichier%.*}" #On enlève les extensions 
    extension="${nomFichier##*.}" #on le recupère dans cette variable

    if [ "$chif" = "true" ];then #Si on veut coder

        #Création du fichier en ajoutant Coder
        if [ "$nomFichier" != "$extension" ]; then #Si il n'y a pas d'extension au fichier
            fichierChif="${dossierFichier}/${nomSansExt}Coder.${extension}"
        else #Si il y en a une
            fichierChif="${dossierFichier}/${nomSansExt}Coder"
        fi
        touch "$fichierChif" #Création du fichier
        chmod 777 "$fichierChif"
        echo "---------------------|Nouveau Codage|---------------------" >> "$fichierChif"
        echo "$fichierChif"
    else 

        #Création du fichier en ajoutant Dhiffrer
        if [ "$nomFichier" != "$extension" ]; then
            fichierDechif="${dossierFichier}/${nomSansExt}Decoder.${extension}"
        else
            fichierDechif="${dossierFichier}/${nomSansExt}Decoder"
        fi
        touch "$fichierDechif"
        chmod 777 "$fichierDechif"
        echo "---------------------|Nouveau Décodage|---------------------" >> "$fichierDechif"
        echo "$fichierDechif"
    fi
}


# Gérer les affichages des menus

affichageMain(){
        echo -e "$message"
        choixMain="${choixTabMain[choixIndiceMain]}" #Element encours de selection 
        echo "---------------------------------------------------------------"
        echo -e "\033[1;33m                     Que voulez vous faire ?\033[0m" #Message principal avec de la couleur
        echo "---------------------------------------------------------------"
        for elmt in "${choixTabMain[@]}"; do #Affichage des choix
            if [ "$choixMain" = "$elmt" ]; then
                echo -e "\033[1;35m$elmt  <\033[0m" # En ajoutant de la couleur et une flèche sur l'élément sélectionné
            else
                echo "$elmt"
            fi
        done
        read -sn1 touche # On relance la boucle d'coute des touches
    }


affichageChif(){
    echo -e "$message"
    choixChif="${choixTabChif[choixIndiceChif]}" #Element encours de selection 
    echo "---------------------------------------------------------------"
    echo -e "\033[1;33m                   Que souhaitez-vous faire ?\033[0m" #Message principal avec de la couleur
    echo "---------------------------------------------------------------"
    for elmt in "${choixTabChif[@]}"; do #Affichage des choix
        if [ "$choixChif" = "$elmt" ]; then
            echo -e "\033[1;35m$elmt  <\033[0m" # En ajoutant de la couleur et une flèche sur l'élément sélectionné
        else
            echo "$elmt"
        fi
    done
    read -sn1 touche # On relance la boucle d'coute des touches
}

affichageChifLig(){
    clear
    choixChifLig="${choixTabChifLig[choixIndiceChifLig]}" #Element encours de selection 
    echo "---------------------------------------------------------------"
    echo -e "\033[1;33m  Voulez vous coder tout le fichier ou juste quelques lignes ?  \033[0m" #Message principal avec de la couleur
    echo "---------------------------------------------------------------"
    for elmt in "${choixTabChifLig[@]}"; do #Affichage des choix
        if [ "$choixChifLig" = "$elmt" ]; then
            echo -e "\033[1;35m$elmt  <\033[0m" # En ajoutant de la couleur et une flèche sur l'élément sélectionné
        else
            echo "$elmt"
        fi
    done
    read -sn1 touche # On relance la boucle d'coute des touches
}


affichageDechif(){
    echo -e "$message"
    choixDechif="${choixTabDechif[choixIndiceDechif]}" #Element encours de selection 
    echo "---------------------------------------------------------------"
    echo -e "\033[1;33m                 Que souhaitez-vous décoder ?\033[0m" #Message principal avec de la couleur
    echo "---------------------------------------------------------------"
    for elmt in "${choixTabDechif[@]}"; do #Affichage des choix
        if [ "$choixDechif" = "$elmt" ]; then
            echo -e "\033[1;35m$elmt  <\033[0m" # En ajoutant de la couleur et une flèche sur l'élément sélectionné
        else
            echo "$elmt"
        fi
    done
    read -sn1 touche # On relance la boucle d'coute des touches
}

affichageDechifLig(){
    clear
    choixDechifLig="${choixTabDechifLig[choixIndiceDechifLig]}" #Element encours de selection 
    echo "---------------------------------------------------------------"
    echo -e "\033[1;33m Voulez vous décoder tout le fichier ou juste quelques lignes ?\033[0m" #Message principal avec de la couleur
    echo "---------------------------------------------------------------"
    for elmt in "${choixTabDechifLig[@]}"; do #Affichage des choix
        if [ "$choixDechifLig" = "$elmt" ]; then
            echo -e "\033[1;35m$elmt  <\033[0m" # En ajoutant de la couleur et une flèche sur l'élément sélectionné
        else
            echo "$elmt"
        fi
    done
    read -sn1 touche # On relance la boucle d'ecoute des touches
}