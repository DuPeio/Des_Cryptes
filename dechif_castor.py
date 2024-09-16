sentence:str = "ma phrase"
key:str = "castor"
pattern:str = ""
ind:int = 0
res:str = ""
chara:str = ""

for i in range(len(sentence)):
    chara = key[ind % len(key)]
    if ord("a") <= ord(sentence[i]) <= ord("z"):
        pattern += chara
        res += chr(((ord(chara) - ord('a')) + (ord(sentence[i]) - ord('a'))) % 26 + ord('a'))
        ind += 1
    elif ord("A") <= ord(sentence[i]) <= ord("Z"):
        pattern += chara
        ind += 1
    else:
        res += " "
        pattern += " "

print(pattern)
print(res)