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
    echo $choix
}

# Fontion qui quitte le programme
quitter(){
    exit 0
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

    if[ "$choixCaesar" == "1" ]; then
        echo "Vous avez choisi le chiffrement de données"
        caesarChif
     
    else if[ "$choixCaesar" == "2" ]; then
        echo "Vous avez choisi le déchiffrement de données"
        caesarDechif

    else if[ "$choixCaesar" == "3" ]; then
        echo "Retour au menu principal..."
        main

    else if[ "$choixCaesar" == "4" ]; then
        echo "Vous avez choisi de quitter le programme"
        quitter
    fi
    echo $choixCaesar
}


# Chiffrment choix
caesarChif(){
    echo "Que souhaitez-vous chiffrer ?"
    echo "Le contenu d'un fichier externe (1)"
    echo "Une phrase (2)"
    # echo "Retour (3)"

    read choixCaesaerChif

    if[ "$choixCaesaerChif" == "1" ]; then
        echo "Vous avez choisi le chiffrement le contenu d'un fichier externe"
        echo "Entrez le chemin de votre fichier..."

        read caesarCheminChif

        if [ ! -e "$caesarCheminChif" -o ! -f "$caesarCheminChif"]; then
            echo "Chemin incorrect..."
        fi

        echo "Quelles lignes du fichier voulez-vous chiffrer ?"
        echo "Attention"
        echo "Tout (1)"
        echo "Choisissez les lignes (2)"
        echo "Retour (3)"

        read caesarChoixLignes

        if[ "$caesarChoixLignes" == "1" ]; then
            echo "Chiffrement du fichier en cours"
            echo "Entrez le chemin de votre fichier..."
        if[ "$caesarChoixLignes" == "1" ]; then
            echo "Chiffrement du fichier en cours"
            echo "Entrez le chemin de votre fichier..."
        if[ "$caesarChoixLignes" == "1" ]; then
            echo "Chiffrement du fichier en cours"
            echo "Entrez le chemin de votre fichier..."


        
    fi 
    if[ "$choixCaesaerChif" == "2" ]; then
        echo "Vous avez choisi de chiffrer d'une phrase"
        echo "Entrez la phrase que vous souhaitez chiffrer..."
        
    fi    

}

# Dechiffrement choix
caesarDechif(){
    echo "Que souhaitez-vous déchiffrer ?"
    echo "Le contenu d'un fichier externe (1)"
    echo "Une phrase (2)" 

    read choixCaesarDechif

    if[ "$choixCaesarDechif" == "1" ]; then
        echo "Vous avez choisi de déchiffrer le contenu d'un fichier externe"
        echo "Entrez le chemin de votre fichier..."

        read caesarCheminDechif

    fi 
    if[ "$choixCaesarDechif" == "2" ]; then
        echo "Vous avez choisi de déchiffrer d'une phrase"
        echo "Entrez la phrase que vous souhaitez déchiffrer..."
    fi
}
