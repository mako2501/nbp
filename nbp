#!/bin/bash
#by mako
#pobieram do zmiennej zawartosc strony i od razu filtruje do linijki ktora zawiera wszytkie

LINIA=$(wget -q -O- http://nbp.pl/home.aspx?f=/kursy/kursya.html |grep 'Nazwa waluty') 
#tr -> Translate, squeeze, and/or delete characters 
echo $LINIA | tr '\>' '\n'|grep -v '^<\|^[[:upper:]][[:lower:]]\|-\|^[[:blank:]]'|tr '\<' '\n'|grep -v '/\|\.[[:alpha:]]'>linie
#filter linie to temp files wartosci,skrot i nazwa
grep '[0-9],[0-9]' linie > wartosci
grep '[^()][[:upper:]]\{3\}' linie > skrot
grep '^[[:alpha:]]' linie > nazwa

#count lines
WIERSZE=$(grep -c '[[:alpha:]]' nazwa)
#licznik petli
a=1
#result file
touch wynik
#while bedzie tworzyl kazdy wiersz za pomoca echo na ktore bedzie sie skladac
#linijki z poszczegolnych plikow wyluskanych headem do numeru wiersza
#aby okreslic ostatnia dana linijke z heda filtruje przez tail
while [ $a -le $WIERSZE ]
do
KOL2=$(cat skrot|head -n$a|tail -n1)
KOL3=$(cat wartosci|head -n$a|tail -n1)
KOL1=$(cat nazwa|head -n$a|tail -n1)
echo -e "$KOL1 \t $KOL2 \t $KOL3" >>wynik 
a=$[a+1]
done
cat wynik
#del temp files
rm wynik
rm wartosci
rm skrot
rm nazwa
rm linie








