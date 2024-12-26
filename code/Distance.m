function d = Distance(refer,select)
% Calculate the similarity between the reference block and the selected block
% Input:
% refer: The reference block
% select: The selected block
% Output:
% d: the similarity

a = reshape(refer,[numel(refer),1]);
b = reshape(select,[numel(select),1]);
c = a - b;

d = (norm(c,2))^2;

end

