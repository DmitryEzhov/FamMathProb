function model()
{
  n = 11;

  Z[1..n][1..n][1..n] <- bool();

  X[i in 1..n] <- sum[x in 1..n][y in 1..n] (Z[x][y][i] ? x : 0);

  Y[i in 1..n] <- sum[x in 1..n][y in 1..n] (Z[x][y][i] ? y : 0);


  A[i in 1..n] <- Y[i] - Y[i%n+1];

  B[i in 1..n] <- X[i%n+1] - X[i];

  C[i in 1..n] <- X[i]*Y[i%n+1] - X[i%n+1]*Y[i];

  D[i in 1..n][j in 1..n : i < j] <- A[i]*B[j] - A[j]*B[i];

  XZ[i in 1..n][j in 1..n : i < j] <- (B[i]*C[j] - B[j]*C[i])/D[i][j];

  YZ[i in 1..n][j in 1..n : i < j] <- (A[j]*C[i] - A[i]*C[j])/D[i][j];

  minX[i in 1..n] <- min(X[i], X[i%n+1]); maxX[i in 1..n] <- max(X[i], X[i%n+1]);

  minY[i in 1..n] <- min(Y[i], Y[i%n+1]); maxY[i in 1..n] <- max(Y[i], Y[i%n+1]);


  for[x in 1..n] constraint sum[y in 1..n][i in 1..n](Z[x][y][i]) == 1;
  for[y in 1..n] constraint sum[i in 1..n][x in 1..n](Z[x][y][i]) == 1;
  for[i in 1..n] constraint sum[x in 1..n][y in 1..n](Z[x][y][i]) == 1;


  for[i in 1..n][j in 1..n : i < j] constraint D[i][j] != 0;

  for[i in 1..n][j in 1..n : 1 < j-i && j-i < n-1] constraint 
   ((XZ[i][j] < minX[i] || XZ[i][j] > maxX[i]) || (YZ[i][j] < minY[i] || YZ[i][j] > maxY[i]))
   ||
   ((XZ[i][j] < minX[j] || XZ[i][j] > maxX[j]) || (YZ[i][j] < minY[j] || YZ[i][j] > maxY[j]));


  minimize abs(sum[i in 1..n](C[i]));
}


function output()
{
//  solFile = openAppend(solFileName);

  println();
  for[i in 1..n]
  {
    print("(",getValue(X[i]),",",getValue(Y[i]),"),");
  };
  println();
  print("["); for[i in 1..n] {print(getValue(X[i]),",");}; print("]");
  print("["); for[i in 1..n] {print(getValue(Y[i]),",");}; print("]");

}


function param()
{
  if(lsTimeLimit == nil) lsTimeLimit=300;
  if(lsTimeBetweenDisplays == nil) lsTimeBetweenDisplays=10;
  if(lsNbThreads == nil) lsNbThreads=3;
//  if(lsSeed == nil) lsSeed=4;
}
