function [fn_signal] = pw_flatten(n_signal,dip,order,eps)
% pw_flatten：flatten events
%
% Input:
% n_signal: noisy data
% dip: slope
% order: PWD order
% eps: regularization (default:0.01)
%
% Output:
% fn_signal: flatten data

fn = fliplr(n_signal);
n2_signal = [fn(:,1:end-1),n_signal]; % flip the noisy data and merge the original noisy data

fd = fliplr(dip);
dip2 = [-fd(:,1:end-1),dip]; % flip the dip and merge the original dip

n1 = size(n2_signal,1);
n2 = size(n2_signal,2);
utmp=str_pwspray_lop2d(n2_signal,dip2,(n2-1)/2,order,eps);

u=reshape(utmp,n1,n2,n2);
fn_signal = u(:,(n2+1)/2:end,(n2+1)/2);
fn_signal=squeeze(fn_signal);

