clear
clc
%% Import data
load post_signal1.mat
load post_hard1.mat
%% Flatten test
[dip] = str_dip2d(deno);

eps = 0.01;
order = 2;

fn = pw_flatten(signal(:,86:95),dip(:,86:95),order,eps);
bk = pw_flatten(fn,-dip(:,86:95),order,eps);
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
imagesc(signal(:,86:95));
colormap(seismic);
clim([-1.8,1.8]);
colorbar;
xlabel('Trace number','FontSize',12);
ylabel('Time(ms)','FontSize',12);
title('clean data','FontSize',12);

figure;
imagesc(fn);
colormap(seismic);
clim([-1.8,1.8]);
colorbar;
xlabel('Trace number','FontSize',12);
ylabel('Time(ms)','FontSize',12);
title('flattened data','FontSize',12);

figure;
imagesc(bk);
colormap(seismic);
clim([-1.8,1.8]);
colorbar;
xlabel('Trace number','FontSize',12);
ylabel('Time(ms)','FontSize',12);
title('inverse flattened data','FontSize',12);
