function [output1,output2] = BM3D(data,par,verb)
% BM3D:The implementation of BM3D
% Input:
% data:Input noisy data
% par:Configuration parameters
% Output:
% output1:The output of the first step in BM3D
% output2:The output of the second step in BM3D

% Calculate the forward and inverse transformation matrices
[Tforward,Tinverse] = getTransfMatrix(par.N1,par.transform_2D_HT_name,par.decLevel); 
[Tforward3rd,Tinverse3rd] = getTransfMatrix(par.N2,par.transform_3rd_dim_name,par.decLevel); 

norm_data = (data-min(min(data)))./(max(max(data))-min(min(data))); % Normalization

disp('Start Hard Thresholding Filering')
output1 = HardThresholding(norm_data,(par.N1)/2,(par.Ns-1)/2,par.Nstep,par.N2,Tforward,Tinverse,Tforward3rd,Tinverse3rd,par.lambda);

% Inverse normalization
output1 = output1.*(max(max(data))-min(min(data)))+min(min(data));

if nargin < 3 || ~strcmp(verb, 'h')
    disp('Start Wiener Filering')

    [Tforward_wiener,Tinverse_wiener] = getTransfMatrix(par.N1_wiener,par.transform_2D_Wiener_name,par.decLevel); 
    [Tforward3rd_wiener,Tinverse3rd_wiener] = getTransfMatrix(par.N2_wiener,par.transform_3rd_dim_name,par.decLevel); 
    
    output2 = Wiener(norm_data,output1,(par.N1_wiener)/2,(par.Ns_wiener-1)/2,par.Nstep_wiener,par.N2_wiener,...
    Tforward_wiener,Tinverse_wiener,Tforward3rd_wiener,Tinverse3rd_wiener,par.sigma);

    % Inverse normalization
    output2 = output2.*(max(max(data))-min(min(data)))+min(min(data));
else
    output2 = [];
end

end

