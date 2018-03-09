param n := 7; set N := 1..n;

param k := round(n*(n-1)/2); set K := 1..k;

set Z ordered := {2,3,5,7,11,13,17,19,23,29,31,37,41,43,47,53,59,61,67,71,73,79,83,89,97,101,103,107,109,113,127,131,137,139,149,151,157,163,167,173,179,181,191,193,197,199,211,223,227,229,233,239,241,251,257,263,269,271,277,281,283,293,307,311,313,317,331,337,347,349,353,359,367,373,379,383,389,397,401,409,419,421,431,433,439,443,449,457,461,463,467,479,487,491,499,503,509,521,523,541,547,557,563,569,571,577,587,593,599,601,607,613,617,619,631,641,643,647,653,659,661,673,677,683,691,701,709,719,727,733,739,743,751,757,761,769,773,787,797,809,811,821,823,827,829,839,853,857,859,863,877,881,883,887,907,911,919,929,937,941,947,953,967,971,977,983,991,997,1009,1013,1019,1021,1031,1033,1039,1049,1051,1061,1063,1069,1087,1091,1093,1097,1103,1109,1117,1123,1129,1151,1153,1163,1171,1181,1187,1193,1201,1213,1217,1223,1229,1231,1237,1249,1259,1277,1279,1283,1289,1291,1297,1301,1303,1307,1319,1321,1327,1361,1367,1373,1381,1399,1409,1423,1427,1429,1433,1439,1447,1451,1453,1459,1471,1481,1483,1487,1489,1493,1499,1511,1523,1531,1543,1549,1553,1559,1567,1571,1579,1583,1597,1601,1607,1609,1613,1619,1621,1627,1637,1657,1663,1667,1669,1693,1697,1699,1709,1721,1723,1733,1741,1747,1753,1759,1777,1783,1787,1789,1801,1811,1823,1831,1847,1861,1867,1871,1873,1877,1879,1889,1901,1907,1913,1931,1933,1949,1951,1973,1979,1987};

param P {i in K} := member(i, Z);

param e := ceil(n * prod {i in K} (P[i]^(2/n)));

param T {i in N, j in N} :=

  if i==j then 1
    else
    (
      if i<j && j>1
        then j-i+round((i-1)*(2*n-i)/2)
        else i-j+round((j-1)*(2*n-j)/2)
    );


var B {K, K} binary;

var A {i in K} = sum {j in K} (P[j]*B[i,j]);

var X {i in N, j in N} =

  if i==j then 1
    else
    (
      if i<j && j>1 then A[T[i,j]] else A[T[j,i]]
    );


subject to st1 {i in K} : sum {j in K} (B[i,j]) == 1;

subject to st2 {j in K} : sum {i in K} (B[i,j]) == 1;


minimize s: sum {i in N} (prod {j in N} (X[i,j])) - e;




#option solver locsol;
#option locsol_options 'verbosity=normal threads=4 timing=1 time_between_displays=10 timelimit=600000';

option solver ilogcp;
option ilogcp_options 'timing=1 timelimit=1800 outlev=terse';# logperiod=100000 mipdisplay=2 mipinterval=100000';

#option solver cplex;
#option cplex_options 'timing=1 threads=4 display=1 mipdisplay=4 mipinterval=10000';

#option solver knitro;
#option knitro_options 'timing=1 threads=3 outlev=2 multistart=1 ms_maxtime_real=60';
# mip_outinterval=10 mip_outlevel=1

#option solver gurobi;
#option gurobi_options 'logfreq=10 outlev=1 timing=1';

#option solver mosek;
#option mosek_options 'outlev=3';

#option solver xpress;
#option xpress_options 'timing threads=4 outlev=1 miplog=-10000';

#option solver bonmin;


solve;


printf ("\nS = " & s & "\n");
printf {i in N, j in N} ((if j==1 then "{" else "") & (X[i,j]) & (if j < n then "," else (if i<n then "}," else "}\n")));
