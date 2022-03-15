/*
 * _coder_get_score_map_api.c
 *
 * Code generation for function '_coder_get_score_map_api'
 *
 */

/* Include files */
#include "_coder_get_score_map_api.h"
#include "get_score_map.h"
#include "get_score_map_data.h"
#include "rt_nonfinite.h"

/* Function Declarations */
static void b_emlrt_marshallIn(const emlrtStack *sp, const mxArray *u, const
  emlrtMsgIdentifier *parentId, real32_T y[11616]);
static void c_emlrt_marshallIn(const emlrtStack *sp, const mxArray *amp_radar,
  const char_T *identifier, real32_T y[2242]);
static void d_emlrt_marshallIn(const emlrtStack *sp, const mxArray *u, const
  emlrtMsgIdentifier *parentId, real32_T y[2242]);
static void e_emlrt_marshallIn(const emlrtStack *sp, const mxArray *src, const
  emlrtMsgIdentifier *msgId, real32_T ret[11616]);
static void emlrt_marshallIn(const emlrtStack *sp, const mxArray *bins, const
  char_T *identifier, real32_T y[11616]);
static const mxArray *emlrt_marshallOut(const real32_T u[2904]);
static void f_emlrt_marshallIn(const emlrtStack *sp, const mxArray *src, const
  emlrtMsgIdentifier *msgId, real32_T ret[2242]);

/* Function Definitions */
static void b_emlrt_marshallIn(const emlrtStack *sp, const mxArray *u, const
  emlrtMsgIdentifier *parentId, real32_T y[11616])
{
  e_emlrt_marshallIn(sp, emlrtAlias(u), parentId, y);
  emlrtDestroyArray(&u);
}

static void c_emlrt_marshallIn(const emlrtStack *sp, const mxArray *amp_radar,
  const char_T *identifier, real32_T y[2242])
{
  emlrtMsgIdentifier thisId;
  thisId.fIdentifier = (const char_T *)identifier;
  thisId.fParent = NULL;
  thisId.bParentIsCell = false;
  d_emlrt_marshallIn(sp, emlrtAlias(amp_radar), &thisId, y);
  emlrtDestroyArray(&amp_radar);
}

static void d_emlrt_marshallIn(const emlrtStack *sp, const mxArray *u, const
  emlrtMsgIdentifier *parentId, real32_T y[2242])
{
  f_emlrt_marshallIn(sp, emlrtAlias(u), parentId, y);
  emlrtDestroyArray(&u);
}

static void e_emlrt_marshallIn(const emlrtStack *sp, const mxArray *src, const
  emlrtMsgIdentifier *msgId, real32_T ret[11616])
{
  static const int32_T dims[4] = { 44, 66, 2, 2 };

  emlrtCheckBuiltInR2012b(sp, msgId, src, "single|double", false, 4U, dims);
  emlrtImportArrayR2015b(sp, src, ret, 4, false);
  emlrtDestroyArray(&src);
}

static void emlrt_marshallIn(const emlrtStack *sp, const mxArray *bins, const
  char_T *identifier, real32_T y[11616])
{
  emlrtMsgIdentifier thisId;
  thisId.fIdentifier = (const char_T *)identifier;
  thisId.fParent = NULL;
  thisId.bParentIsCell = false;
  b_emlrt_marshallIn(sp, emlrtAlias(bins), &thisId, y);
  emlrtDestroyArray(&bins);
}

static const mxArray *emlrt_marshallOut(const real32_T u[2904])
{
  static const int32_T iv[2] = { 44, 66 };

  const mxArray *m;
  const mxArray *y;
  int32_T b_i;
  int32_T c_i;
  int32_T i;
  real32_T *pData;
  y = NULL;
  m = emlrtCreateNumericArray(2, &iv[0], mxSINGLE_CLASS, mxREAL);
  pData = (real32_T *)emlrtMxGetData(m);
  i = 0;
  for (b_i = 0; b_i < 66; b_i++) {
    for (c_i = 0; c_i < 44; c_i++) {
      pData[i] = u[c_i + 44 * b_i];
      i++;
    }
  }

  emlrtAssign(&y, m);
  return y;
}

static void f_emlrt_marshallIn(const emlrtStack *sp, const mxArray *src, const
  emlrtMsgIdentifier *msgId, real32_T ret[2242])
{
  static const int32_T dims[2] = { 1121, 2 };

  emlrtCheckBuiltInR2012b(sp, msgId, src, "single|double", false, 2U, dims);
  emlrtImportArrayR2015b(sp, src, ret, 4, false);
  emlrtDestroyArray(&src);
}

void get_score_map_api(const mxArray * const prhs[2], const mxArray *plhs[1])
{
  emlrtStack st = { NULL,              /* site */
    NULL,                              /* tls */
    NULL                               /* prev */
  };

  real32_T bins[11616];
  real32_T St[2904];
  real32_T amp_radar[2242];
  st.tls = emlrtRootTLSGlobal;

  /* Marshall function inputs */
  emlrt_marshallIn(&st, emlrtAliasP(prhs[0]), "bins", bins);
  c_emlrt_marshallIn(&st, emlrtAliasP(prhs[1]), "amp_radar", amp_radar);

  /* Invoke the target function */
  get_score_map(&st, bins, amp_radar, St);

  /* Marshall function outputs */
  plhs[0] = emlrt_marshallOut(St);
}

/* End of code generation (_coder_get_score_map_api.c) */
