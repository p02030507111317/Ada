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

type vehicules is (Tramway, Metro, Train, Bus, Ferry, Cablecars, Telecabine, Funiculaire);
package enum_vehicule is new enumeration_io(vehicules);
use enum_vehicule;

type matrice is array(1..N, 1..6) of unbounded_string;

mat : matrice;
tab: ptr;

function lire_CSV(URL: string) return matrice is
-- Lis un fichier CSV et renvoie son contenu sous forme de matrice.
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
-- Lis un fichier CSV et renvoie son contenu sous forme de liste chaînée.
	fichier : File_Type;
	ligne_actuelle : unbounded_string;
	cptr_col : integer;
	prev_car : integer;
	anchor : ptr;
	ptrs : ptr;
	begin
	Open(Name => URL, File => fichier, Mode => in_file);
	anchor := null;
	cptr_col := 1;
	ligne_actuelle := get_line(fichier);
	while not End_of_File(fichier) loop
		ligne_actuelle := get_line(fichier);
		cptr_col := 1;
		prev_car := 1;
		ptrs := new chaine;
		for car in 1..length(ligne_actuelle) loop
			if element(ligne_actuelle, car) = ',' then
				ptrs.data(cptr_col) := to_unbounded_string(slice(ligne_actuelle, prev_car, car - 1));
				prev_car := car + 1;
				cptr_col := cptr_col + 1;
			end if;
		end loop;
		ptrs.data(cptr_col) := to_unbounded_string(slice(ligne_actuelle, prev_car, length(ligne_actuelle)));
		ptrs.next := anchor;
		anchor := ptrs;
		end loop;
	close(fichier);
	return anchor;
	end;

function lire_routes return ptr is
--Lis le fichier "routes.txt" et renvoie le contenu sous forme de liste chaînée.
	begin
		return lire_CSV_LC("routes.txt");
	end;

function lire_arrets return ptr is
--Lis le fichier "stops.txt" et renvoie le contenu sous forme de liste chaînée.
	begin
		return lire_CSV_LC("stops.txt");
	end;

function lire_trajets return ptr is
--Lis le fichier "stop_times" et renvoie le contenu sous forme de liste chaînée.
	begin
		return lire_CSV_LC("stop_times.txt");
	end;
	
function rechercher_ligne(nom: unbounded_string) return unbounded_string is
-- Renvoie l'identifiant de la ligne correspondant au nom donné.
	arret: ptr;
	begin
		arret := lire_routes;
		while  arret /= null and then arret.data(2) /= nom loop
			arret := arret.next;
		end loop;
		if arret = null then
			return to_unbounded_string("None");
		else
			return arret.data(1);
		end if;
	end;
	
function rechercher_arret(nom: unbounded_string) return ptr is
-- Renvoie la liste des arrêts ayant pour nom le nom donné.
	arret: ptr;
	result: ptr;
	pt_temp : ptr;
	begin
		result := null;
		arret := lire_trajets;
		while arret /= null loop
			if arret.data(5) = nom then
				pt_temp := new chaine;
				pt_temp.data := arret.data;
				pt_temp.next := result;
				result := pt_temp;
			end if;
			arret := arret.next;
		end loop;
		return result;
	end;

function rechercher_trajets(route_id: unbounded_string) return ptr is
-- Renvoie la liste de tous les arrêts d'une ligne donnée par l'identifiant.
	arret: ptr;
	result: ptr;
	pt_temp : ptr;
	begin
		result := null;
		arret := lire_trajets;
		while arret /= null loop
			if arret.data(2) = route_id then
				pt_temp := new chaine;
				pt_temp.data := arret.data;
				pt_temp.next := result;
				result := pt_temp;
			end if;
			arret := arret.next;
		end loop;
		return result;
	end;

function get_unbounded_string return unbounded_string is
-- Procédure permettent de récupérer une chaine de caractère 
	str: unbounded_string;
	begin
		skip_line;
		str := get_line;
		return str;
	end;
	
procedure afficher_departs(nom: unbounded_string) is
--  Affiche tous les départs d'un arrêt donné par son nom.
	arret: ptr;
	begin
		new_line;
		arret := rechercher_arret(nom);
		put("Prochains départs à partir de l'arrêt "); put(nom); put(" :"); new_line;
		while arret /= null loop
			put("    - Heure de départ: "); put(arret.data(4)); new_line;
			arret := arret.next;
		end loop;
		new_line;
	end;	
	
procedure afficher_lignes is
-- Affiche le contenu de "routes.txt"
	route: ptr;
	begin
		new_line;
		route := lire_routes;
		while route /= null loop
			put("Ligne: "); put(route.data(3)); put(" : "); new_line;
			put("    - Identifiant: "); put(route.data(1)); new_line;
			put("    - Nom court: "); put(route.data(2)); new_line;
			put("    - Type de transport: "); put(vehicules'val(integer'value(to_string(route.data(4))))); new_line;
			new_line;
			route := route.next;
		end loop;
	end;

procedure choix_possibles is
-- 0: Quitter
-- 1: Afficher toutes les lignes
-- 2: Afficher une ligne en particulier
-- 3: Donner tous les departs d'un arret
	begin
	put("Voici les actions possibles:"); new_line;
	put("    1: Afficher toutes les lignes"); new_line;
	put("    2: Afficher tous les arrets d'une ligne (entrer son nom)"); new_line;
	put("    3: Afficher tous les départs d'un arret (donner son nom)"); new_line;
	new_line;
	put("    0: Quitter");new_line;
	put("Quel est votre choix? ");
	end;
	
procedure afficher_ligne(nom: unbounded_string) is
-- Affiche tous les arrêts d'une ligne complète donnée par son identifiant.
	arret: ptr;
	begin
		new_line;
		arret := rechercher_trajets(rechercher_ligne(nom));
		put("Ligne "); put(arret.data(2)); put(":"); new_line;
		while arret /= null loop
			put("  Nom de l'arret: "); put(arret.data(5)); new_line;
			put("    - Heure d'arrivée: "); put(arret.data(3)); new_line;
			put("    - Heure de départ: "); put(arret.data(4)); new_line;
			new_line;
			arret := arret.next;
		end loop;
	end;

	pointeur : ptr;
	choix: integer;
	entree: unbounded_string;

begin
	choix_possibles;
	get(choix);
	while choix /= 0 loop
		case choix is
			when 1=> afficher_lignes;
			when 2 => new_line; put("Donner la ligne désirée"); new_line; afficher_ligne(get_unbounded_string);
			when 3 => new_line; put("Donner l'arret désirée"); new_line; afficher_departs(get_unbounded_string);
			when others => put("Choix invalide");
		end case;
		choix_possibles;
		get(choix);
	end loop;
end;