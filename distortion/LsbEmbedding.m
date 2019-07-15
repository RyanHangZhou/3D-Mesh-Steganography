function LsbEmbedding(input_path, output_path, payload, k)
%JOINTEMBEDDING Summary of this function goes here
%   Detailed explanation goes here

%   Get vertices and faces of the mesh
[vertex, face] = read_off(input_path);
n_vertex = length(vertex);
message_length = fix(payload*n_vertex)*3;
message = round(rand(message_length, 1));

% haimei xiugai
message_length2 = fix(1*n_vertex*3);
message2 = round(rand(message_length2, 1));

vertex_transed = vertex;

%%   embed with STCs
ver_stego = zeros(size(vertex_transed));
face = int32(face');
key = 0.5;

% for l=k:k+n_layer-1
for l=k:31
    %   get bitplane
    vertex_plane = zeros(size(vertex_transed));
    for i = 1:size(vertex_plane, 1)
        for j = 1:size(vertex_plane, 2)
            vertex_plane(i, j) = getBitplane(vertex_transed(i, j), l);
        end
    end

    if(l==k)
        temp = vertex_plane(1, :);
        m_temp = message(1:floor(message_length/3));
        s = lsbEmb(temp, m_temp', key);
        v_stego(1,:) = s;%[m_temp', temp(floor(message_length/3)+1:end)];
        temp = vertex_plane(2, :);
        m_temp = message(floor(message_length/3)+1:floor(message_length*2/3));
        s = lsbEmb(temp, m_temp', key);
        v_stego(2,:) = s; %[m_temp', temp(floor(message_length/3)+1:end)];
        temp = vertex_plane(3, :);
        m_temp = message(floor(message_length*2/3)+1:end);
        s = lsbEmb(temp, m_temp', key);
        v_stego(3,:) = s; %[m_temp', temp(floor(message_length/3)+1:end)];
    else
%         temp = vertex_plane(1, :);
        m_temp = message2(1:floor(message_length2/3));
        v_stego(1,:) = m_temp';
%         temp = vertex_plane(2, :);
        m_temp = message2(message_length2/3+1:message_length2*2/3);
        v_stego(2,:) = m_temp';
%         temp = vertex_plane(3, :);
        m_temp = message2(message_length2*2/3+1:end);
        v_stego(3,:) = m_temp';
    end
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