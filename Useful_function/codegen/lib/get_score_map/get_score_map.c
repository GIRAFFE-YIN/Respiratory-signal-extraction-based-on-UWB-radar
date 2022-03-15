/*
 * File: get_score_map.c
 *
 * MATLAB Coder version            : 5.1
 * C/C++ source code generated on  : 08-Mar-2022 13:16:41
 */

/* Include Files */
#include "get_score_map.h"

/* Function Definitions */
/*
 * GET_SCORE_MAP Summary of this function goes here
 *    Detailed explanation goes here
 * Arguments    : const float bins[38400]
 *                const float amp_radar[2242]
 *                float St[9600]
 * Return Type  : void
 */
void get_score_map(const float bins[38400], const float amp_radar[2242], float
                   St[9600])
{
  float Max_vote_idx_0;
  float Max_vote_idx_1;
  float bsum;
  int bsum_tmp;
  int firstBlockLength;
  int hi;
  int i;
  int i1;
  int i2;
  int ix;
  int iy;
  int k;
  int lastBlockLength;
  int nblocks;
  for (ix = 0; ix < 80; ix++) {
    for (iy = 0; iy < 120; iy++) {
      /*              Max_vote(ixy,iradar) = mean(amp_radar(bins(ixy,iradar,2):bins(ixy,iradar,1),iradar)); */
      /*               */
      /*  If there is no range bin cross that block */
      i = ix + 80 * iy;
      Max_vote_idx_1 = bins[i];
      bsum = bins[i + 19200];
      if (Max_vote_idx_1 + bsum == 0.0F) {
        Max_vote_idx_0 = 1.0F;

        /*  Set the vote value to 1 */
      } else {
        if (bsum > Max_vote_idx_1) {
          i1 = -1;
          i2 = -1;
        } else {
          i1 = (int)bsum - 2;
          i2 = (int)Max_vote_idx_1 - 1;
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

          for (firstBlockLength = 2; firstBlockLength <= nblocks;
               firstBlockLength++) {
            bsum_tmp = i1 + ((firstBlockLength - 1) << 10);
            bsum = amp_radar[bsum_tmp + 1];
            if (firstBlockLength == nblocks) {
              hi = lastBlockLength;
            } else {
              hi = 1024;
            }

            for (k = 2; k <= hi; k++) {
              bsum += amp_radar[bsum_tmp + k];
            }

            Max_vote_idx_1 += bsum;
          }
        }

        Max_vote_idx_0 = Max_vote_idx_1 / (float)i2;
      }

      /*              Max_vote(ixy,iradar) = mean(amp_radar(bins(ixy,iradar,2):bins(ixy,iradar,1),iradar)); */
      /*               */
      /*  If there is no range bin cross that block */
      Max_vote_idx_1 = bins[i + 9600];
      bsum = bins[i + 28800];
      if (Max_vote_idx_1 + bsum == 0.0F) {
        Max_vote_idx_1 = 1.0F;

        /*  Set the vote value to 1 */
      } else {
        if (bsum > Max_vote_idx_1) {
          i1 = -1;
          i2 = -1;
        } else {
          i1 = (int)bsum - 2;
          i2 = (int)Max_vote_idx_1 - 1;
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

          for (firstBlockLength = 2; firstBlockLength <= nblocks;
               firstBlockLength++) {
            bsum_tmp = i1 + ((firstBlockLength - 1) << 10);
            bsum = amp_radar[bsum_tmp + 1122];
            if (firstBlockLength == nblocks) {
              hi = lastBlockLength;
            } else {
              hi = 1024;
            }

            for (k = 2; k <= hi; k++) {
              bsum += amp_radar[(bsum_tmp + k) + 1121];
            }

            Max_vote_idx_1 += bsum;
          }
        }

        Max_vote_idx_1 /= (float)i2;
      }

      /*  Multiply all votes together, which penalises the clutter in a */
      /*  single radar LoS */
      St[i] = Max_vote_idx_0 * Max_vote_idx_1;
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

/*
 * File trailer for get_score_map.c
 *
 * [EOF]
 */
