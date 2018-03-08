function model()
{
n = 4;
N = n*n;
x[1..n][1..n] <- int(7,113);
P = {7,13,17,23,31,37,41,47,73,79,83,89,97,103,107,113};
//P = {5,7,11,13,23,17,31,37,41,43,53,67,71,73,83,97,101,103,113,127,131,137,167,197,227};

for[i in 1..N] { ja= i%n; if (ja==0) ja= n; ia= 1+round((i-ja)/n); A[i]= ia; B[i]= ja; };
for[i in 1..N][j in 1..N : i < j] constraint x[A[i]][B[i]] != x[A[j]][B[j]];
for[i in 1..n][j in 1..n] constraint sum[k in 0..N-1] (x[i][j]==P[k]) == 1;

S <- sum[j in 1..n] (x[1][j]);

for[i in 2..n] constraint sum[j in 1..n] (x[i][j]) == S;
for[j in 1..n] constraint sum[i in 1..n] (x[i][j]) == S;

for[i in 1..n] constraint sum[j in 1..n] (x[j][((i+j-1)%n)==0 ? n : (i+j-1)%n]) == S;
for[i in 1..n] constraint sum[j in 1..n] (x[((i+j-1)%n)==0 ? n : (i+j-1)%n][n-j+1]) == S;

//        for(i=1, n, S= 0; for(j=1, n, k=(i+j-1)%n; if(!k, k=n); S= S+b[j,k]); if(abs(S)>0, e= 0));
//        for(i=1, n, S= 0; for(j=1, n, k=(i+j-1)%n; if(!k, k=n); S= S+b[k,(-j)%n+1]); if(abs(S)>0, e= 0));

minimize S;
}


function param()
{
  if(lsTimeLimit == nil) lsTimeLimit=600;
  if(lsTimeBetweenDisplays == nil) lsTimeBetweenDisplays=10;
//  if(lsSeed == nil) lsSeed=4;
  if(lsNbThreads == nil) lsNbThreads=4;
//  if(solFileName == nil) solFileName= "dlc2.txt";
}


function output()
{
  for [i in 1..n][j in 1..n]
  {
    if (j==1) {print("(");};
    print(getValue(x[i][j]));
    if (j==n) {print("),");} else {print(",");};
  };
}
