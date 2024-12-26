function [final] = SBM3D(n_signal,dip,step,c,order,eps,par)
% SBM3D: Combining BM3D and PWD to segment and flatten the events for BM3D denoising 
%
% Input:
% n_signal: noisy data
% dip: slope
% step: step size
% c: number of small segment columns to be cut
% order: PWD order
% eps: regularization (default:0.01)
% par: BM3D parameters
%
% Output:
% final: final flattened and denoised data

% Edge treatment
n_signal = padarray(n_signal,[0,c],'symmetric','both');
dip = padarray(dip,[0,c],'symmetric','both');

a = size(n_signal,2);
final = n_signal*0;

% Segmented flattening and denoising
for i=1:step:(a-c+1)
    disp(i);

    % segment
    n = n_signal(:,i:i+c-1);
    d = dip(:,i:i+c-1);

    % flatten
    fn = pw_flatten(n,d,order,eps);
    
    % BM3D denoised segmented data
    [~,fn_bm3d] = BM3D(fn,par);
    
    % inverse flatten
    bk = pw_flatten(fn_bm3d,-d,order,eps);
    
    temp = final*0;
    temp(:,i:i+c-1) = bk; 

    final = final+temp;
end

% Distribute weight
weight = pwd_weit(n_signal,step,c); 
final = final./weight;

% Remove edge treatment
final = final(:,(c+1):(end-c));

end
