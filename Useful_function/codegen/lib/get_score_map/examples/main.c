/*
 * File: main.c
 *
 * MATLAB Coder version            : 5.1
 * C/C++ source code generated on  : 08-Mar-2022 13:16:41
 */

/*************************************************************************/
/* This automatically generated example C main file shows how to call    */
/* entry-point functions that MATLAB Coder generated. You must customize */
/* this file for your application. Do not modify this file directly.     */
/* Instead, make a copy of this file, modify it, and integrate it into   */
/* your development environment.                                         */
/*                                                                       */
/* This file initializes entry-point function arguments to a default     */
/* size and value before calling the entry-point functions. It does      */
/* not store or use any values returned from the entry-point functions.  */
/* If necessary, it does pre-allocate memory for returned values.        */
/* You can use this file as a starting point for a main function that    */
/* you can deploy in your application.                                   */
/*                                                                       */
/* After you copy the file, and before you deploy it, you must make the  */
/* following changes:                                                    */
/* * For variable-size function arguments, change the example sizes to   */
/* the sizes that your application requires.                             */
/* * Change the example values of function arguments to the values that  */
/* your application requires.                                            */
/* * If the entry-point functions return values, store these values or   */
/* otherwise use them as required by your application.                   */
/*                                                                       */
/*************************************************************************/

/* Include Files */
#include "main.h"
#include "get_score_map.h"
#include "get_score_map_terminate.h"

/* Function Declarations */
static void argInit_1121x2_real32_T(float result[2242]);
static void argInit_80x120x2x2_real32_T(float result[38400]);
static float argInit_real32_T(void);
static void main_get_score_map(void);

/* Function Definitions */
/*
 * Arguments    : float result[2242]
 * Return Type  : void
 */
static void argInit_1121x2_real32_T(float result[2242])
{
  int idx0;
  int idx1;

  /* Loop over the array to initialize each element. */
  for (idx0 = 0; idx0 < 1121; idx0++) {
    for (idx1 = 0; idx1 < 2; idx1++) {
      /* Set the value of the array element.
         Change this value to the value that the application requires. */
      result[idx0 + 1121 * idx1] = argInit_real32_T();
    }
  }
}

/*
 * Arguments    : float result[38400]
 * Return Type  : void
 */
static void argInit_80x120x2x2_real32_T(float result[38400])
{
  int idx0;
  int idx1;
  int idx2;
  int idx3;

  /* Loop over the array to initialize each element. */
  for (idx0 = 0; idx0 < 80; idx0++) {
    for (idx1 = 0; idx1 < 120; idx1++) {
      for (idx2 = 0; idx2 < 2; idx2++) {
        for (idx3 = 0; idx3 < 2; idx3++) {
          /* Set the value of the array element.
             Change this value to the value that the application requires. */
          result[((idx0 + 80 * idx1) + 9600 * idx2) + 19200 * idx3] =
            argInit_real32_T();
        }
      }
    }
  }
}

/*
 * Arguments    : void
 * Return Type  : float
 */
static float argInit_real32_T(void)
{
  return 0.0F;
}

/*
 * Arguments    : void
 * Return Type  : void
 */
static void main_get_score_map(void)
{
  static float fv[38400];
  float St[9600];
  float fv1[2242];

  /* Initialize function 'get_score_map' input arguments. */
  /* Initialize function input argument 'bins'. */
  /* Initialize function input argument 'amp_radar'. */
  /* Call the entry-point 'get_score_map'. */
  argInit_80x120x2x2_real32_T(fv);
  argInit_1121x2_real32_T(fv1);
  get_score_map(fv, fv1, St);
}

/*
 * Arguments    : int argc
 *                const char * const argv[]
 * Return Type  : int
 */
int main(int argc, const char * const argv[])
{
  (void)argc;
  (void)argv;

  /* The initialize function is being called automatically from your entry-point function. So, a call to initialize is not included here. */
  /* Invoke the entry-point functions.
     You can call entry-point functions multiple times. */
  main_get_score_map();

  /* Terminate the application.
     You do not need to do this more than one time. */
  get_score_map_terminate();
  return 0;
}

/*
 * File trailer for main.c
 *
 * [EOF]
 */
