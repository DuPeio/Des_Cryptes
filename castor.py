sentence:str = "ma phrase"
key:str = "castor"
pattern:str = ""
ind:int = 0
res:str = ""
chara:str = ""

for i in range(len(sentence)):
    if ord("a") <= ord(sentence[i]) <= ord("z"):
        chara = key[ind % len(key)]
        pattern += key[ind % len(key)]
        res += ord(key[ind % len(key)])
        ind += 1
    elif ord("A") <= ord(sentence[i]) <= ord("Z"):
        pattern += key[ind % len(key)]
        ind += 1
    else:
        pattern += " "

print(pattern)
print(res)