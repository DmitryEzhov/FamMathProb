param n := 4;
param N := n^2;
set I := 1..n;
set J := 1..N;
var X {i in I, j in I, k in J} in 0..1;

param gcd {x in J, y in J} := if (y mod x) == 0 then x else gcd[y mod x, x];

param dist {ia in I, ja in I, ib in I, jb in I} :=
  if ib > ia || (ia == ib && jb > ja) then (ia - ib)^2 + (ja - jb)^2 else 0;

subject to c1 {k in J}: sum {i in I, j in I} (X[i,j,k]) == 1;

subject to c2 {i in I, j in I}: sum {k in J} (X[i,j,k]) == 1;

minimize DN:
  sum {ia in I, ja in I, ib in I, jb in I, ka in J, kb in J}
    (if X[ia,ja,ka] == 1 && X[ib,jb,kb] == 1 then gcd[ka,kb]*dist[ia,ja,ib,jb]);
