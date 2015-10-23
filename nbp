#!/bin/bash
#zadanie dodatkowe 
#Rafal Makowski s8113 
#pobieram do zmiennej zawartosc strony i od razu filtruje do linijki ktora zawiera wszytkie
#informacje na temat walut, znajduje ja przez ciag znakow Nazwa waluty

LINIA=$(GET -a http://nbp.pl/home.aspx?f=/kursy/kursya.html|grep 'Nazwa waluty') 
#aby kozystac z grepa musze rozbic ta linie na wiele innych
#dzieki tr zamieniam kazdy znak konca znacznika na znak nowej lini i potem
#bo potrzebne wartosci zawsze sa w roznych kolumnach i wierszach tabeli 
#czyli <tr><td>itd..
#filtruje grepem aby uzyskac tylko i wylacznie w kazdej lini potrzebne ciagi znakow
echo $LINIA | tr '\>' '\n'|grep -v '^<\|^[[:upper:]][[:lower:]]\|-\|^[[:blank:]]'|tr '\<' '\n'|grep -v '/\|\.[[:alpha:]]'>linie
#kazda pozniejsza kolumna ma swoje charakterystyczne wrtosci,filtruje to i wrzucam
#do plikow roboczych aby je rozdzielic
grep '[0-9],[0-9]' linie > wartosci
grep '[^()][[:upper:]]\{3\}' linie > skrot
grep '^[[:alpha:]]' linie > nazwa

#teraz mam juz poszczegolne wartosci w osobnych plikach
#obliczam ilosc wierszy kozystajac z jednego pliku
WIERSZE=$(grep -c '[[:alpha:]]' nazwa)
#licznik petli
a=1
#plik wynikowy w ktorym beda nadpisywal wiersze
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
#usuwam pliki robocze aby nie zasmiecaly dysku
#pamietac ze wynik sie nadpisuje
rm wynik
rm wartosci
rm skrot
rm nazwa
rm linie








