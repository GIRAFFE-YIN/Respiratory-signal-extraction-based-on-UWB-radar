/*
 * _coder_get_score_map_mex.c
 *
 * Code generation for function '_coder_get_score_map_mex'
 *
 */

/* Include files */
#include "_coder_get_score_map_mex.h"
#include "_coder_get_score_map_api.h"
#include "get_score_map_data.h"
#include "get_score_map_initialize.h"
#include "get_score_map_terminate.h"
#include "rt_nonfinite.h"

/* Function Definitions */
void get_score_map_mexFunction(int32_T nlhs, mxArray *plhs[1], int32_T nrhs,
  const mxArray *prhs[2])
{
  emlrtStack st = { NULL,              /* site */
    NULL,                              /* tls */
    NULL                               /* prev */
  };

  const mxArray *outputs[1];
  st.tls = emlrtRootTLSGlobal;

  /* Check for proper number of arguments. */
  if (nrhs != 2) {
    emlrtErrMsgIdAndTxt(&st, "EMLRT:runTime:WrongNumberOfInputs", 5, 12, 2, 4,
                        13, "get_score_map");
  }

  if (nlhs > 1) {
    emlrtErrMsgIdAndTxt(&st, "EMLRT:runTime:TooManyOutputArguments", 3, 4, 13,
                        "get_score_map");
  }

  /* Call the function. */
  get_score_map_api(prhs, outputs);

  /* Copy over outputs to the caller. */
  emlrtReturnArrays(1, plhs, outputs);
}

void mexFunction(int32_T nlhs, mxArray *plhs[], int32_T nrhs, const mxArray
                 *prhs[])
{
  mexAtExit(&get_score_map_atexit);

  /* Module initialization. */
  get_score_map_initialize();

  /* Dispatch the entry-point. */
  get_score_map_mexFunction(nlhs, plhs, nrhs, prhs);

  /* Module termination. */
  get_score_map_terminate();
}

emlrtCTX mexFunctionCreateRootTLS(void)
{
  emlrtCreateRootTLS(&emlrtRootTLSGlobal, &emlrtContextGlobal, NULL, 1);
  return emlrtRootTLSGlobal;
}

/* End of code generation (_coder_get_score_map_mex.c) */
