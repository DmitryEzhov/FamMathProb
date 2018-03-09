function model()
{
  n = 4; nn = n*n; s = 240;

  P = {3,5,7,11,13,17,19,23,29,31,37,41,43,47,53,59,61,67,71,73,79,83,89,97,101,103,107,109,113};
//  P = {3,5,7,11,13,17,19,23,29,31,37,41,43,47,53,59,61,67,71,73,79,83,89,97,101,103,107,109,113,127,131,137,139,149,151,157,163,167,173,179,181,191,193,197,199,211,223,227};

  L <- list(count(P));

  constraint count(L) == nn;

  for[k in 1..nn] { j= k%n; if (j==0) j= n; i= 1+round((k-j)/n); A[k]= i; B[k]= j; };

  C[i in 1..n][j in 1..n] = ((i+j-1)%n)==0 ? n : (i+j-1)%n;

  for[k in 1..nn] X[A[k]][B[k]] <- P[L[k-1]-1];

//  s <- sum[j in 1..n] (X[1][j]);
//  for[i in 2..n] constraint sum[j in 1..n] (X[i][j]) == s;

  for[i in 1..n] constraint sum[j in 1..n] (X[i][j]) == s;
  for[j in 1..n] constraint sum[i in 1..n] (X[i][j]) == s;

  for[i in 1..n] constraint sum[j in 1..n] (X[j][C[i][j]]) == s;
  for[i in 1..n] constraint sum[j in 1..n] (X[C[i][j]][n-j+1]) == s;

  minimize 1;
}


function param()
{
  if(lsNbThreads == nil) lsNbThreads=4;
  if(lsTimeLimit == nil) lsTimeLimit=1800;
  if(lsTimeBetweenDisplays == nil) lsTimeBetweenDisplays=10;
//  if(lsSeed == nil) lsSeed=4;
//  if(solFileName == nil) solFileName= "pdms.txt";
}


function output()
{
//  println(); println("s= ", getValue(s));
  for [i in 1..n][j in 1..n]
  {
    if (j==1) {print("(");};
    print(getValue(X[i][j]));
    if (j==n) {print("),");} else {print(",");};
  };
  println();
}


//(109,41,59,31),(53,37,103,47),(61,89,11,79),(17,73,67,83)
