#!/bin/bash

declare -A code_morse # Lettre : morse
declare -A decode_morse # Morse : Lettre

# Construction des Tables
cat 'morse.json' | while  read ligne
do
    # echo $ligne
    # /"+."+|"+[_.]{1,6}"+/
    if [[ $ligne =~ \"([^\"]+)\"[[:space:]]*:[[:space:]]*\"([^\"]+)\" ]]
    then
        # echo $ligne
        cle="${BASH_REMATCH[1]}" # Premier Groupe entre ()
        valeur="${BASH_REMATCH[2]}" # Deuxieme Groupe entre ()
        
        code_morse["$cle"]="$valeur"
        decode_morse["$valeur"]="$cle"
    fi
done

