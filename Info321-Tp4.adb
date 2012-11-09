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

type ligne is array(1..6) of unbounded_string;
type chaine;
type ptr is access chaine;
type chaine is record
	data: ligne;
	next: ptr;
	end record;
	
type matrice is array(1..N, 1..6) of unbounded_string;

mat : matrice;
tab: ptr;

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
			end loop;
			Result(cptr_ligne, cptr_col) := to_unbounded_string(slice(ligne_actuelle, prev_car, length(ligne_actuelle)));
		cptr_ligne := cptr_ligne + 1;
		exit when end_of_file(fichier);
		end loop;
	close(fichier);
	return Result;
	end;

function  lire_CSV_LC(URL: String) return ptr is
	fichier : File_Type;
	ligne_actuelle : unbounded_string;
	cptr_col : integer;
	prev_car : integer;
	anchor : ptr;
	ptrs : ptr;
	begin
	Open(Name => URL, File => fichier, Mode => in_file);
	ptrs := new chaine;
	anchor := ptrs;
	cptr_col := 1;
	loop
		ligne_actuelle := get_line(fichier);
		cptr_col := 1;
		prev_car := 1;
		for car in 1..length(ligne_actuelle) loop
			if element(ligne_actuelle, car) = ',' then
				ptrs.data(cptr_col) := to_unbounded_string(slice(ligne_actuelle, prev_car, car - 1));
				prev_car := car + 1;
				cptr_col := cptr_col + 1;
			end if;
		end loop;
		ptrs.data(cptr_col) := to_unbounded_string(slice(ligne_actuelle, prev_car, length(ligne_actuelle)));
		ptrs.next:= new chaine;
		ptrs := ptrs.next;
		exit when end_of_file(fichier);
		end loop;
	close(fichier);
	return anchor;
	end;

function afficher_routes(verbose: boolean) return ptr is
	ptrs : ptr;
	result: ptr;
	begin
		ptrs := lire_CSV_LC("routes.txt");
		result := ptrs;
		if verbose then 
			while ptrs /= null loop
				for i in 1..6 loop
					put(ptrs.data(i)); put("   ");
				end loop;
				ptrs := ptrs.next;
				new_line;
			end loop;
		end if;
		return result;
	end;

function afficher_arrets (verbose: boolean) return ptr is
	ptrs : ptr;
	result: ptr;
	begin
		ptrs := lire_CSV_LC("stops.txt");
		result := ptrs;
		if verbose then
			while ptrs /= null loop
				for i in 1..6 loop
					put(ptrs.data(i)); put("   ");
				end loop;
				ptrs := ptrs.next;
				new_line;
			end loop;
		end if;
		return result;
	end;

	function afficher_trajets (verbose: boolean) return ptr is
	ptrs : ptr;
	result: ptr;
	begin
		ptrs := lire_CSV_LC("stop_times.txt");
		result := ptrs;
		if verbose then
			while ptrs /= null loop
				for i in 1..6 loop
					put(ptrs.data(i)); put("   ");
				end loop;
				ptrs := ptrs.next;
				new_line;
			end loop;
		end if;
		return result;
	end;
	
function rechercher_arret(nom: unbounded_string) return unbounded_string is
	arret: ptr;
	begin
		arret := afficher_routes(false);
		while arret.data(2) /= nom and arret /= null loop
			arret := arret.next;
		end loop;
		if arret = null then
			return "None";
		else
			return arret.data(1);
		end if;
	end;

function rechercher_trajets(verbose: boolean) return ptr is
--TODO--

procedure afficher_trajets(nom: unbounded_string) is
	routes : ptr;
	stop_id: unbounded_string;
	begin
		stop_id := rechercher_arret(nom);
		if stop_id = "None" then
			exit;
		end if;
		routes := afficher_routes(false);
		while routes /= null loop
			if route.data(1) = stop_id then
		end loop;
		--TODO--
	end;
	
begin
	--TODO--
end;