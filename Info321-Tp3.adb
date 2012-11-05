with ada.text_io;
use ada.text_io;
with ada.integer_text_io;
use ada.integer_text_io;
with ada.strings.unbounded;
use ada.strings.unbounded;
with ada.strings.unbounded.text_io;
use ada.strings.unbounded.text_io;

procedure main is

N: constant integer := 1000; --Nombre d'emplacement disponibles dans la cave (bouteilles différentes)--

type vin_region is (Bourgogne, Bordeaux, Alsace, Beaujolais, Savoie, Autre); --Liste des regions--
package enum_vin_region is new enumeration_io(vin_region);
use enum_vin_region;
type vin_couleur is (rose, rouge, blanc); --Liste des types de vins--
package enum_vin_couleur is new enumeration_io(vin_couleur);
use enum_vin_couleur;
type bouteille is record --Déclaration du type bouteille--
	nom: unbounded_string;
	region: vin_region;
	couleur: vin_couleur;
	millesime: Integer;
	quantite: Integer;
	end record;
type array_bouteille is array(1..N) of bouteille;
type cave is record --Déclaration du type cave--
	contenu: array_bouteille;
	premlib: Integer := 1; --Première case libre de la cave--
	end record;
	
function recherche_pos(ma_cave: cave; ma_bouteille:bouteille) return integer is --Recherche la position d'une bouteille dans la cave si elle y est déja présente. Renvoie ma_cave.premlib sinon.--
begin
for indice in 1..ma_cave.premlib loop
	if ma_bouteille.nom = ma_cave.contenu(indice).nom and ma_bouteille.region = ma_cave.contenu(indice).region and ma_bouteille.couleur = ma_cave.contenu(indice).couleur and ma_bouteille.millesime = ma_cave.contenu(indice).millesime then --On teste si deux bouteilles sont identiques--
		return indice; --Si oui, on renvoie la position dans la cave de la bouteille--
	end if;
	end loop;
	return ma_cave.premlib; --Sinon, on renvoie premlib--
end;

procedure inserer_bouteille(ma_cave: in out cave; ma_bouteille: bouteille) is --Ajouter une bouteille dans la cave--
indice: integer;
begin
	indice:=recherche_pos(ma_cave, ma_bouteille); --On cherche l'indice de la bouteille dans la cave--
	if indice = ma_cave.premlib then --Si la bouteille n'est pas présente dans la cave--
		ma_cave.contenu(ma_cave.premlib):= ma_bouteille; --On l'ajoute--
		ma_cave.premlib := ma_cave.premlib + 1; --On incrémente la valeur premlib de la cave--
	else
		ma_cave.contenu(indice).quantite := ma_cave.contenu(indice).quantite + ma_bouteille.quantite; --Sinon, on ajoute juste les quantités--
	end if;
end;

procedure suppr_bouteille(ma_cave: in out cave; ma_bouteille: bouteille) is
indice: integer;
begin
	indice:=recherche_pos(ma_cave, ma_bouteille);
	if indice = ma_cave.premlib then
		put("Erreur: Bouteille non présente dans la cave"); new_line;
	else if ma_bouteille.quantite > ma_cave.contenu(indice).quantite then
		put("Erreur: Trop de bouteilles retirées"); new_line;
		else if ma_bouteille.quantite = ma_cave.contenu(indice).quantite then
			for i in indice..ma_cave.premlib-2 loop
				ma_cave.contenu(i) := ma_cave.contenu(i+1);
				end loop;
				ma_cave.premlib := ma_cave.premlib - 1;
			else ma_cave.contenu(indice).quantite := ma_cave.contenu(indice).quantite - ma_bouteille.quantite;
				end if;
		end if;
	end if;
end;

procedure afficher_cave(ma_cave: cave) is
begin
	for i in 1..ma_cave.premlib - 1 loop
		new_line;
		put("Bouteille:"); new_line;
		put("     Nom: ");
		put(ma_cave.contenu(i).nom); new_line;
		put("     Région: ");
		put(ma_cave.contenu(i).region); new_line;
		put("     Couleur: ");
		put(ma_cave.contenu(i).couleur); new_line;
		put("     Millésime: ");
		put(ma_cave.contenu(i).millesime); new_line;
		put("     Quantité: ");
		put(ma_cave.contenu(i).quantite); new_line;
	end loop;
end;

procedure get_bouteille(ma_bouteille: out bouteille) is
begin
	new_line;
	put("Nom? ");
	ma_bouteille.nom := get_line;
	put("Région? ");
	get(ma_bouteille.region);
	put("Couleur? ");
	get(ma_bouteille.couleur);
	put("Millésime? ");
	get(ma_bouteille.millesime);
	put("Quantité? ");
	get(ma_bouteille.quantite);
end;

choix: Integer;
fini: Boolean;
ma_bouteille: bouteille;
ma_cave: cave;

begin
fini := False;
while not(fini) loop
	new_line;
	put("Choisissez une opération a effectuer:"); new_line;
	put("1- Ajouter une ou plusieurs bouteilles"); new_line;
	put("2- Supprimer une ou pusieurs bouteilles"); new_line;
	put("3- Afficher la liste des bouteilles"); new_line;
	put("4- Quitter"); new_line;
	get(choix);
	case choix is
		when 1 => skip_line;get_bouteille(ma_bouteille); inserer_bouteille(ma_cave, ma_bouteille);
		when 2 => get_bouteille(ma_bouteille); suppr_bouteille(ma_cave, ma_bouteille);
		when 3=> afficher_cave(ma_cave);
		when 4=> fini := True;
		when others => put("Erreur: Choix invalide"); new_line;
		end case;
	end loop;
end;