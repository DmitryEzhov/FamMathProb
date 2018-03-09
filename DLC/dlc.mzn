include "globals.mzn";

int: n = 4; set of int: N = 1..n;
int: m = n*n; set of int: M = 1..m;

array[M] of N: ii = [if x mod n = 0 then (x - x mod n) div n else (x - x mod n) div n + 1 endif | x in M];
array[M] of N: jj = [if x mod n = 0 then n else x mod n endif | x in M];

array[M, M] of int: DIST = array2d(M, M, 
  [if ii[b] > ii[a] \/ (ii[a] = ii[b] /\ jj[b] > jj[a])
     then (ii[a] - ii[b])*(ii[a] - ii[b]) + (jj[a] - jj[b])*(jj[a] - jj[b]) else 0 endif | a,b in M]);

array[M, M] of 0..m: GCD = array2d(M, M,
  [g-1 | i,j,g in M
     where exists([i mod ii = 0 /\ j mod ii = 0 /\ g = ii /\ forall([not(i mod jj = 0 /\ j mod jj = 0) | jj in ii+1..min(ub(i),ub(j))])
       | ii in 1..min(ub(i),ub(j))])]);

array[M] of var M: X;
var int: DN = sum([GCD[X[i],X[j]]*DIST[i,j] | i,j in M where i < m /\ j > i]);

constraint alldifferent([X[i] | i in M]);

solve minimize DN;

output 
["Delacorte Number = \(DN + m*m*(m-1) div 6)\n"] ++
["X = "] ++
[if i mod n = 1 then "(\(X[i])," else  if i mod n = 0 then "\(X[i]))," else "\(X[i])," endif  endif | i in M] ++
["\n"];
