#!/bin/bash

# Fonction qui fait de l'aléatoire
aleatoire(){
    echo $((RANDOM % (500 - 5 + 1) + 5))
}


# Fontion qui quitte le programme
quitter(){
    exit 0
}