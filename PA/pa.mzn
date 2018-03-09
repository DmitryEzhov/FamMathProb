include "globals.mzn";

int: n = 11; set of int: N = 1..n;

array[N] of var N: X; array[N] of var N: Y;

array[N] of var int: A = array1d(N, [Y[i] - Y[i mod n + 1] | i in N]);
 
array[N] of var int: B = array1d(N, [X[i mod n + 1] - X[i] | i in N]);

array[N] of var int: C = array1d(N, [X[i] * Y[i mod n + 1] - X[i mod n + 1] * Y[i] | i in N]);

array[N, N] of var int: D = array2d(N, N, [A[i]*B[j] - A[j]*B[i] | i,j in N]);

array[N, N] of var float: XZ = array2d(N, N, [if i<j then (B[i]*C[j] - B[j]*C[i])/D[i,j] else 0 endif | i,j in N]);

array[N, N] of var float: YZ = array2d(N, N, [if i<j then (A[j]*C[i] - A[i]*C[j])/D[i,j] else 0 endif | i,j in N]);

array[N] of var N: minX = array1d(N, [min([X[i], X[i mod n + 1]]) | i in N]);
array[N] of var N: maxX = array1d(N, [max([X[i], X[i mod n + 1]]) | i in N]);
array[N] of var N: minY = array1d(N, [min([Y[i], Y[i mod n + 1]]) | i in N]);
array[N] of var N: maxY = array1d(N, [max([Y[i], Y[i mod n + 1]]) | i in N]);


constraint
  alldifferent([X[i] | i in N]) /\ alldifferent([Y[i] | i in N])
  /\
  forall([D[i,j] != 0 | i,j in N where i<j])
  /\
  forall([
   ((XZ[i,j] < minX[i] \/ XZ[i,j] > maxX[i]) \/ (YZ[i,j] < minY[i] \/ YZ[i,j] > maxY[i]))
   \/
   ((XZ[i,j] < minX[j] \/ XZ[i,j] > maxX[j]) \/ (YZ[i,j] < minY[j] \/ YZ[i,j] > maxY[j]))
  | i,j in N where 1<j-i /\ j-i<n-1]);


var int: S = abs(sum([C[i] | i in N]));


solve minimize S;


output 
["S = \(S)\n"] ++
["X = "] ++ ["(\(X[i]),\(Y[i]))," | i in N] ++ ["\n"];
