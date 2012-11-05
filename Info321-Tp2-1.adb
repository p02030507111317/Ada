
with Ada.Text_Io;
use Ada.Text_Io;
with Ada.Integer_Text_Io;
use Ada.Integer_Text_Io;

procedure Main is
   -- Début Déclaration Variables
   N : constant Integer := 20;
   -- Début Déclaration Type
   type Tableaun is array (1 .. N) of Integer;
   -- Fin Déclaration Type
   T_Tab : Tableaun;
   -- Fin Déclaration Variables
   -- Début Déclaration Fonction Tri
   function Tri (T_Input : Tableaun; PMAX: Integer) return Tableaun is
      -- Début Déclaration Types
      type Matrice10_N is array (0 .. 9, 1 .. N) of Integer;
      type Tableau10 is array (0 .. 9) of Integer;
      -- Fin Déclaration Types
      -- Début Déclaration Variables
      T_Premlib         : Tableau10;
      T_Tab             : Tableaun;
      M_Inter           : Matrice10_N;
      I_Digit           : Integer;
      I_Premlibresultat : Integer;
      
      -- Fin Déclaration Variables
   begin
      -- Copie du tableau donné en entrée dans un tableau inscriptible
      for I in 1..N loop
         T_Tab(I) := T_Input(I);
      end loop;
      -- Initialisation de la Matrice Intermédiaire
      for I in 0..9 loop
         for J in 1..N loop
            M_Inter(I,J):=0;
         end loop;
      end loop;
      -- Début de la boucle traitant les puissances de 10 successives
      for Puis in 1..PMAX loop
         -- Remise à zéro de tableau contenant les premlib de la matrice
         for Tmp in 0..9 loop
            T_Premlib(Tmp) := 1;
         end loop;
         -- Début de la boucle traitant les éléments du tableau
         for Nbr in 1..N loop
            -- On calcule le puiss ième chiffre du nombre en partant de l'unitée
            I_Digit := (T_Tab(Nbr) / (10 ** (Puis - 1))) mod 10;
            -- On place le nombre dans la matrice et on incrémante le premlib correspondant
            M_Inter(I_Digit, T_Premlib(I_Digit)) := T_Tab(Nbr);
            T_Premlib(I_Digit) := T_Premlib(I_Digit) + 1;
         end loop;
         -- On transforme la matrice en tableau en supprimant les cases innutiles
         I_Premlibresultat := 1;
         for I in 0..9 loop
            for J in 1..(T_Premlib(I)-1) loop
               T_Tab(I_Premlibresultat) := M_Inter(I,J);
               I_Premlibresultat := I_Premlibresultat + 1;
            end loop;
         end loop;
      end loop;
      return T_Tab;
   end Tri;
   -- Fin Déclaration Fonction Tri
begin
   for I in 1..N loop
      Get(T_Tab(I));
   end loop;
   T_Tab := Tri(T_Tab, 4);
   for I in 1..N loop
      Put(T_Tab(I));
   end loop;
end Main;


