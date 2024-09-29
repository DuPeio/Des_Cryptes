#!/bin/bash

#Pierre MAGIEU
# Partie Peio : Code Ceasar
# Menu 
caesarMain() {
    clear
    # choix du menu principal Caesar
    choixTabMain=("                            Coder" "                           Décoder" "               Choisir un autre mode de codage" "                      Quitter le programme")
    choixIndiceMain=0
    choixMain="${choixTabMain[choixIndiceMain]}"

    affichageMain
    # Menu principal Caesar interractif 
    while [ "$touche" != "" ]; do #La touche entrée permet de sortir de la boucle et de valider le choix

        if [ $touche = $'\x1b' ]; then 
            read -sn2 touche
            case $touche in
            # Fleche du haut
                "[A")
                    clear
                    choixIndiceMain=$((choixIndiceMain-1))
                    if [ $choixIndiceMain -lt 0 ]; then #Permet de faire boucler le menu interractif
                        choixIndiceMain=3
                    fi
                    affichageMain
                    ;;
            # Fleche du bas
                "[B")
                    clear
                    choixIndiceMain=$((choixIndiceMain+1))
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
    choixChif="${choixTabChif[choixIndiceChif]}"
    
    affichageChif
    # Menu principal codage Caesar interractif 
    while [ "$touche" != "" ]; do
        if [ $touche = $'\x1b' ]; then
            read -sn2 touche
            case $touche in
            # Flèche du haut
                "[A")
                    clear
                    choixIndiceChif=$((choixIndiceChif-1))
                    if [ $choixIndiceChif -lt 0 ]; then 
                        choixIndiceChif=3
                    fi
                    affichageChif
                    ;;
            # Flèche du bas
                "[B")
                    clear
                    choixIndiceChif=$((choixIndiceChif+1))
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

            if [ ! -e "$caesarCheminChif" ] || [ ! -f "$caesarCheminChif" ]; then
                clear
                message="+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\n                   Chemin incorrect...\n+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\n"
                caesarChif
            fi
            
            # Choix du codage Caesar pour un fichier
            choixTabChifLig=("                           Tout" "                  Choisissez les lignes" "                          Retour")
            choixIndiceChifLig=0
            choixChifLig="${choixTabChifLig[choixIndiceChifLig]}"

            affichageChifLig
            # Menu interractif du codage Caesar pour un fichier
            while [ "$touche" != "" ];do
                if [ $touche = $'\x1b' ]; then
                    read -sn2 touche
                    case $touche in
                    # Flèche du haut
                        "[A")
                            clear
                            choixIndiceChifLig=$((choixIndiceChifLig-1))
                            if [ $choixIndiceChifLig -lt 0 ]; then 
                                choixIndiceChifLig=2
                            fi
                            affichageChifLig
                            ;;
                    # Flèche du bas
                        "[B")
                            clear
                            choixIndiceChifLig=$((choixIndiceChifLig+1))
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
                    nbLignes=$(wc -l < "$caesarCheminChif") # ON récupère le nombre de ligne que contient le fichier
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
            codeSimple "$phraseCaesar" #Codage de l'input
            
            
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
    choixTabDechif=("                Le contenu d'un fichier externe" "                         Une phrase" "                   Retour au menu Caesar")
    choixIndiceDechif=0
    choixDechif="${choixTabDechif[choixIndiceDechif]}"
    
    affichageDechif
    while [ "$touche" != "" ]; do
    

        if [ $touche = $'\x1b' ]; then
            read -sn2 touche
            case $touche in
                "[A")
                    clear
                    choixIndiceDechif=$((choixIndiceDechif-1))
                    if [ $choixIndiceDechif -lt 0 ]; then 
                        choixIndiceDechif=2
                    fi
                    affichageDechif
                    ;;
                "[B")
                    clear
                    choixIndiceDechif=$((choixIndiceDechif+1))
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


    message=""


    case $choixIndiceDechif in
        "0")
            clear     
            echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
            echo "  Vous avez choisi de décoder le contenu d'un fichier externe"
            echo "             Entrez le chemin de votre fichier..."
            echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"

            read caesarCheminDechif

            if [ ! -e "$caesarCheminDechif" ] || [ ! -f "$caesarCheminDechif" ]; then
                clear
                message="+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\n                   Chemin incorrect...\n+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\n"
                caesarDechif
            fi
            
            
            choixTabDechifLig=("                           Tout" "                  Choisissez les lignes" "                          Retour")
            choixIndiceDechifLig=0
            choixDechifLig="${choixTabDechifLig[choixIndiceDechifLig]}"

            affichageDechifLig
            while [ "$touche" != "" ]; do
                if [ $touche = $'\x1b' ]; then
                    read -sn2 touche
                    case $touche in
                        "[A")
                            clear
                            choixIndiceDechifLig=$((choixIndiceDechifLig-1))
                            if [ $choixIndiceDechifLig -lt 0 ]; then 
                                choixIndiceDechifLig=2
                            fi
                            affichageDechifLig
                            ;;
                        "[B")
                            clear
                            choixIndiceDechifLig=$((choixIndiceDechifLig+1))
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
                    codeDecodeFichierCaesar "$caesarCheminDechif" "$cleCaesarDechif"
                    
                    ;;

                "1")
                    nbLignes=$(wc -l < "$caesarCheminDechif")
                    echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
                    # Doit choisir la clé de déchiffrement
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

                    echo "          Entrez la clé pour décoder cette phrase"
                    echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
                    read cleCaesarDechif 
                    
                    echo "_______________________________________________________________"
                    message="              Fichier décodé avec succès"
                    lignesFichierCaesar "$choixLignesCaesar1" "$choixLignesCaesar2" "$caesarCheminDechif" "$cleCaesarDechif"
                    ;;

                "2")
                    message="~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n                   Retour au menu de décodage...\n~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n"
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
            clear
            echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
            echo "           Vous avez choisi de décoder une phrase"
            echo "         Entrez la phrase que vous souhaitez décoder.."
            echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
            read phraseCaesar
            echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"            
            echo "           Entrez la clé pour décoder cette phrase"
            echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"


            read cleCaesarDechif
            echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
            
            echo "_______________________________________________________________"
            echo "                Voici votre phrase décodée"
            decodeSimple "$phraseCaesar" "$cleCaesarDechif"
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

codeSimple(){  #Cette fonction me permet de coder puis de rappeler la fonction CaesarChif
    chaine="$1"   #On récupère l'argument à coder
    codeDecodeCaesar "$chaine"  #On applique la fonciton
    caesarChif  
}


decodeSimple(){
    chaine="$1"
    codeDecodeCaesar "$chaine" "$cleCaesarDechif"
    caesarDechif
}


codeDecodeFichierCaesar(){
    chemin="$1"
    cle="$2"
    if [ $cle ];then
        fichier=$(creerFichierCaesar "$chemin" "false")
    else
        fichier=$(creerFichierCaesar "$chemin" "true")   
    fi

    cat "$chemin" | while read -r ligne || [[ -n "$ligne" ]]; do
        if [ $cle ];then
        
            ligneC=$(codeDecodeCaesar "$ligne" "$cle")
        
        else
            ligneC=$(codeDecodeCaesar "$ligne" )
        fi
        echo -e "$ligneC" >> "$fichier"
    done
    
    
    if [ $cle ];then
        caesarDechif
    else
        caesarChif
    fi
}

codeDecodeCaesar(){
    chaine="$1"
    cleCaesarDechif="$2"
	res=""
	
	for ((i=0; i<${#chaine}; i++)); do
	
		lettre=${chaine:$i:1}
		#echo "$lettre"
		
		asciiLettre=$(printf "%d" "'$lettre") 
		
		#Lettres majuscules
		if [ $asciiLettre -ge 65 ] && [ $asciiLettre -le 90 ]; then
            if [ -z $cleCaesarDechif ];then
                asciiLettre=$((asciiLettre+cleCaesarChif)) #Pour additionner en bash, il faut utiliser (( ))
                while [ $asciiLettre -gt 90 ]; do
                    asciiLettre=$((asciiLettre-26)) #Au cas où ça dépasse, on fait -26 pour boucler 
                done
            else
                asciiLettre=$((asciiLettre-cleCaesarDechif)) 
                while [ $asciiLettre -lt 65 ]; do
                    asciiLettre=$((asciiLettre+26)) 
                done
            fi
			
			lettre=$(printf "\\$(printf '%03o' $asciiLettre)")
		
		#Lettres minuscules
		elif [ $asciiLettre -ge 97 ] && [ $asciiLettre -le 122 ]; then
            if [ -z $cleCaesarDechif ];then
                asciiLettre=$((asciiLettre+cleCaesarChif))
                while [ $asciiLettre -gt 122 ]; do
                    asciiLettre=$((asciiLettre-26)) #Au cas où ça dépasse, on fait -26 pour boucler 
                done
            else
                asciiLettre=$((asciiLettre-cleCaesarDechif))
                while [ $asciiLettre -lt 97 ]; do
                    asciiLettre=$((asciiLettre+26)) 
                done
            fi
			lettre=$(printf "\\$(printf '%03o' $asciiLettre)")
		
		#Chiffres
		elif [ $asciiLettre -ge 48 ] && [ $asciiLettre -le 57 ]; then
            if [ -z $cleCaesarDechif ];then
                asciiLettre=$((asciiLettre+cleCaesarChif))
                while [ $asciiLettre -gt 57 ]; do
                    asciiLettre=$((asciiLettre-10)) #Au cas où ça dépasse, on fait -10 pour boucler 
                done
            else
                asciiLettre=$((asciiLettre-cleCaesarDechif))
                while [ $asciiLettre -lt 48 ]; do
                    asciiLettre=$((asciiLettre+10)) 
                done
            fi
			lettre=$(printf "\\$(printf '%03o' $asciiLettre)")
		fi
		res+=$lettre
	done
	echo "$res"
}



lignesFichierCaesar(){
    ligne1="$1"
    ligne2="$2"
    chemin="$3"
    cle="$4"
    
    if [ -z $cle ];then
        fichier=$(creerFichierCaesar "$chemin" "true")
    else
        fichier=$(creerFichierCaesar "$chemin" "false")
    fi
    

    sed -n "${ligne1},${ligne2}p" "$chemin" | while read -r ligne
    do
        if [ -z $cle ];then
            ligneC=$(codeDecodeCaesar "$ligne")
        else
            ligneC=$(codeDecodeCaesar "$ligne" "$cle")
        fi
        echo -e "$ligneC" >> "$fichier"
    done

    if [ -z $cle ];then
        caesarChif
    else
        caesarDechif
    fi
}


creerFichierCaesar(){
    chemin="$1"
    chif="$2"
    nomFichier=$(basename "$chemin")
    dossierFichier=$(dirname "$chemin")

    nomSansExt="${nomFichier%.*}"
    extension="${nomFichier##*.}"

    if [ "$chif" = "true" ];then

        if [ "$nomFichier" != "$extension" ]; then
            fichierChif="${dossierFichier}/${nomSansExt}Chiffrer.${extension}"
        else
            fichierChif="${dossierFichier}/${nomSansExt}Chiffrer"
        fi
        touch "$fichierChif"
        chmod 777 "$fichierChif"
        echo "---------------------|Nouveau Codage|---------------------" >> "$fichierChif"
        echo "$fichierChif"
    else 

        if [ "$nomFichier" != "$extension" ]; then
            fichierDechif="${dossierFichier}/${nomSansExt}Dechiffrer.${extension}"
        else
            fichierDechif="${dossierFichier}/${nomSansExt}Dechiffrer"
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
        choixMain="${choixTabMain[choixIndiceMain]}"
        echo "---------------------------------------------------------------"
        echo -e "\033[1;33m                     Que voulez vous faire ?\033[0m"
        echo "---------------------------------------------------------------"
        for elmt in "${choixTabMain[@]}"; do
            if [ "$choixMain" = "$elmt" ]; then
                echo -e "\033[1;35m$elmt  <\033[0m"
            else
                echo "$elmt"
            fi
        done
        read -sn1 touche
    }


affichageChif(){
    echo -e "$message"
    choixChif="${choixTabChif[choixIndiceChif]}"
    echo "---------------------------------------------------------------"
    echo -e "\033[1;33m                   Que souhaitez-vous faire ?\033[0m"
    echo "---------------------------------------------------------------"
    for elmt in "${choixTabChif[@]}"; do
        if [ "$choixChif" = "$elmt" ]; then
            echo -e "\033[1;35m$elmt  <\033[0m"
        else
            echo "$elmt"
        fi
    done
    read -sn1 touche
}

affichageChifLig(){
    clear
    choixChifLig="${choixTabChifLig[choixIndiceChifLig]}"
    echo "---------------------------------------------------------------"
    echo -e "\033[1;33m  Voulez vous coder tout le fichier ou juste quelques lignes ?  \033[0m"
    echo "---------------------------------------------------------------"
    for elmt in "${choixTabChifLig[@]}"; do
        if [ "$choixChifLig" = "$elmt" ]; then
            echo -e "\033[1;35m$elmt  <\033[0m"
        else
            echo "$elmt"
        fi
    done
    read -sn1 touche
}


affichageDechif(){
    echo -e "$message"
    choixDechif="${choixTabDechif[choixIndiceDechif]}"
    echo "---------------------------------------------------------------"
    echo -e "\033[1;33m                 Que souhaitez-vous décoder ?\033[0m"
    echo "---------------------------------------------------------------"
    for elmt in "${choixTabDechif[@]}"; do
        if [ "$choixDechif" = "$elmt" ]; then
            echo -e "\033[1;35m$elmt  <\033[0m"
        else
            echo "$elmt"
        fi
    done
    read -sn1 touche
}

affichageDechifLig(){
    clear
    choixDechifLig="${choixTabDechifLig[choixIndiceDechifLig]}"
    echo "---------------------------------------------------------------"
    echo -e "\033[1;33m Voulez vous décoder tout le fichier ou juste quelques lignes ?\033[0m"
    echo "---------------------------------------------------------------"
    for elmt in "${choixTabDechifLig[@]}"; do
        if [ "$choixDechifLig" = "$elmt" ]; then
            echo -e "\033[1;35m$elmt  <\033[0m"
        else
            echo "$elmt"
        fi
    done
    read -sn1 touche
}