Code: Seismic random noise suppression by structure-oriented BM3D

This is the code for the article "Seismic random noise suppression by structure-oriented BM3D".

This repository contains two folders：

1. "data"
2. "code"

"data" contains the data used in the article, divided into three subfolders：

1. "field": Data used for the field examples in the article.
2. "synthetic": Data used for the synthetic examples in the article.
3. "flatten_test":  Data used for the demonstration of flattening and restoring the events in the article.

"code" contains the code needed in the article. Below is a brief explanation of these code files:

main script files:

1. main_BM3D: BM3D denoising.
2. main_Structural_filtering: Structural filtering denoising.
3. main_SBM3D: Structure-oriented BM3D denoising.
4. flatten_test: The test of flattening and restoring events corresponds to Figure 5 in the article.
5. line_chart: Line chart code for Figures 18 and 19 in the article.

Function files:  

(a) BM3D code:

1. BM3D: This function implements the two main steps of the BM3D algorithm.
2. getTransfMatrix: This function generates and returns the forward transformation matrix and the corresponding inverse transformation matrix of the specified size and type for image block transformation and inverse transformation operations.
3. HardThresholding: This function  implements  the first step of BM3D algorithm.
4. Wiener:  This function  implements  the second step of BM3D algorithm.
5. Distance：Calculate the similarity between the reference block and the selected block.
6. BM3D_weight: This function implements the weighted average processing in the BM3D algorithm. 

(b) PWD for local slope code:  

7. str_dip2d: This function implements the 2D data dip estimation based on shaping regularized PWD algorithm.  

8. str_conv_allpass: This function is a convolution operator implemented by an all-pass filter.  

9. str_divne: This function implements the N-dimensional smooth division rat=num/den.  
10. str_pwsmooth_lop2d: This function uses a two-dimensional plane wave smoothing algorithm to smooth the input noisy data.  
11. str_pwspray_lop2d: This function implements the 2D plane-wave spray operator.

(c) Structure-oriented BM3D code:  

12. SBM3D: This function implements the structure-oriented BM3D denoising.  

13. pw_flatten: The function implements flattening of seismic events.  

14. pwd_weit:  The function is used to calculate weight coefficient.  
15. seismic: This is the colormap for seismic images.  
16. get_SNR: The function is used to calculate SNR.

Note: This file "parameters.txt" is the parameters used in the article.
![Parameters_SNR_CalculationTime](https://github.com/user-attachments/assets/3722b926-9769-448c-a05a-9e384d73db18)

