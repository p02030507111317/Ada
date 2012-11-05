--------------------------------------------------------------
--              CLAVIER Paul; BESSON Lucas                  --
--------------------------------------------------------------
--  Info 321 TP1 Exercice 2                                 --
--      Compter le nombre de LE                             --
--      Compter le nombre de mots de plus de 4 lettres      --
--      Afficher une phrase en majuscule                    --
--------------------------------------------------------------
with Ada.Text_IO;
use Ada.Text_IO;
with Ada.Integer_Text_IO;
use Ada.Integer_Text_IO;

procedure CompteLe is
    lettre: Character;
    nb_le: Integer := 0;
    nb_4plus: Integer := 0;
    prev_l: Boolean := False;
    nb_lettre_mot: Integer := 0;
    begin
        get(lettre);                                                --On prends la première lettre
        while lettre /= '.' loop                                    --On traite une phrase finie par un point
            if ((lettre = 'e') or (lettre = 'E')) and prev_l then   --On traite la partie comptage de "le"
                nb_le := nb_le +1;
            end if;
            if lettre = ' ' then                                    --On traite la partie comptage de mots de plus de 4 lettres
                nb_lettre_mot := 0;
            else
                nb_lettre_mot := nb_lettre_mot +1;
            end if;
            if nb_lettre_mot = 4 then
                nb_4plus := nb_4plus +1;
            end if;
            if lettre >= 'a' and lettre <= 'z' then                 --On traite la partie afficher en majuscule
                Put(character'val(character'pos(lettre)-            --Si le caractère est une minuscule, on affiche sa majuscule
                    (character'pos('a')-character'pos('A'))));
            else
                Put(lettre);                                        --Sinon, on affiche le caractère tel quel
            end if;
            prev_l:=(lettre = 'l') or (lettre ='L');                --On prends l'élément suivant
            Get(lettre);
        end loop;
        Put(".");                                                   --On traite le dernier élément
        new_line;                                                   --Affichage des résultats
        Put("Nombre de 'le':");
        Put(nb_le);
        new_line;
        Put("Nombre de mots de plus de 4 lettres:");
        Put(nb_4plus);
    end CompteLe;
