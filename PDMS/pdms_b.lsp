function model()
{
  n = 4; nn = n*n;
  P = {3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47, 53, 59, 61, 67, 71, 73, 79, 83, 89, 97, 101, 103, 107, 109, 113};
  q = count(P);
  Q[k in 1..q] = P[k-1];

  A[i in 1..n][j in 1..n] = ((i+j-1)%n)==0 ? n : (i+j-1)%n;

  X[1..n][1..n][1..q] <- bool();


  for[i in 1..n][j in 1..n] constraint sum[k in 1..q] (X[i][j][k]) == 1;

  for[k in 1..q] constraint sum[i in 1..n][j in 1..n] (X[i][j][k]) <= 1;

  constraint sum[i in 1..n][j in 1..n][k in 1..q] (X[i][j][k]) == nn;

  s <- sum[j in 1..n][k in 1..q] (X[1][j][k] * Q[k]);

  for[i in 2..n] constraint sum[j in 1..n][k in 1..q] (X[i][j][k] * Q[k]) == s;

  for[j in 1..n] constraint sum[i in 1..n][k in 1..q] (X[i][j][k] * Q[k]) == s;

  for[i in 1..n] constraint sum[j in 1..n][k in 1..q] (X[j][A[i][j]][k] * Q[k]) == s;

  for[i in 1..n] constraint sum[j in 1..n][k in 1..q] (X[A[i][j]][n-j+1][k] * Q[k]) == s;


  minimize s;
}


function param()
{
  if(lsNbThreads == nil) lsNbThreads=4;
  if(lsTimeLimit == nil) lsTimeLimit=600;
  if(lsTimeBetweenDisplays == nil) lsTimeBetweenDisplays=10;
//  if(lsSeed == nil) lsSeed=4;
//  if(solFileName == nil) solFileName= "pdms.txt";
}


function output()
{
  for [i in 1..n][j in 1..n]
  {
    if (j==1) {print("(");};
    print(sum[k in 1..q] (getValue(X[i][j][k]) * Q[k]));
    if (j==n) {print("),");} else {print(",");};
  };
}
