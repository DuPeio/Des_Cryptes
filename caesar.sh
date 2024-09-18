#!/bin/bash

message=""

# Partie Peio : Code Ceasar
# Menu 
caesarMain() {
    clear
    echo -e "$message"
    echo "---------------------------------------------------------------"
    echo "                   Que voulez vous faire ?"
    echo "---------------------------------------------------------------"
    echo "                        Chiffrer (1)"
    echo "                       Dechiffrer (2)"
    echo "           Choisir un autre mode de chiffrement (3)"
    echo "                  Quitter le programme (4)"

    read choixCaesar
    message=""

    case $choixCaesar in
        "1")
            clear
            echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
            echo "         Vous avez choisi le chiffrement de données            "
            echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
            caesarChif
            ;;
        "2")
            clear
            echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
            echo "         Vous avez choisi le déchiffrement de données          "
            echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
            caesarDechif
            ;;
        "3")
            clear
            message="~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n                 Retour au menu principal...\n~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n"
            main
            ;;
        "4")
            quitter
            ;;
        *)
            message="+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\n                Choix invalide. Veuillez réessayer.\n+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\n"
            caesarMain
    esac
    # echo $choixCaesar //Pour test
}

cleCaesarChif=1 #Elle est en globale sinon elle se réinitialise à chaque fois que je lance caesarChif

# Chiffrment choix
caesarChif(){
    echo -e "$message"
    echo "---------------------------------------------------------------"
    echo "                 Que souhaitez-vous faire ?"
    echo "---------------------------------------------------------------"
    echo "         Chiffrer le contenu d'un fichier externe (1)"
    echo "                  Chiffrer une phrase (2)"
    echo "     Changer la clé de chiffrement, elle est égale à $cleCaesarChif (3)"
    echo "                 Retour au menu Caesar (4)"

    message=""

    read choixCaesarChif


    case $choixCaesarChif in
        "1")
            clear   
            echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
            echo " Vous avez choisi de chiffrer le contenu d'un fichier externe"
            echo "           Entrez le chemin de votre fichier..."
            echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"

            read caesarCheminChif

            if [ ! -e "$caesarCheminChif" ] || [ ! -f "$caesarCheminChif" ]; then
                clear
                message="+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\n                   Chemin incorrect...\n+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\n"
                caesarChif
            fi
            
	        echo "---------------------------------------------------------------"
            echo "Voulez vous chiffrer tout le fichier ou juste quelques lignes ?"
            echo "---------------------------------------------------------------"
            echo "                           Tout (1)"
            echo "                 Choisissez les lignes (2)"
            echo "                           Retour (3)"

            read caesarChoixLignes

            case $caesarChoixLignes in
                "1")
                    clear
                    echo "   Un fichier contenant votre text chiffré va être créer"
                    echo "_______________________________________________________________"
                    echo "            Chiffrement du fichier en cours..."
                    echo "_______________________________________________________________"
                    message="              Fichier chiffrer avec succès"
                    chiffrementFichierCaesar "$caesarCheminChif"
                    
                    ;;

                "2")
                    clear
                    nbLignes=$(wc -l "$caesarCheminChif" | awk '{print $1}') #Le awk sert a récupérer seulement le chiffre sinon ya le nom du fichier aussi
                    echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
                    echo "      Quelles lignes du fichier voulez-vous chiffrer ?" 
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
                    echo "                  Chiffrement en cours..."
                    echo "_______________________________________________________________"
                    message="              Fichier chiffrer avec succès"
                    chiffrementLignesFichierCaesar "$choixLignesCaesar1" "$choixLignesCaesar2" "$caesarCheminChif"
                    ;;

                "3")
                    message="~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n                 Retour au menu de chiffrement....\n~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n"
                    caesarChif
                    ;;

                *)
                    message="+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\n                Choix invalide. Veuillez réessayer.\n+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\n"
                    caesarChif
                    ;;

            esac
            ;;
        
        "2")     
            clear
            echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
            echo "         Vous avez choisi de chiffrer une phrase"
            echo "       Entrez la phrase que vous souhaitez chiffrer..."
            echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"

            read phraseCaesar
            	
            echo "_______________________________________________________________"
            echo "                   Chiffrement en cours"
            chiffrementCasearSimple "$phraseCaesar"
            echo "_______________________________________________________________"
            
            
            ;;
        
        "3")
            clear
            echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
            echo "              Choisissez une clé de chiffrement"
            echo "                       Aléatoire (0)"
            echo "              Autre, entrez la valeur de la clé"
            echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"

            read choixCleCaesarChiff

            if [ "$choixCleCaesarChiff" == "0" ]; then
                cleCaesarChif=$(aleatoire)
            else
                cleCaesarChif=$choixCleCaesarChiff
            fi
            caesarChif
            ;;

        "4")
            message="~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n                 Retour au menu Caesar...\n~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n"
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
    clear
    echo -e "$message"
    echo "---------------------------------------------------------------"
    echo "               Que souhaitez-vous déchiffrer ?"
    echo "---------------------------------------------------------------"
    echo "             Le contenu d'un fichier externe (1)"
    echo "                       Une phrase (2)"
    echo "                         Retour (3)" 

    message=""

    read choixCaesarDechif

    case $choixCaesarDechif in
        "1")     
            echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
            echo "Vous avez choisi de déchiffrer le contenu d'un fichier externe"
            echo "           Entrez le chemin de votre fichier..."
            echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"

            read caesarCheminDechif

            if [ ! -e "$caesarCheminDechif" ] || [ ! -f "$caesarCheminDechif" ]; then
                clear
                message="+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\n                   Chemin incorrect...\n+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\n"
                caesarDechif
            fi
            
	        echo "-----------------------------------------------------------------"
            echo "Voulez vous déchiffrer tout le fichier ou juste quelques lignes ?"
            echo "-----------------------------------------------------------------"
            echo "                          Tout (1)"
            echo "                  Choisissez les lignes (2)"
            echo "                         Retour (3)"

            read caesarChoixLignes

            case $caesarChoixLignes in
                "1")     
                    echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
                    echo "      Entrez la clé pour déchiffrer le texte du fichier"
                    read cleCaesarDechif
                    echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"

                    echo "    Un fichier contenant votre text dechiffré va être créer"
                    echo "_______________________________________________________________"
                    echo "            Déchiffrement du fichier en cours"
                    echo "_______________________________________________________________"
                    message="              Fichier déchiffrer avec succès"
                    dechiffrementFichierCaesar "$caesarCheminDechif" "$cleCaesarDechif"
                    
                    ;;

                "2")
                    nbLignes=$(wc -l "$caesarCheminDechif" | awk '{print $1}')
                    echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
                    # Doit choisir la clé de déchiffrement
                    echo "      Quelles lignes du fichier voulez-vous déchiffrer ?"
                    
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

                    echo "          Entrez la clé pour déchiffrer cette phrase"
                    echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
                    read cleCaesarDechif 
                    
                    echo "_______________________________________________________________"
                    echo "                  Déchiffrement en cours..."
                    echo "_______________________________________________________________"
                    message="              Fichier déchiffrer avec succès"
                    # Puis traduire 
                    dechiffrementLignesFichierCaesar "$choixLignesCaesar1" "$choixLignesCaesar2" "$caesarCheminDechif" "$cleCaesarDechif"
                    ;;

                "3")
                    message="~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n                 Retour au menu de déchiffrement...\n~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n"
                    caesarDechif
                    ;;

                *)
                    clear
                    message="+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\n                Choix invalide. Veuillez réessayer.\n+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\n"
                    caesarDechif
                    ;;

            esac
            ;;
        
        "2")
            echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
            echo "         Vous avez choisi de déchiffrer une phrase"
            echo "       Entrez la phrase que vous souhaitez déchiffrer..."
            read phraseCaesar

            echo "         Entrez la clé pour déchiffrer cette phrase"

            read cleCaesarDechif
            echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
            
            echo "_______________________________________________________________"
            echo "                 Déchiffrement en cours..."
            dechiffrementCasearSimple "$phraseCaesar" "$cleCaesarDechif"
            echo "_______________________________________________________________"
            
            ;;
        
        "3")
            message="~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n                 Retour au menu Caesar...\n~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n"
            caesarMain
            ;;
        
        *)
            clear
            message="+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\n                Choix invalide. Veuillez réessayer.\n+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\n"
            caesarDechif
            ;;

    esac
}

chiffrementCasearSimple(){
    local chaine="$1"
    chiffrementCasear "$chaine"
    caesarChif
}


chiffrementCasear(){
#Valeur Ascii [0-127]
#[a-z] => 97-122
#[A-Z] => 65-90
#[0-9] => 48-57
	local chaine="$1"
	res=""
	#Avoir la taille de la chaine => ${#chaine}
	for ((i=0; i<${#chaine}; i++)); do
	
		lettre=${chaine:$i:1} #Récupérer la lettre à la position i=> ${chaine:$i:1}
		#echo "$lettre"
		
		asciiLettre=$(printf "%d" "'$lettre") #la ' permet de montrer que $lettre est un caractère
		
		#Lettres majuscules
		if [ $asciiLettre -ge 65 ] && [ $asciiLettre -le 90 ]; then
			asciiLettre=$((asciiLettre+cleCaesarChif)) #Pour additionner en bash, il faut utiliser (( ))
			while [ $asciiLettre -gt 90 ]; do
				asciiLettre=$((asciiLettre-26)) #Au cas où ça dépasse, on fait -26 pour boucler 
			done
			lettre=$(printf "\\$(printf '%03o' $asciiLettre)")
		
		#Lettres minuscules
		elif [ $asciiLettre -ge 97 ] && [ $asciiLettre -le 122 ]; then
			asciiLettre=$((asciiLettre+cleCaesarChif))
			while [ $asciiLettre -gt 122 ]; do
				asciiLettre=$((asciiLettre-26)) #Au cas où ça dépasse, on fait -26 pour boucler 
			done
			lettre=$(printf "\\$(printf '%03o' $asciiLettre)")
		
		#Chiffres
		elif [ $asciiLettre -ge 48 ] && [ $asciiLettre -le 57 ]; then
			asciiLettre=$((asciiLettre+cleCaesarChif))
			while [ $asciiLettre -gt 57 ]; do
				asciiLettre=$((asciiLettre-10)) #Au cas où ça dépasse, on fait -10 pour boucler 
			done
			lettre=$(printf "\\$(printf '%03o' $asciiLettre)")
		fi
		 
		#echo "$asciiLettre"
        
		res+=$lettre
	done
	echo "$res"
}


chiffrementFichierCaesar(){
    chemin="$1"
    fichierChif=$(creerFichierCaesarChif "$chemin")    

    cat "$chemin" | while read -r ligne || [[ -n "$ligne" ]]
    do
        ligneChif=$(chiffrementCasear "$ligne")
        echo -e "$ligneChif" >> "$fichierChif"
    done

    caesarChif

}

chiffrementLignesFichierCaesar(){
    ligne1="$1"
    ligne2="$2"
    chemin="$3"
    fichierChif=$(creerFichierCaesarChif "$chemin")

    sed -n "${ligne1},${ligne2}p" "$chemin" | while read -r ligne
    do
        ligneChif=$(chiffrementCasear "$ligne")
        echo -e "$ligneChif" >> "$fichierChif"
    done
    caesarChif

}

dechiffrementCasearSimple(){
    local chaine="$1"
    dechiffrementCasear "$chaine" "$cleCaesarDechif"
    caesarDechif
}

dechiffrementCasear(){
    local chaine="$1"
    local cleCaesarDechif="$2"
	res=""
	
	for ((i=0; i<${#chaine}; i++)); do
	
		lettre=${chaine:$i:1}
		#echo "$lettre"
		
		asciiLettre=$(printf "%d" "'$lettre") 
		
		#Lettres majuscules
		if [ $asciiLettre -ge 65 ] && [ $asciiLettre -le 90 ]; then
			asciiLettre=$((asciiLettre-cleCaesarDechif)) 
			while [ $asciiLettre -lt 65 ]; do
				asciiLettre=$((asciiLettre+26)) 
			done
			lettre=$(printf "\\$(printf '%03o' $asciiLettre)")
		
		#Lettres minuscules
		elif [ $asciiLettre -ge 97 ] && [ $asciiLettre -le 122 ]; then
			asciiLettre=$((asciiLettre-cleCaesarDechif))
			while [ $asciiLettre -lt 97 ]; do
				asciiLettre=$((asciiLettre+26)) 
			done
			lettre=$(printf "\\$(printf '%03o' $asciiLettre)")
		
		#Chiffres
		elif [ $asciiLettre -ge 48 ] && [ $asciiLettre -le 57 ]; then
			asciiLettre=$((asciiLettre-cleCaesarDechif))
			while [ $asciiLettre -lt 48 ]; do
				asciiLettre=$((asciiLettre+10)) 
			done
			lettre=$(printf "\\$(printf '%03o' $asciiLettre)")
		fi
		 
		#echo "$asciiLettre"
		
		res+=$lettre
	done
	echo "$res"
}

dechiffrementFichierCaesar(){
    chemin="$1"
    cle="$2"
    fichierDechif=$(creerFichierCaesarDechif "$chemin")    

    cat "$chemin" | while read -r ligne || [[ -n "$ligne" ]]
    do
        ligneDechif=$(dechiffrementCasear "$ligne" "$cle")
        echo -e "$ligneDechif" >> "$fichierDechif"
    done
    
    caesarDechif

}

dechiffrementLignesFichierCaesar(){
    ligne1="$1"
    ligne2="$2"
    chemin="$3"
    cle="$4"
    fichierDechif=$(creerFichierCaesarDechif "$chemin")

    sed -n "${ligne1},${ligne2}p" "$chemin" | while read -r ligne
    do
        ligneDechif=$(dechiffrementCasear "$ligne" "$cle")
        echo -e "$ligneDechif" >> "$fichierDechif"
    done
    caesarDechif

}

creerFichierCaesarChif(){
    chemin="$1"
    nomFichier=$(basename "$chemin")
    dossierFichier=$(dirname "$chemin")

    nomSansExt="${nomFichier%.*}"
    extension="${nomFichier##*.}"

    if [ "$nomFichier" != "$extension" ]; then
        fichierChif="${dossierFichier}/${nomSansExt}Chiffrer.${extension}"
    else
        fichierChif="${dossierFichier}/${nomSansExt}Chiffrer"
    fi
    touch "$fichierChif"
    chmod 777 "$fichierChif"
    echo "---------------------|Nouveau Chiffrement|---------------------" >> "$fichierChif"
    echo "$fichierChif"
}

creerFichierCaesarDechif(){
    chemin="$1"
    nomFichier=$(basename "$chemin")
    dossierFichier=$(dirname "$chemin")

    nomSansExt="${nomFichier%.*}"
    extension="${nomFichier##*.}"

    if [ "$nomFichier" != "$extension" ]; then
        fichierDechif="${dossierFichier}/${nomSansExt}Dechiffrer.${extension}"
    else
        fichierDechif="${dossierFichier}/${nomSansExt}Dechiffrer"
    fi
    touch "$fichierDechif"
    chmod 777 "$fichierDechif"
    echo "---------------------|Nouveau Dechiffrement|---------------------" >> "$fichierDechif"
    echo "$fichierDechif"
}
