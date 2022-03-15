/*
 * get_score_map_terminate.c
 *
 * Code generation for function 'get_score_map_terminate'
 *
 */

/* Include files */
#include "get_score_map_terminate.h"
#include "_coder_get_score_map_mex.h"
#include "get_score_map_data.h"
#include "rt_nonfinite.h"

/* Function Definitions */
void get_score_map_atexit(void)
{
  emlrtStack st = { NULL,              /* site */
    NULL,                              /* tls */
    NULL                               /* prev */
  };

  mexFunctionCreateRootTLS();
  st.tls = emlrtRootTLSGlobal;
  emlrtEnterRtStackR2012b(&st);
  emlrtLeaveRtStackR2012b(&st);
  emlrtDestroyRootTLS(&emlrtRootTLSGlobal);
  emlrtExitTimeCleanup(&emlrtContextGlobal);
}

void get_score_map_terminate(void)
{
  emlrtStack st = { NULL,              /* site */
    NULL,                              /* tls */
    NULL                               /* prev */
  };

  st.tls = emlrtRootTLSGlobal;
  emlrtLeaveRtStackR2012b(&st);
  emlrtDestroyRootTLS(&emlrtRootTLSGlobal);
}

/* End of code generation (get_score_map_terminate.c) */
