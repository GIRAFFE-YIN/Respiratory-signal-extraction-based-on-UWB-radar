/*
 * get_score_map.c
 *
 * Code generation for function 'get_score_map'
 *
 */

/* Include files */
#include "get_score_map.h"
#include "get_score_map_data.h"
#include "rt_nonfinite.h"
#include "mwmathutil.h"

/* Variable Definitions */
static emlrtBCInfo emlrtBCI = { 1,     /* iFirst */
  1121,                                /* iLast */
  20,                                  /* lineNo */
  51,                                  /* colNo */
  "amp_radar",                         /* aName */
  "get_score_map",                     /* fName */
  "D:\\OneDrive - Imperial College London\\IC\\PhD_breath\\Useful_function\\get_score_map.m",/* pName */
  0                                    /* checkKind */
};

static emlrtDCInfo emlrtDCI = { 20,    /* lineNo */
  51,                                  /* colNo */
  "get_score_map",                     /* fName */
  "D:\\OneDrive - Imperial College London\\IC\\PhD_breath\\Useful_function\\get_score_map.m",/* pName */
  1                                    /* checkKind */
};

static emlrtBCInfo b_emlrtBCI = { 1,   /* iFirst */
  1121,                                /* iLast */
  20,                                  /* lineNo */
  72,                                  /* colNo */
  "amp_radar",                         /* aName */
  "get_score_map",                     /* fName */
  "D:\\OneDrive - Imperial College London\\IC\\PhD_breath\\Useful_function\\get_score_map.m",/* pName */
  0                                    /* checkKind */
};

static emlrtDCInfo b_emlrtDCI = { 20,  /* lineNo */
  72,                                  /* colNo */
  "get_score_map",                     /* fName */
  "D:\\OneDrive - Imperial College London\\IC\\PhD_breath\\Useful_function\\get_score_map.m",/* pName */
  1                                    /* checkKind */
};

/* Function Definitions */
void get_score_map(const emlrtStack *sp, const real32_T bins[11616], const
                   real32_T amp_radar[2242], real32_T St[2904])
{
  int32_T firstBlockLength;
  int32_T hi;
  int32_T i;
  int32_T i1;
  int32_T i2;
  int32_T ib;
  int32_T ix;
  int32_T iy;
  int32_T k;
  int32_T lastBlockLength;
  int32_T nblocks;
  real32_T Max_vote_idx_0;
  real32_T Max_vote_idx_1;
  real32_T bsum;

  /* GET_SCORE_MAP Summary of this function goes here */
  /*    Detailed explanation goes here */
  for (ix = 0; ix < 44; ix++) {
    for (iy = 0; iy < 66; iy++) {
      /*              Max_vote(ixy,iradar) = mean(amp_radar(bins(ixy,iradar,2):bins(ixy,iradar,1),iradar)); */
      /*               */
      /*  If there is no range bin cross that block */
      i = ix + 44 * iy;
      Max_vote_idx_1 = bins[i];
      bsum = bins[i + 5808];
      if (Max_vote_idx_1 + bsum == 0.0F) {
        Max_vote_idx_0 = 1.0F;

        /*  Set the vote value to 1 */
      } else {
        if (bsum > Max_vote_idx_1) {
          i1 = -1;
          i2 = -1;
        } else {
          if ((real_T)bsum != (int32_T)muDoubleScalarFloor(bsum)) {
            emlrtIntegerCheckR2012b(bsum, &emlrtDCI, sp);
          }

          if (((int32_T)bsum < 1) || ((int32_T)bsum > 1121)) {
            emlrtDynamicBoundsCheckR2012b((int32_T)bsum, 1, 1121, &emlrtBCI, sp);
          }

          i1 = (int32_T)bsum - 2;
          if ((real_T)Max_vote_idx_1 != (int32_T)muDoubleScalarFloor
              (Max_vote_idx_1)) {
            emlrtIntegerCheckR2012b(Max_vote_idx_1, &b_emlrtDCI, sp);
          }

          if (((int32_T)Max_vote_idx_1 < 1) || ((int32_T)Max_vote_idx_1 > 1121))
          {
            emlrtDynamicBoundsCheckR2012b((int32_T)Max_vote_idx_1, 1, 1121,
              &b_emlrtBCI, sp);
          }

          i2 = (int32_T)Max_vote_idx_1 - 1;
        }

        i2 -= i1;
        if (i2 == 0) {
          Max_vote_idx_1 = 0.0F;
        } else {
          if (i2 <= 1024) {
            firstBlockLength = i2;
            lastBlockLength = 0;
            nblocks = 1;
          } else {
            firstBlockLength = 1024;
            nblocks = i2 / 1024;
            lastBlockLength = i2 - (nblocks << 10);
            if (lastBlockLength > 0) {
              nblocks++;
            } else {
              lastBlockLength = 1024;
            }
          }

          Max_vote_idx_1 = amp_radar[i1 + 1];
          for (k = 2; k <= firstBlockLength; k++) {
            Max_vote_idx_1 += amp_radar[i1 + k];
          }

          for (ib = 2; ib <= nblocks; ib++) {
            firstBlockLength = i1 + ((ib - 1) << 10);
            bsum = amp_radar[firstBlockLength + 1];
            if (ib == nblocks) {
              hi = lastBlockLength;
            } else {
              hi = 1024;
            }

            for (k = 2; k <= hi; k++) {
              bsum += amp_radar[firstBlockLength + k];
            }

            Max_vote_idx_1 += bsum;
          }
        }

        Max_vote_idx_0 = Max_vote_idx_1 / (real32_T)i2;
      }

      if (*emlrtBreakCheckR2012bFlagVar != 0) {
        emlrtBreakCheckR2012b(sp);
      }

      /*              Max_vote(ixy,iradar) = mean(amp_radar(bins(ixy,iradar,2):bins(ixy,iradar,1),iradar)); */
      /*               */
      /*  If there is no range bin cross that block */
      Max_vote_idx_1 = bins[i + 2904];
      bsum = bins[i + 8712];
      if (Max_vote_idx_1 + bsum == 0.0F) {
        Max_vote_idx_1 = 1.0F;

        /*  Set the vote value to 1 */
      } else {
        if (bsum > Max_vote_idx_1) {
          i1 = -1;
          i2 = -1;
        } else {
          if ((real_T)bsum != (int32_T)muDoubleScalarFloor(bsum)) {
            emlrtIntegerCheckR2012b(bsum, &emlrtDCI, sp);
          }

          if (((int32_T)bsum < 1) || ((int32_T)bsum > 1121)) {
            emlrtDynamicBoundsCheckR2012b((int32_T)bsum, 1, 1121, &emlrtBCI, sp);
          }

          i1 = (int32_T)bsum - 2;
          if ((real_T)Max_vote_idx_1 != (int32_T)muDoubleScalarFloor
              (Max_vote_idx_1)) {
            emlrtIntegerCheckR2012b(Max_vote_idx_1, &b_emlrtDCI, sp);
          }

          if (((int32_T)Max_vote_idx_1 < 1) || ((int32_T)Max_vote_idx_1 > 1121))
          {
            emlrtDynamicBoundsCheckR2012b((int32_T)Max_vote_idx_1, 1, 1121,
              &b_emlrtBCI, sp);
          }

          i2 = (int32_T)Max_vote_idx_1 - 1;
        }

        i2 -= i1;
        if (i2 == 0) {
          Max_vote_idx_1 = 0.0F;
        } else {
          if (i2 <= 1024) {
            firstBlockLength = i2;
            lastBlockLength = 0;
            nblocks = 1;
          } else {
            firstBlockLength = 1024;
            nblocks = i2 / 1024;
            lastBlockLength = i2 - (nblocks << 10);
            if (lastBlockLength > 0) {
              nblocks++;
            } else {
              lastBlockLength = 1024;
            }
          }

          Max_vote_idx_1 = amp_radar[i1 + 1122];
          for (k = 2; k <= firstBlockLength; k++) {
            Max_vote_idx_1 += amp_radar[(i1 + k) + 1121];
          }

          for (ib = 2; ib <= nblocks; ib++) {
            firstBlockLength = i1 + ((ib - 1) << 10);
            bsum = amp_radar[firstBlockLength + 1122];
            if (ib == nblocks) {
              hi = lastBlockLength;
            } else {
              hi = 1024;
            }

            for (k = 2; k <= hi; k++) {
              bsum += amp_radar[(firstBlockLength + k) + 1121];
            }

            Max_vote_idx_1 += bsum;
          }
        }

        Max_vote_idx_1 /= (real32_T)i2;
      }

      if (*emlrtBreakCheckR2012bFlagVar != 0) {
        emlrtBreakCheckR2012b(sp);
      }

      /*  Multiply all votes together, which penalises the clutter in a */
      /*  single radar LoS */
      St[i] = Max_vote_idx_0 * Max_vote_idx_1;
      if (*emlrtBreakCheckR2012bFlagVar != 0) {
        emlrtBreakCheckR2012b(sp);
      }
    }

    if (*emlrtBreakCheckR2012bFlagVar != 0) {
      emlrtBreakCheckR2012b(sp);
    }
  }

  /*  [xymax,radarsize,~] = size(bins); */
  /*  Max_vote = zeros(radarsize,1,'single'); */
  /*  St = zeros(xymax,1,'single'); */
  /*  % Loop for each block */
  /*   */
  /*  for ixy = 1:xymax */
  /*   */
  /*          for iradar = 1:radarsize */
  /*               */
  /*  %             Max_vote(ixy,iradar) = mean(amp_radar(bins(ixy,iradar,2):bins(ixy,iradar,1),iradar)); */
  /*  %              */
  /*              % If there is no range bin cross that block */
  /*              if sum(bins(ixy,iradar,:))==0 */
  /*                  Max_vote(iradar) = 1; % Set the vote value to 1 */
  /*              else */
  /*                  Max_vote(iradar) = mean(amp_radar(bins(ixy,iradar,2):bins(ixy,iradar,1),iradar)); */
  /*              end */
  /*          end */
  /*           */
  /*          % Multiply all votes together, which penalises the clutter in a */
  /*          % single radar LoS */
  /*          St(ixy) = prod(Max_vote); */
  /*            */
  /*  end */
  /*  St = Max_vote(:,1).*Max_vote(:,2); */
}

/* End of code generation (get_score_map.c) */
