function weight = pwd_weit(n_signal,step,c)
% pwd_weit: Calculate weights
% 
% Input:
% n_signa: noisy data
% step: step size
% c: the number of small matrix columns to be cut
%
% Output:
% weight: weight coefficient

% Edge treatment
n_signal = padarray(n_signal,[0,c],'symmetric','both');

a1 = n_signal*0+1;
out = n_signal*0;

a = size(n_signal,2);

for i=1:step:(a-c+1)
   
    n = a1(:,i:i+c-1);
    temp = out*0;
    temp(:,i:i+c-1) = n;
    out = out+temp;
end

out = out(:,(c+1):(end-c));
weight = out;

end

