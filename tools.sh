#!/bin/bash

# Fonction qui fait de l'aléatoire
aleatoire(){
    echo $((RANDOM % (500 - 5 + 1) + 5))
}


# Fontion qui quitte le programme
quitter(){
    clear
    echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
    echo "           Vous avez choisi de quitter le programme"
    echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
    exit 0
}
