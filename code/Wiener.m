function output2 = Wiener(data,output1,n1,ns,Nstep,N2,Tforward,Tinverse,Tforward3rd,Tinverse3rd,sigma)
% Wiener: The implementation of the second step in BM3D
% Input:
% data: Input noisy data
% output1:The output of the first step in BM3D
% n1: Block radius size (2*n1 x 2*n1)
% ns: Search window radius size (2*ns+1 x 2*ns+1)
% Nstep: Step size
% N2: Number of similar blocks
% Tforward: Forward transform matrix
% Tinverse: Inverse transform matrix
% Tfordward3rd: Third dimension forward transform matrix
% Tinverse3rd: Third dimension inverse transform matrix
% sigma: Wiener filtering parameter (Noise intensity)
% Output:
% output1: The output of the first step in BM3D

[a,b] = size(data);

% Fill the boundary to avoid boundary effects
pad_data = padarray(data,[ns,ns],'symmetric'); 
pad_output1 = padarray(output1,[ns,ns],'symmetric'); 

% Calculate boundary information of 'data'
a1 = ns + 1;
a2 = ns + a;
b1 = ns + 1;
b2 = ns + b;

out2 = zeros(size(pad_data));

% The implementation of wiener filtering in BM3D
indices = a1:Nstep:a2; % Generate index array
parfor idx = 1:length(indices)
    i = indices(idx);
    disp(i);

    out2_temp = zeros(size(pad_data)); % Local output of each parallel task
    for j = b1:Nstep:b2
        searchWindow1 = pad_output1(i-ns:i+ns,j-ns:j+ns); % Extract search window
        searchWindow2 = pad_data(i-ns:i+ns,j-ns:j+ns); 

        refer = searchWindow1(ns+1-n1:ns+1+n1-1,ns+1-n1:ns+1+n1-1); % Extract reference block within the search window

        [p,q] = size(searchWindow1);

        % Calculate the row and column range of blocks within the search window
        x1 = n1 + 1;
        x2 = p - n1 + 1;
        y1 = n1 + 1;
        y2 = q - n1 + 1; 

        d = zeros(p-2*n1,q-2*n1);

        for k1 = x1:x2
            for k2 = y1:y2
                select = searchWindow1(k1-n1:k1+n1-1,k2-n1:k2+n1-1); % Extract block within the search window
                d(k1-n1,k2-n1) = Distance(refer,select); % Calculate the similarity between the reference block and the selected block
            end
        end

        [md,nd] = size(d);

        [~,t] = sort(reshape(d,[md*nd,1])); % Reshape d into a column vector and sort it in ascending order to obtain the element index
        
        [row,col] = ind2sub([md,nd],t(1:N2)); % Take the first N2 elements and obtain their row and column positions in d

        array_3D = zeros(2*n1,2*n1,N2);

        % Overlay similar blocks extracted from the search window into a 3D array
        for ii = 1:N2
            array_3D(:,:,ii) = searchWindow2(row(ii):row(ii)+2*n1-1,col(ii):col(ii)+2*n1-1); 
        end

        [x,y,z] = size(array_3D);
        temp_3D = array_3D*0;

        % Perform forward transformation on each column of the slice of the 3D array 'array_3D' 
        for i1 = 1:z
            for j1 = 1:y
                temp_3D(:,j1,i1) = Tforward*reshape(array_3D(:,j1,i1),[x,1]); 
            end
        end

        % Perform forward transformation on each row of the slice of the 3D array 'temp_3D' 
        for i1 = 1:z
            for j1 = 1:x
                temp_3D(j1,:,i1) = Tforward*reshape(temp_3D(j1,:,i1),[y,1]); 
            end
        end

        % Perform forward transformation on each element of the third dimension of the 3D array 'temp_3D' 
        for i1 = 1:y
            for j1 = 1:x
                temp_3D(j1,i1,:) = Tforward3rd*reshape(temp_3D(j1,i1,:),[z,1]); 
            end
        end

        % Multiply the elements in the 3D array by the Wienershrinkage coefficient
        w = temp_3D.^2./(temp_3D.^2+sigma); % Calculate Wiener shrinkage coefficients
        temp_3D = temp_3D.*w;

        T_array_3D = temp_3D*0;

        % Perform inverse transformation on each element of the third dimension of the 3D array 'temp_3D' 
        for i1 = 1:y
            for j1 = 1:x
                T_array_3D(j1,i1,:) = Tinverse3rd*reshape(temp_3D(j1,i1,:),[z,1]);
            end
        end

        % Perform inverse transformation on each row of the slice of the 3D array 'T_array_3D' 
        for i1 = 1:z
            for j1 = 1:x
                T_array_3D(j1,:,i1) = Tinverse*reshape(T_array_3D(j1,:,i1),[y,1]);
            end
        end

        % Perform inverse transformation on each column of the slice of the 3D array 'T_array_3D' 
        for i1 = 1:z
            for j1 = 1:y
                T_array_3D(:,j1,i1) = Tinverse*reshape(T_array_3D(:,j1,i1),[x,1]);
            end
        end

        temp = out2_temp*0;
        temp(i-n1:i+n1-1,j-n1:j+n1-1) = mean(T_array_3D,3); % Average processing of similar blocks in the 3D array
        out2_temp = out2_temp + temp;

    end
    out2 = out2 + out2_temp;
end   

% Calculate weights and perform weighted processing
weight = BM3D_weight(data,n1,ns,Nstep);
output2 = out2./weight;

output2 = output2(a1:a2,b1:b2); % Remove the filled boundary

end
