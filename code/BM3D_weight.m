function weight = BM3D_weight(data,n1,ns,Nstep)
% BM3D_weight:Calculate weights
% Input:
% data:Input noisy data
% n1:Block radius size (2*n1 x 2*n1)
% ns:Search window radius size (2*ns+1 x 2*ns+1)
% Nstep:Step size
% Output:
% weight:Calculated weights

[a,b] = size(data);

pad_data = padarray(data,[ns,ns],'symmetric'); % Fill the boundary to avoid boundary effects

% Calculate boundary information of 'data'
a1 = ns + 1;
a2 = ns + a;
b1 = ns + 1;
b2 = ns + b;

weight = zeros(size(pad_data));
pad_data_1 = zeros(size(pad_data)) + 1;

for i = a1:Nstep:a2
    for j = b1:Nstep:b2
        searchWindow = pad_data_1(i-ns:i+ns,j-ns:j+ns); % Extract search window
        refer = searchWindow(ns-n1:ns+n1-1,ns-n1:ns+n1-1); % Extract reference block within the search window    
        
        temp = weight*0;                    
        temp(i-n1:i+n1-1,j-n1:j+n1-1) = refer; 
        weight = weight + temp;                  
    end
end

end

