sentence:str = "ma  phrase"
key:str = "castor"
ind:int = 0
res:str = ""
chara:str = ""

for i in range(len(sentence)):
    chara = key[ind % len(key)]
    if ord("a") <= ord(sentence[i]) <= ord("z"):
        res += chr(((ord(chara) - ord('a')) + (ord(sentence[i]) - ord('a'))) % 26 + ord('a'))
        ind += 1
    elif ord("A") <= ord(sentence[i]) <= ord("Z"):
        res += chr(((ord(chara) - ord('A')) + (ord(sentence[i]) - ord('A'))) % 26 + ord('A'))
        ind += 1
    else:
        res += " "

print(res)