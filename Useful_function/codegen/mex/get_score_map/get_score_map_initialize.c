/*
 * get_score_map_initialize.c
 *
 * Code generation for function 'get_score_map_initialize'
 *
 */

/* Include files */
#include "get_score_map_initialize.h"
#include "_coder_get_score_map_mex.h"
#include "get_score_map_data.h"
#include "rt_nonfinite.h"

/* Function Definitions */
void get_score_map_initialize(void)
{
  emlrtStack st = { NULL,              /* site */
    NULL,                              /* tls */
    NULL                               /* prev */
  };

  mex_InitInfAndNan();
  mexFunctionCreateRootTLS();
  emlrtBreakCheckR2012bFlagVar = emlrtGetBreakCheckFlagAddressR2012b();
  st.tls = emlrtRootTLSGlobal;
  emlrtClearAllocCountR2012b(&st, false, 0U, 0);
  emlrtEnterRtStackR2012b(&st);
  emlrtFirstTimeR2012b(emlrtRootTLSGlobal);
}

/* End of code generation (get_score_map_initialize.c) */
