/* file mymod.c */
#include <R.h>
static double parms[14];
#define b parms[0]
#define d parms[1]
#define R0 parms[2]
#define p1 parms[3]
#define p2 parms[4]
#define gamma parms[5]
#define eta parms[6]
#define r1 parms[7]
#define r2 parms[8]
#define f parms[9]
#define beta1 parms[10]
#define beta1p parms[11]
#define beta2 parms[12]
#define omega parms[13]

/* initializer */
void initmod(void (* odeparms)(int *, double *))
{
  int N=14;
  odeparms(&N, parms);
}

/* Derivatives and 1 output variable */
void derivs (int *neq, double *t, double *y, double *ydot, double *N)
{
  N[0] = y[0] + y[1] + y[2] + y[3] + y[4];
  ydot[0] = (1 - p1) * b + eta * y[3] + eta * y[4] - beta1 * y[0] / N[0] * y[1] - beta2 * y[0] / N[0] * y[2] - omega * y[0] - d * y[0];
  ydot[1] = beta1 * y[0] / N[0] * y[1] + beta1p * y[3] / N[0] * y[1] - gamma * y[1] - d * y[1];
  ydot[2] = beta2 * y[0] / N[0] * y[2] + beta2  * y[3] / N[0] * y[2] - gamma * y[2] - d * y[2];
  ydot[3] = p1 * b + omega * y[0] - beta1p * y[3] / N[0] * y[1] - beta2 * y[3] / N[0] * y[2] - eta * y[3] - d * y[3];
  ydot[4] = gamma * y[1] + gamma * y[2] - eta * y[4] - d * y[4];
}

/* END file mymod.c */

