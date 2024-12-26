clear
clc
close all
tic

%% Import data
% addpath("C:\Users\cug\Desktop\structure-oriented- BM3D\data\\field\");
load post_signal.mat
load post_nsignal.mat

% load pre_field.mat
% n_signal=n_signal./max(max(n_signal)); % (field data need normalization)

%% Select BM3D transformation type ('dct', 'dst', 'hadamard'):
par.transform_2D_HT_name     = 'bior1.5'; 
par.transform_2D_Wiener_name = 'dct';     
par.transform_3rd_dim_name   = 'haar';    

%% Hard threshold filtering parameters:
par.N1                  = 8;   % The size of the block (the power of 2)
par.Nstep               = 4;   % Sliding step size (even)
par.N2                  = 8;   % The maximum number of similar blocks within a group (the power of 2)
par.Ns                  = 39;  % The size of the search window (odd)
par.lambda              = 0.4; % Threshold parameter

%% Wiener filtering parameters:
par.N1_wiener           = 8;
par.Nstep_wiener        = 4;
par.N2_wiener           = 8;
par.Ns_wiener           = 39;
par.sigma               = 0.4;

par.decLevel            = 0;   

%% Hard threshold denoising
hard = BM3D(n_signal,par,'h');

%% Slope estimation
[dip] = str_dip2d(hard);

%% Flatten the events, denoise, and return to the original shape
eps = 0.01;
order = 2;

step = 1;
c = 4; % Flatten window lengths

final = SBM3D(n_signal,dip,step,c,order,eps,par);

%% Calculate SNR
noise = signal-final;
SNR = get_SNR(signal,noise);

%% Draw figures
figure;
imagesc(signal);
colormap(seismic);
clim([-1.8,1.8]);
colorbar;
xlabel('Trace number','FontSize',12);
ylabel('Time(ms)','FontSize',12);
title('clean data','FontSize',12);

figure;
imagesc(n_signal);
colormap(seismic);
clim([-1.8,1.8]);
colorbar;
xlabel('Trace number','FontSize',12);
ylabel('Time(ms)','FontSize',12);
title('noisy data','FontSize',12);

figure;
imagesc(dip);
colormap("jet");
% clim([-3,3]);
colorbar;
xlabel('Trace number','FontSize',12);
ylabel('Time(ms)','FontSize',12);
title('slope field','FontSize',12);

figure;
imagesc(final);
colormap(seismic);
clim([-1.8,1.8]);
colorbar;
xlabel('Trace number','FontSize',12);
ylabel('Time(ms)','FontSize',12);
title('denoised data (SBM3D)','FontSize',12);

figure;
imagesc(n_signal-final);
colormap(seismic);
clim([-1.8,1.8]);
colorbar;
xlabel('Trace number','FontSize',12);
ylabel('Time(ms)','FontSize',12);
title('removed noise (SBM3D)','FontSize',12);
toc

