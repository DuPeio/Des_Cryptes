#Partie Globale : Main
main() {
    echo "Bonjour"
    echo "Choisissez un mode de chiffrement"
    echo "Code Morse (1)"
    echo "Code Caesar (2)"
    echo "Code de Vigenère (3)"

    read choix

    if[ "$choix" == "1" ]; then
        echo "Vous avez choisi le Code Morse"
    fi 
    if[ "$choix" == "2" ]; then
        echo "Vous avez choisi le Code Caesar"
        caesarMain
    fi
    
    if[ "$choix" == "3" ]; then
        echo "Vous avez choisi le Code de Vigenère"
    fi
    echo $choix
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
    fi 
    if[ "$choixCaesar" == "2" ]; then
        echo "Vous avez choisi le déchiffrement de données"
        caesarDechif
    fi

    if[ "$choixCaesar" == "3" ]; then
        echo "Retour au menu principal..."
        main
    fi

    if[ "$choixCaesar" == "4" ]; then
        echo "Vous avez choisi de quitter le programme"
        exit 0
    fi
    echo $choixCaesar
}


# Chiffrment choix
caesarChif(){
    echo "Que souhaitez-vous chiffrer ?"
    echo "Le contenu d'un fichier externe (1)"
    echo "Une phrase (2)"

    read choixCaesaerChif

    if[ "$choixCaesaerChif" == "1" ]; then
        echo "Vous avez choisi le chiffrement le contenu d'un fichier externe"
        echo "Entrez le chemin de votre fichier..."

        read caesarCheminChif
        
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
