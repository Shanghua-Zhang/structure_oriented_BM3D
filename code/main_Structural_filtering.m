clear;
clc;
close all;
tic
%% Import data
% addpath("C:\Users\cug\Desktop\structure-oriented- BM3D\data\synthetic\");
load post_signal.mat
load post_nsignal.mat

% load pre_field.mat
% n_signal=n_signal./max(max(n_signal)); % (field data need normalization)

%% Slope estimation
dtemp=n_signal*0;
for i=1:size(n_signal,1)
    dtemp(i,:)=smooth(n_signal(i,:),10);
end

[dip]=str_dip2d(dtemp);

%% Structural filtering
ns=2;
eps=0.01;
order=2;

ds=str_pwsmooth_lop2d(n_signal,dip,ns,order,eps);

%% Calculate SNR
noise = signal - ds;
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
% clim([-2,2]);
colorbar;
xlabel('Trace number','FontSize',12);
ylabel('Time(ms)','FontSize',12);
title('slope field','FontSize',12);

figure;
imagesc(ds);
colormap(seismic);
clim([-1.8,1.8]);
colorbar;
xlabel('Trace number','FontSize',12);
ylabel('Time(ms)','FontSize',12);
title('denoised data (Structural filtering)','FontSize',12);

figure;
imagesc(n_signal-ds);
colormap(seismic);
clim([-1.8,1.8]);
colorbar;
xlabel('Trace number','FontSize',12);
ylabel('Time(ms)','FontSize',12);
title('removed noise (Structural filtering)','FontSize',12);

toc
