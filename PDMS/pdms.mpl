param n := 5; set N := 1..n;

param nn := n*n; param s := 397;

set Z := {3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47, 53, 59, 61, 67, 71, 73, 79, 83, 89, 97, 101, 103, 107, 109, 113, 127, 131, 137, 139, 149, 151, 157, 163, 167, 173, 179, 181, 191, 193, 197, 199, 211, 223, 227, 229, 233, 239, 241, 251, 257, 263, 269, 271, 277, 281, 283, 293, 307, 311, 313, 317, 331, 337, 347, 349, 353, 359, 367, 373, 379, 383, 389, 397, 401, 409, 419, 421, 431, 433, 439, 443, 449, 457, 461, 463, 467, 479, 487, 491, 499, 503, 509, 521, 523, 541, 547, 557, 563, 569, 571, 577, 587, 593, 599, 601, 607, 613, 617, 619, 631, 641, 643, 647, 653, 659, 661, 673, 677, 683, 691, 701, 709, 719, 727, 733, 739, 743, 751, 757, 761, 769, 773, 787, 797, 809, 811, 821, 823, 827, 829, 839, 853, 857, 859, 863, 877, 881, 883, 887, 907, 911, 919, 929, 937, 941, 947, 953, 967, 971, 977, 983, 991, 997, 1009, 1013, 1019, 1021, 1031, 1033, 1039, 1049, 1051, 1061, 1063, 1069, 1087, 1091, 1093, 1097, 1103, 1109, 1117, 1123, 1129, 1151, 1153, 1163, 1171, 1181, 1187, 1193, 1201, 1213, 1217, 1223, 1229, 1231, 1237, 1249, 1259, 1277, 1279, 1283, 1289, 1291, 1297, 1301, 1303, 1307, 1319, 1321, 1327, 1361, 1367, 1373, 1381, 1399, 1409, 1423, 1427, 1429, 1433, 1439, 1447, 1451, 1453, 1459, 1471, 1481, 1483, 1487, 1489, 1493, 1499, 1511};
set P ordered := {p in Z : p <= 227};
set K := 1..card(P);
param Q {k in K} := member(k, P);

param A {i in N, j in N} := if ((i+j-1) mod n)==0 then n else (i+j-1) mod n;


var X {N, N, K} binary;


subject to st1 {i in N, j in N} : sum {k in K} (X[i,j,k]) == 1;

subject to st2 {k in K} : sum {i in N, j in N} (X[i,j,k]) <= 1;

subject to st3 : sum {i in N, j in N, k in K} (X[i,j,k]) == nn;

subject to st4 {i in N} : sum {j in N, k in K} (X[i,j,k] * Q[k]) == s;

subject to st5 {j in N} : sum {i in N, k in K} (X[i,j,k] * Q[k]) == s;

subject to st6 {i in N} : sum {j in N, k in K} (X[j, A[i,j], k] * Q[k]) == s;

subject to st7 {i in N} : sum {j in N, k in K} (X[A[i,j], n-j+1, k] * Q[k]) == s;


#option solver locsol;
#option locsol_options 'version verbosity=normal threads=4 timing=1 time_between_displays=10 timelimit=600000';

#option solver ilogcp;
#option ilogcp_options 'version timing=1 timelimit=30000 logperiod=10000 outlev=verbose mipdisplay=2 mipinterval=10000';

#option solver cplex;
#option cplex_options 'version timing=1 threads=4 display=1 mipdisplay=4 mipinterval=10000';

#option solver knitro;
#option knitro_options 'version timing=1 threads=4 outlev=2 mip_outinterval=1000';

option solver gurobi;
option gurobi_options 'version logfreq=10 outlev=1 timing=1';

#option solver mosek;
#option mosek_options 'outlev=3';


solve;


printf ("\nS = " & s & "\n");
printf {i in N, j in N} (sum {k in K} (X[i,j,k] * Q[k]) & (if j < n then "," else (if i<n then "; " else "\n")));
