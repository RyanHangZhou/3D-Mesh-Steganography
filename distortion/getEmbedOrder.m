function v = getEmbedOrder(face)
%GETEMBEDORDER Summary of this function goes here
%   Detailed explanation goes here

face = face';
v = int32([]);

for i = 1:size(face, 1)
    for j = 1:size(face, 2)
        if isempty(find(face(i, j)==v, 1))==1
            v = [v face(i, j)];
        end
    end
end

