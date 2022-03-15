/*
 * File: _coder_get_score_map_api.h
 *
 * MATLAB Coder version            : 5.1
 * C/C++ source code generated on  : 08-Mar-2022 13:16:41
 */

#ifndef _CODER_GET_SCORE_MAP_API_H
#define _CODER_GET_SCORE_MAP_API_H

/* Include Files */
#include "emlrt.h"
#include "tmwtypes.h"
#include <string.h>

/* Variable Declarations */
extern emlrtCTX emlrtRootTLSGlobal;
extern emlrtContext emlrtContextGlobal;

#ifdef __cplusplus

extern "C" {

#endif

  /* Function Declarations */
  void get_score_map(real32_T bins[38400], real32_T amp_radar[2242], real32_T
                     St[9600]);
  void get_score_map_api(const mxArray * const prhs[2], const mxArray *plhs[1]);
  void get_score_map_atexit(void);
  void get_score_map_initialize(void);
  void get_score_map_terminate(void);
  void get_score_map_xil_shutdown(void);
  void get_score_map_xil_terminate(void);

#ifdef __cplusplus

}
#endif
#endif

/*
 * File trailer for _coder_get_score_map_api.h
 *
 * [EOF]
 */
