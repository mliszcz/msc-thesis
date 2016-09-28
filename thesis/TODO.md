1. [done] praca mało przypomina pracę magisterską, bardziej wygląda na technical report; powodem jest jej nadmierne przeciążenie informacją o technicznych sprawach - nazwy technologii, rozmaite skróty itd.
   Rozdzial 1 przerobiony i rozbity na dwa (lub wydzielona czesc przeniesc do appendix?)
2. [done] widać to już w Introduction, gdzie raczej powinno się zacząć od zagadnień ogólnych związanych ze złożonymi systemami, ich sterowaniem, wizualizacją itd., a gdzieś dalej, przejść do Tango; wstęp jest za długi, zwykle można ograniczyć się 3 stronami, najwyżej 4 i to włącznie z celem pracy
    Punkt 1?
3. [done] solution overview nie jest szczęśliwym tytułem rozdziału; rozwiązanie raczej opisujemy, w miarę możliwości, dokładnie
   Nowa nazwa: Solution and Implementation
4. [done] istotnie brakuje diagramów sekwencji, same diagramy klas, czy architektury nie wystarczą
   Nowy section w rozdziale 3: Interworking between TangoJS layers + 3 sequence diagramy
5. [done] warto pokazać przykłady: co dzieje się w najniższej warstwie, potem wyżej i wyżej, aż do tego co widzi użytkownik
   To jest rozwiazane przez punkt 4 (?)
6. [done] trzeba zrobić bardzo porządny glossary, z objaśnieniem wszystkich pojęć, skrótów, nazw technologii
   Glossary dodany
7. [done] trzeba też pozbyć się cech komercyjności w jeżyku tekstu, np. nie podoba mi się czasownik "ship", albo cech wskazujących na inżynierski charakter pracy, np. "Learn from the best".
   Usunete. 'Ship' zostalo w state-of-the-art w odniesieniu do jednego z istniejacych systemow

* [done] spacje przy cytowaniu[]
* [done] uzupelnic brakujace cytaty
* [done] przypisy [^1] przeniesc do bibliografii
* [reject] Tbl. -> Table
* poprawic formatowanie tabelek
* [done] klikalne referencje do rozdzialow -> Chapter X
* duzo jest zdan gdzie *The* jest pierwszym slowem kilka razy z rzedu
* [done] in Figure, on Listing
* naprawic wszystkie TODO w tekscie
  * chapter 1 - rozbity na dwa
  * chapter 3 - rysunki w chmurkach - nie dam rady tego zrobic z latexa
* KUKDM -> zalacznik z posterem czy cytowac abstrakt
* napisac nowy abstrakt

01-introduction.md:The concepts ~~described in this section~~ are just an overview to give the reader
01-introduction.md:  or **design and develop a new one**, reusing the ~~good~~ parts;
03-solution-overview.md:address these issues and fulfill the goals ~~discussed~~ in [@Sec:introduction],
05-results.md:architecture, platform choice and even the distribution model. ~~Below~~ are
