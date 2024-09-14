#!/bin/bash

#Partie Globale : Main
main() {
    echo "Bonjour"
    echo "Choisissez un mode de chiffrement"
    echo "Code Morse (1)"
    echo "Code Caesar (2)"
    echo "Code de Vigenère (3)"
    echo "Quitter le programme (4)"

    read choix

    case $choix in
        "1")
            echo "Vous avez choisi le Code Morse"
            ;;
        "2")
            echo "Vous avez choisi le Code Caesar"
            caesarMain
            ;;
        "3")
            echo "Vous avez choisi le Code de Vigenère"
            ;;
        "4")
            echo "Vous avez choisi de quitter le programme"
            quitter
            ;;
        *)
            echo "Choix invalide. Veuillez réessayer."
            main
    esac
    # echo $choix //Pour test
}

# Fontion qui quitte le programme
quitter(){
    exit 0
}

# Fonction qui fait de l'aléatoire
aleatoire(){
    echo $((RANDOM % (500 - 5 + 1) + 5))
}



# Partie Peio : Code Ceasar
# Menu 
caesarMain() {
    echo "Que voulez vous faire ?"
    echo "Chiffrer (1)"
    echo "Dechiffrer (2)"
    echo "Choisir un autre mode de chiffrement (3)"
    echo "Quitter le programme (4)"

    read choixCaesar

    case $choixCaesar in
        "1")   
            echo "Vous avez choisi le chiffrement de données"
            caesarChif
            ;;
        "2")
            echo "Vous avez choisi le déchiffrement de données"
            caesarDechif
            ;;
        "3")
            echo "Retour au menu principal..."
            main
            ;;
        "4")
            echo "Vous avez choisi de quitter le programme"
            quitter
            ;;
        *)
            echo "Choix invalide. Veuillez réessayer."
            caesarMain
    esac
    # echo $choixCaesar //Pour test
}

cleCaesarChif = 0 #Elle est en globale sinon elle se réinitialise à chaque fois que je lance caesarChif

# Chiffrment choix
caesarChif(){
    echo "Que souhaitez-vous faire ?"
    echo "Chiffrer le contenu d'un fichier externe (1)"
    echo "Chiffrer une phrase (2)"
    echo "Changer la clé de chiffrement, elle est égale à $cleCaesarChif (3)"
    echo "Retour au menu Caesar (4)"

    read choixCaesarChif


    case $choixCaesarChif in
        "1")
            echo "Vous avez choisi de chiffrer le contenu d'un fichier externe"
            echo "Entrez le chemin de votre fichier..."

            read caesarCheminChif

            if [ ! -e "$caesarCheminChif" ] || [ ! -f "$caesarCheminChif" ]; then
                echo "Chemin incorrect..."
                caesarChif
            fi

            echo "Voulez vous chiffrer tout le fichier ou juste quelques lignes ?"
            echo "Attention votre fichier va subir des modifications"
            echo "Tout (1)"
            echo "Choisissez les lignes (2)"
            echo "Retour (3)"

            read caesarChoixLignes

            case $caesarChoixLignes in
                "1")
                    echo "Chiffrement du fichier en cours"
                    ;;

                "2")
                    echo "Quelles lignes du fichier voulez-vous chiffrer ?"
                
                    read choixLignesCaesar

                    # Il faut voir si les lignes sont valides 
                    # Puis traduire 
                    ;;

                "3")
                    echo "Retour au menu Caesar..."
                    caesarMain
                    ;;

                *)
                    echo "Choix invalide. Veuillez réessayer."
                    caesarChif
                    ;;

            esac
            ;;
        
        "2")
            echo "Vous avez choisi de chiffrer une phrase"
            echo "Entrez la phrase que vous souhaitez chiffrer..."

            read phraseCaesar

            # Il faut traduire la phrase

            ;;
        
        "3")
            echo "Choisissez une clé de chiffrement"
            echo "Aléatoire (0)"
            echo "Autre, entrez la valeur de la clé"

            read choixCleCaesarChiff

            if [ "$choixCleCaesarChiff" == "0" ]; then
                cleCaesarChif = $(aleatoire)
            else
                cleCaesarChif = choixCleCaesarChiff
            fi
            caesarChif
            ;;

        "4")
            echo "Retour au menu Caesar..."
                    caesarMain
            ;;

        *)
            echo "Choix invalide. Veuillez réessayer."
            caesarChif
            ;;

    esac
}

# Dechiffrement choix
caesarDechif(){
    echo "Que souhaitez-vous déchiffrer ?"
    echo "Le contenu d'un fichier externe (1)"
    echo "Une phrase (2)"
    echo "Retour (3)" 

    read choixCaesarDechif

    case $choixCaesarDechif in
        "1")
            echo "Vous avez choisi de déchiffrer le contenu d'un fichier externe"
            echo "Entrez le chemin de votre fichier..."

            read caesarCheminDechif

            if [ ! -e "$caesarCheminDechif" ] || [ ! -f "$caesarCheminDechif" ]; then
                echo "Chemin incorrect..."
                caesarDechif
            fi

            echo "Voulez vous déchiffrer tout le fichier ou juste quelques lignes ?"
            echo "Attention votre fichier va subir des modifications"
            echo "Tout (1)"
            echo "Choisissez les lignes (2)"
            echo "Retour (3)"

            read caesarChoixLignes

            case $caesarChoixLignes in
                "1")
                    echo "Entrez la clé pour déchiffrer cette phrase"
                    read cleCaesarDechif

                    echo "Déchiffrement du fichier en cours"
                    # Traduire le texte
                    ;;

                "2")
                    # Doit choisir la clé de déchiffrement
                    echo "Quelles lignes du fichier voulez-vous déchiffrer ?"
                
                    read choixLignesCaesar

                    
                    # Il faut voir si les lignes sont valides

                    echo "Entrez la clé pour déchiffrer cette phrase"
                    read cleCaesarDechif 
                    # Puis traduire 
                    ;;

                "3")
                    echo "Retour au menu Caesar..."
                    caesarMain
                    ;;

                *)
                    echo "Choix invalide. Veuillez réessayer."
                    caesarDechif
                    ;;

            esac
            ;;
        
        "2")
            
            echo "Vous avez choisi de déchiffrer une phrase"
            echo "Entrez la phrase que vous souhaitez déchiffrer..."
            read phraseCaesar

            echo "Entrez la clé pour déchiffrer cette phrase"
            read cleCaesarDechif

            # Il faut traduire la phrase

            ;;
        
        "3")
            echo "Retour au menu Caesar..."
            caesarMain
            ;;
        
        *)
            echo "Choix invalide. Veuillez réessayer."
            caesardechif
            ;;

    esac
}

main
