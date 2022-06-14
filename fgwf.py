import requests
import urllib.parse
from bs4 import BeautifulSoup  
from datetime import datetime
import time

now = datetime.now()
dt_string = now.strftime("%b-%d-%Y-%H-%M-%S")
cat_file = "categories-"+ dt_string +".csv"
serviceurl = "https://fortiguard.com/webfilter?"
args = dict()
count = 0
notFound = list()

try:
    fh_addr = open("addresses.txt")
except:   
    print("\nCould not open addresses.txt\n")
    print("Trying to create addresses.txt")
    try:
        fh_addr = open("addresses.txt", "w")
        fh_addr.close()
        fh_addr = open("addresses.txt")
    except:
        print("\nCould not create addresses.txt\n")
        input("Press any key to exit...")
        exit()
if len(fh_addr.read()) == 0:
    print("\nAdd addresses to addresses.txt\n")
    input("Press any key to exit...")
    exit()
else:
    fh_addr.seek(0)
try:   
    fh_cat = open(cat_file,"w")
except:
    print("\nCould not create output file...\n")
    input("Press any key to exit...")
    exit()    

for address in fh_addr:
    category = None
    args['q'] = address.strip()
    args['version'] = 8
    url = serviceurl + urllib.parse.urlencode(args)
    print('Retrieving', args['q'])
    try:
        data = requests.get(url)
        soup = BeautifulSoup(data.text, 'html.parser')
        try:
            category = soup.find('h4', {'class': 'info_title'}).get_text()
        except:
            category = None
            print("Category not found!", args['q'])
            notFound.append(args['q'])
        if category is not None:
            count += 1
            cat = category[category.index(':')+1:].strip()
            print(cat)
            fh_cat.write(str(args['q'] + " , " + cat + "\n"))
        if count%10 == 0:
            print("\nContinuing in 5 seconds...\n")
            time.sleep(5)
    except KeyboardInterrupt:
        print("\nKeyboard Interrupt\n")
        break
    except:
        print("Error retrieving",args['q'])
        
fh_cat.close()
fh_addr.close()

if notFound:
    try:
        nF_file = "addressesNotFound-"+ dt_string +".txt"
        nF = open(nF_file,"w")
    except:
        nF = False 
    print("\nThe category of following address are NOT FOUND\n")
    for s in notFound:
        print(s)
        if nF:
            nF.write(s+"\n")
    if nF:
        nF.close()
        print("\nThe addresses whose category are NOT FOUND is written to",nF_file,"\n")

print("\nCategory retrieval of",count,"addresses Successful...\nWritten to",cat_file,"\n")
input("Press any key to exit...")
