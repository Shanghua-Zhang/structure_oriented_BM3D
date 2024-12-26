clear
clc
close all
%% add different noise strengths post-stack model SNR comparison

% SNR
post_original        = [-4.3486 -2.7664 -0.8327 1.6709 5.1931 11.2214];
Structural_Filtering = [2.1843 3.6687 5.4070 7.7893 11.0308 14.9111];
BM3D                 = [6.8987 8.1114 9.4339 11.8093 14.3350 18.1592];
SBM3D                = [8.8572 10.3172 11.8325 14.0993 16.5164 20.4558];

% plot line chart
figure;
plot(post_original,Structural_Filtering,'-og',post_original,BM3D,'-^b',post_original,SBM3D,'-*r');
legend('Structural Filtering','BM3D','SBM3D','Location','SouthEast', 'FontSize',8);   %右下角标注

axis([-6 12,-6 21]);
xlabel('Input SNR(dB)','FontSize',12);
ylabel('Output SNR(dB)','FontSize',12);

%% different segment size SNR comparison
segment_size = [2 4 6 8 10 12];

% SNR
SBM3D        = [11.6701 16.2846 15.7987 12.7219 9.3398 7.0695];

% plot line chart
figure;
plot(segment_size,SBM3D,'-xk');

axis([0 13,0 18]);
xlabel('Flatten window length (Trace number)','FontSize',12);
ylabel('Output SNR(dB)','FontSize',12);
