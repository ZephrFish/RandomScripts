# Operation Name Generator
# 02/04/2017
# 2022 updated to py3 :)
# Operation Motherfucking Pirate Time Motherfuckers
import urllib3
import random


wordList = "http://svnweb.freebsd.org/csrg/share/dict/words?view=co&content-type=text/plain"
response = urllib3.urlopen(wordList)
txt = response.read()
names = txt.splitlines()
word = random.choice(names)
operation = ""
while word:
    position = random.randrange(len(word))
    operation += word[position]
    word = word[:position] + word[(position + 1):]

print("Operation " + operation.upper())
