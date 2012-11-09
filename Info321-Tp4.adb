with ada.text_io;
use ada.text_io;
with ada.integer_text_io;
use ada.integer_text_io;
with ada.strings.unbounded;
use ada.strings.unbounded;
with ada.strings.unbounded.text_io;
use ada.strings.unbounded.text_io;

procedure main is

N: constant integer := 100;

type matrice is array(1..N, 1..6) of unbounded_string;

mat : matrice;

function lire_CSV(URL: string) return matrice is
	fichier : File_Type;
	ligne_actuelle : unbounded_string;
	cptr_ligne : integer;
	cptr_col : integer;
	prev_car : integer;
	Result: Matrice;
	begin
	Open(Name => URL, File => fichier, Mode => in_file);
	cptr_ligne := 1;
	loop
		ligne_actuelle := get_line(fichier);
		cptr_col := 1;
		prev_car := 1;
		for car in 1..length(ligne_actuelle) loop
				if element(ligne_actuelle, car) = ',' then
					Result(cptr_ligne, cptr_col) := to_unbounded_string(slice(ligne_actuelle, prev_car, car - 1));
					prev_car := car + 1;
					cptr_col := cptr_col + 1;
				end if;
				Result(cptr_ligne, cptr_col) := to_unbounded_string(slice(ligne_actuelle, prev_car, length(ligne_actuelle)));
			end loop;
		cptr_ligne := cptr_ligne + 1;
		exit when end_of_file(fichier);
		end loop;
	close(fichier);
	return Result;
	end;

begin
	mat := lire_CSV("toto.csv");
	for i in 1..N loop for j in 1..6 loop put(mat(i,j));put(" "); end loop; end loop;
end;