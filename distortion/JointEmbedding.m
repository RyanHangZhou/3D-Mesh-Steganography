function JointEmbedding(input_path, output_path, payload, k, alpha, beta, lambda, n_layer)
%JOINTEMBEDDINGPARAMETER Summary of this function goes here
%   JointEmbedding for parameter estimation
%   Detailed explanation goes here

%   Get vertices and faces of the mesh
[vertex, face] = read_off(input_path);
n_vertex = length(vertex);
% n_vertex_valid = n_vertex-3;
n_vertex_valid = n_vertex;
message_length = fix(payload*n_vertex_valid*3)*n_layer;
message = round(rand(message_length,1));
message_length2 = fix(1*n_vertex_valid*3);
message2 = round(rand(message_length2,1));

vertex_transed = vertex;

%% embed with STCs

%   get embedding orders
v_order = getEmbedOrder(face);

ver_stego = zeros(size(vertex_transed));
% face = int32(face');

for l=k:k
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
    vertex = vertex'; face = face';
    fv1.vertices = vertex; fv1.faces = face;
    fv_smooth = smoothpatch(fv1, 0, 1);
    vertex_s = fv_smooth.vertices; 
    vertex_o = vertex';
    vertex_s = vertex_s';
    face_o = face';
    face_s = fv_smooth.faces;

    vertex_o=preprocess(vertex_o);
    vertex_s=preprocess(vertex_s);
    [VertexNormals_o, normals_o] = compute_normal(vertex_o', face_o');
    [VertexNormals_s, normals_s] = compute_normal(vertex_s', face_s');
    VertexNormals_o = VertexNormals_o';
    VertexNormals_s = VertexNormals_s';
    diff_vertex_normals = vectorAngle3d(VertexNormals_o, VertexNormals_s)+eps;
    diff_vertex_normals(isnan(diff_vertex_normals))=eps;

    vertex_dist = log(1./diff_vertex_normals+1)*10^4;

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

for l=k+1:31
    %   get bitplane
    vertex_plane = zeros(size(vertex_transed));
    for i = 1:size(vertex_plane, 1)
        for j = 1:size(vertex_plane, 2)
            vertex_plane(i, j) = getBitplane(vertex_transed(i, j), l);
        end
    end


    m_temp = message2(1:floor(message_length2/3));
    v_stego(1,:) = m_temp';
    m_temp = message2(message_length2/3+1:message_length2*2/3);
    v_stego(2,:) = m_temp';
    m_temp = message2(message_length2*2/3+1:end);
    v_stego(3,:) = m_temp';
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

write_off(output_path, ver_stego, face);

end