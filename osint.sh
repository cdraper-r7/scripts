#/bin/bash

#breach query script
#phonebook.cz
#dnsdumpster


echo "Enter company domain (ex. tesla.com)"
read -p 'Domain: ' domain
read -p 'api key: ' api
### SET VARIABLES ###
echo "Domain = $domain"
companyname=`echo $domain | cut -d "." -f1`
echo "Company Name = $companyname"
companypath=/home/kali/projects/$companyname/osint
echo "Files stored in $companypath"

#make folder if it does not exist
mkdir -p $companypath
cd $companypath

###Block Comment for troubleshooting ####
: <<'END'
END
#########################################

## Breach Database Emails
curl -H "Authorization: apikey $api" https://pwnd.tiden.io/search\?domain\=$domain | jq -r '.[] | "\(.username):\(.password)"' > $companypath/breach-database.txt
cat $companypath/breach-database.txt | cut -d ":" -f1 > $companypath/emails.txt

### GOOGLE DORKING #####
echo "LAUNCHING BROWSER!"
firefox "https://www.google.com/search?q=site:$domain ext:pwd OR ext:bak OR ext:skr OR ext:pgp OR ext:config OR ext:psw OR ext:inc OR ext:mdb OR ext:conf OR ext:dat OR ext:eml OR ext:log"&
sleep 1
firefox "https://www.google.com/search?q=site:$domain inurl:'htaccess' OR inurl:'passwd' OR inurl:'shadow' OR inurl:'htusers' OR inurl:'web.config' OR inurl:'ftp' OR inurl:'confidential' OR inurl:'login' OR inurl:'admin'"&
sleep 1
firefox "https://www.google.com/search?q=site:$domain intitle:'Index of' OR intitle:'index.of'"&
sleep 1
firefox "https://www.google.com/search?q=site:$domain (ext:doc OR ext:docx OR ext:pdf OR ext:xls OR ext:xlsx OR ext:txt OR ext:ps OR ext:rtf OR ext:odt OR ext:sxw OR ext:psw OR ext:ppt OR ext:pps OR ext:xml) 'username * password'"&
sleep 1
### ROBOTS ###
firefox "$domain/robots.txt"&
sleep 1
### WAYBACK ###
firefox "https://web.archive.org/web/*/$domain/*"&
echo "Search wayback search for pwd bak skr pgp config psw inc mdb conf dat eml log"
sleep 1


### MANUAL SEARCHES ###
echo "Domain is: $domain"
#### DNSDUMPSTER ###
firefox "https://dnsdumpster.com/"&
## Phonebook.cz combine with emails
firefox "https://phonebook.cz/"&
## Hunter.io
firefox "https://hunter.io/"&

echo "=======DONE======"