param k := 4;
set I := 1..4;
set J := 1..k;
set N := 1..4*k;
var X {i in I, j in J} in N;

param gcd {x in N, y in N} := if (y mod x) == 0 then x else gcd[y mod x, x];

s.t. alldiff_X: alldiff {i in I, j in I} X[i,j];

maximize f: 
 sum {ia in I, ib in I, ja in J, jb in J, A in N, B in N}
  if (ib > ia) || (ia == ib && jb > ja) then
   if (A == X[ia,ja]) && (B == X[ib,jb]) then
    gcd[A,B]*(if (ia==1 && ib==4)||(ia==2 && ib==3) then 2 else 1);
