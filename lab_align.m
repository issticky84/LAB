function lab_align()
    obj = read_wobj('LAB_33.obj');
    cluster_center_mat = read_csv('cluster_center_20140925_0000_refine_c50.csv');
    vTotal = size(obj.vertices(:,1),1);
    %平移(減去重心) : cluster center matrix
    % cetroid of cluster center matrix
    cluster_center_mat_centroid = zeros(1,6);
    k = 50;
    for i=1:6
        for j=1:50
            cluster_center_mat_centroid(1,i) = cluster_center_mat_centroid(1,i) + cluster_center_mat(j,i);
        end
        cluster_center_mat_centroid(1,i) = cluster_center_mat_centroid(1,i)/k;
    end
    % minus centroid for all vector
    for i=1:k
        for j=1:6
            cluster_center_mat(i,j) = cluster_center_mat(i,j) - cluster_center_mat_centroid(1,j);
        end
    end
    %平移(減去重心) : LAB vertiecs
    % cetroid of LAB vertiecs
    lab_vertices = obj.vertices(:,:);
    lab_vertices_centroid = zeros(1,3);
    for i=1:3
        for j=1:vTotal
            lab_vertices_centroid(1,i) = lab_vertices_centroid(1,i) + lab_vertices(j,i);
        end
        lab_vertices_centroid(1,i) = lab_vertices_centroid(1,i)/vTotal;
    end 
    % minus centroid for all vector
    for i=1:vTotal
        for j=1:3
            lab_vertices(i,j) = lab_vertices(i,j) - lab_vertices_centroid(1,j);
        end
    end    
    %PCA dimension reduction : cluster center matrix
    [eigenVector,score,eigenvalue] = princomp(cluster_center_mat);
    transMatrix(:,1:3) = eigenVector(:,1:3);
    color_mat = cluster_center_mat * transMatrix;
    e1 = eigenVector(1,1:3);
    e2 = eigenVector(2,1:3);
    e3 = eigenVector(3,1:3);
    color_axis = [e1;e2;e3];
    color_weight = color_mat*inv(color_axis); % p (25x3) = [x y z] (25x3) * [e1;e2;e3] (3x3)
    %PCA dimension reduction : LAB vertices
    [eigenVector,score,eigenvalue] = princomp(lab_vertices);
    %transMatrix(:,1:3) = eigenVector(:,1:3);
    %lab_matrix = lab_vertices * transMatrix;
    v1 = eigenVector(1,1:3);
    v2 = eigenVector(2,1:3);
    v3 = eigenVector(3,1:3);
    lab_axis = [v1;v2;v3];
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %lab_axis_mat = [lab_axis(1,1) 0 0 ; 0 lab_axis(1,2) 0 ; 0 0 lab_axis(1,3)];
    align_mat = color_weight*lab_axis;
    csvwrite('lab_color.csv',align_mat);
%     for i=1:50
%         [r,g,b] = Lab2RGB(align_mat(i,1),align_mat(i,2),align_mat(i,3));
%         [L,A,B] = RGB2Lab(r,g,b);
%         fprintf('%f %f %f\n',L,A,B);
%     end
    
end