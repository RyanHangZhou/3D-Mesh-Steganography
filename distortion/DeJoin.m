function DeJoin(inName, outName_proposed, payload, k, alpha, beta, lambda, n_layer)
%DEJION Summary of this function goes here
%   Dejoin for jointly define distottion and embed them in a decomposing
%   way
%   Detailed explanation goes here

%   Get vertices and faces of the mesh
[vertex, face] = read_off(inName);
n_vertex = length(vertex);
n_vertex_valid = n_vertex-3;
message_length = fix(payload*n_vertex_valid*3)*n_layer;
message = round(rand(message_length,1));

vertex_transed = vertex;

%% embed with STCs

%   get embedding orders
v_order = getEmbedOrder(face);

ver_stego = zeros(size(vertex_transed));
face = int32(face');

for l=k:k+n_layer-1
% for l=k:31
    %   get bitplane
    vertex_plane = zeros(size(vertex_transed));
    for i = 1:size(vertex_plane, 1)
        for j = 1:size(vertex_plane, 2)
            vertex_plane(i, j) = getBitplane(vertex_transed(i, j), l);
        end
    end

    dist = sqrt(sum((vertex_transed-vertex).^2,1));
    
    %   find surrounding vertices
    vertex_dist = zeros(size(vertex_transed, 2), 1);
    for i = 1:size(v_order, 2)
        index = int32(v_order(i));
        [row,~,~] = find(face==index);
        face_d = [];
        face_c1 = [];
        face_c2 = [];
        for j = 1:length(row)
            face_d = [face_d; setdiff(face(row(j), :), index)];
            face_c1 = [face_c1; [vertex_transed(1, face_d(j, 1)) vertex_transed(2, face_d(j, 1)) vertex_transed(3, face_d(j, 1))]];
            face_c2 = [face_c2; [vertex_transed(1, face_d(j, 2)) vertex_transed(2, face_d(j, 2)) vertex_transed(3, face_d(j, 2))]];
        end
        
        %   get distortion
        ma = zeros(size(row)); mb = zeros(size(row)); mc = zeros(size(row));
        peri = zeros(size(row)); area = zeros(size(row)); theta = zeros(size(row));
        for j = 1:length(row)
            ma(j) = sqrt((vertex_transed(1, index)-face_c1(j, 1))^2+(vertex_transed(2, index)-face_c1(j, 2))^2+(vertex_transed(3, index)-face_c1(j, 3))^2);
            mb(j) = sqrt((vertex_transed(1, index)-face_c2(j, 1))^2+(vertex_transed(2, index)-face_c2(j, 2))^2+(vertex_transed(3, index)-face_c2(j, 3))^2);
            mc(j) = sqrt((face_c1(j, 1)-face_c2(j, 1))^2+(face_c1(j, 2)-face_c2(j, 2))^2+(face_c1(j, 3)-face_c2(j, 3))^2);
            peri(j) = (ma(j) + mb(j) + mc(j))/2;
            area(j) = sqrt(peri(j)*(peri(j)-ma(j))*(peri(j)-mb(j))*(peri(j)-mc(j)));
            theta(j) = acosd(((ma(j)^2)+(mb(j)^2)-(mc(j)^2))/(2*ma(j)*mb(j)));
        end
        vertex_dist(i) = abs(360 - sum(theta))/sum(area);
    end
    
    vertex_dist = 10^5./(vertex_dist.^alpha+1)./((lambda*dist)'.^beta+0.001);
%     vertex_dist = 10^1./(vertex_dist.^alpha+1);
%     vertex_dist = ((lambda*dist)'.^beta+0.001)./(vertex_dist.^alpha+1);
    
    if(l~=k)
        payload = 1-payload;
    end
    %   embed with STCs
    v_stego(1,:) = getStego(vertex_plane(1, :), vertex_dist, payload);
    v_stego(2,:) = getStego(vertex_plane(2, :), vertex_dist, payload);
    v_stego(3,:) = getStego(vertex_plane(3, :), vertex_dist, payload);
    zv = zeros(size(v_stego));
    
    %   modify the coordinates
    for i = 1:size(v_stego, 1)
        for j = 1:size(v_stego, 2)
            if(l<23)
                ver_stego(i, j) = getModiCoord(v_stego(i, j), vertex_plane(i, j), vertex_transed(i, j), l);
            else
                ver_stego(i, j) = getModiCoord(zv(i, j), vertex_plane(i, j), vertex_transed(i, j), l);
            end
        end
    end
    
    vertex_transed = ver_stego;
end

write_off(outName_proposed, ver_stego, face);

end