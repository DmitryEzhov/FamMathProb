/*
use random;
  rd = random.create();
  r = rd.next(1, 3); X[1] <- r; if (r==1) X[2] = 2; else X[2] = 1;
  r = rd.next(0, 2); X[3] <- n-r; if (r==1) X[4] = n; else X[4] = n-1;
  r = rd.next(0, 2); X[n] <- n-2; if (r==1) X[4] = n-1; else X[4] = n;
  r = rd.next(1, 3); Y[1] <- r; if (r==1) Y[4] = 2; else Y[4] = 1;
  r = rd.next(0, 2); Y[3] <- n-r; if (r==1) Y[2] = n; else Y[2] = n-1;
*/

function model()
{
  n = 16; N = 27;

// 5 (2,3)(3,2) 447 {2,3},{3,2},{16,1},{17,16},{1,17}
// 6 (2,3)(3,2) 446 {2,3},{3,2},{16,1},{17,15},{14,17},{1,16}
// 5 (1,3)(3,2) 449 {1,3},{3,2},{16,1},{17,16},{2,17}
// 6 (1,3)(3,1) 447 {1,3},{3,2},{16,1},{17,15},{15,17},{2,16}

//  X[1..n] <- int(1,n); Y[1..n] <- int(1,n);

  X[1..n] <- int(1,N); Y[1..n] <- int(1,N);

//  X[1..n] <- int(1,17); Y[1..n] <- int(1,17);
//  X[1] <- 1; Y[1] <- 3;
//  X[2] <- 3; Y[2] <- 2;

/*
  x[1..10] <- int(6,n-2); y[1..10] <- int(3,n-5);

  X[1] <- 1; Y[1] <- 2; X[2] <- n-1; Y[2] <- 1; X[3] <- n; Y[3] <- n-1; X[4] <- 3; Y[4] <- n; X[n] <- 2; Y[n] <- n-2;

  X[5] <- 4; Y[5] <- n-3; X[n-1] <- 5; Y[n-1] <- n-4;

  X[i in 5..n-1] <- x[i-4]; Y[i in 5..n-1] <- y[i-4];
  X[i in 6..n-2] <- x[i-5]; Y[i in 6..n-2] <- y[i-5];
*/

  A[i in 1..n] <- Y[i] - Y[i%n+1];

  B[i in 1..n] <- X[i%n+1] - X[i];

  C[i in 1..n] <- X[i]*Y[i%n+1] - X[i%n+1]*Y[i];

  D[i in 1..n][j in 1..n : i < j] <- A[i]*B[j] - A[j]*B[i];

  XZ[i in 1..n][j in 1..n : i < j] <- (B[i]*C[j] - B[j]*C[i])/D[i][j];

  YZ[i in 1..n][j in 1..n : i < j] <- (A[j]*C[i] - A[i]*C[j])/D[i][j];

  minX[i in 1..n] <- min(X[i], X[i%n+1]); maxX[i in 1..n] <- max(X[i], X[i%n+1]);

  minY[i in 1..n] <- min(Y[i], Y[i%n+1]); maxY[i in 1..n] <- max(Y[i], Y[i%n+1]);


  for[i in 1..n][j in 1..n : i < j] constraint X[i] != X[j] && Y[i] != Y[j] && D[i][j] != 0;

  for[i in 1..n][j in 1..n : 1 < j-i && j-i < n-1] constraint 
   ((XZ[i][j] < minX[i] || XZ[i][j] > maxX[i]) || (YZ[i][j] < minY[i] || YZ[i][j] > maxY[i]))
   ||
   ((XZ[i][j] < minX[j] || XZ[i][j] > maxX[j]) || (YZ[i][j] < minY[j] || YZ[i][j] > maxY[j]));


  maximize abs(sum[i in 1..n](C[i]));
}


function output()
{
//  solFile = openAppend(solFileName);

  println(); for[i in 1..n] print("(",getValue(X[i]),",",getValue(Y[i]),"),");
  println(); for[i in 1..n] print("{",getValue(X[i]),",",getValue(Y[i]),"},");
}


function param()
{
  if(lsTimeLimit == nil) lsTimeLimit=40;
  if(lsTimeBetweenDisplays == nil) lsTimeBetweenDisplays=10;
  if(lsNbThreads == nil) lsNbThreads=3;
//  if(lsSeed == nil) lsSeed=2;
}
