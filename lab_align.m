function lab_align()
    obj = read_wobj('LAB_33.obj');
    cluster_center_mat = read_csv('cluster_center_20140925_0000_refine_c50.csv');
    vTotal = size(obj.vertices(:,1),1);
    k = 50;
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %平移(減去重心) : cluster center matrix
    % cetroid of cluster center matrix
    cluster_center_mat_centroid = compute_centroid(cluster_center_mat);
    % minus centroid for all vector
    for i=1:k
        for j=1:6
            cluster_center_mat(i,j) = cluster_center_mat(i,j) - cluster_center_mat_centroid(1,j);
        end
    end
    %平移(減去重心) : LAB vertiecs
    % cetroid of LAB vertiecs
    lab_vertices = obj.vertices(:,:);
    lab_vertices_centroid = compute_centroid(lab_vertices);
    % minus centroid for all vector
    for i=1:vTotal
        for j=1:3
            lab_vertices(i,j) = lab_vertices(i,j) - lab_vertices_centroid(1,j);
        end
    end    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %PCA dimension reduction : cluster center matrix
    [eigenVector,score,eigenvalue] = princomp(cluster_center_mat);
    transMatrix(:,1:3) = eigenVector(:,1:3);
    color_mat = cluster_center_mat * transMatrix;
    e1 = eigenVector(1,1:3);
    e2 = eigenVector(2,1:3);
    e3 = eigenVector(3,1:3);
    %e1_length = max(color_mat(:,1))-min(color_mat(:,1)); %2.1346
    color_axis = [e1;e2;e3];
    color_axis = axis_normalized(color_axis);
    %color_mat(:) = color_mat(:) * 20;
    %color_weight = color_mat*inv(color_axis); % p (25x3) = [x y z] (25x3) * [e1;e2;e3] (3x3)
    %PCA dimension reduction : LAB vertices
    [eigenVector,score,eigenvalue] = princomp(lab_vertices);
    transMatrix2(:,1:3) = eigenVector(:,1:3);
    lab_mat = lab_vertices * transMatrix2;
    v1 = eigenVector(1,1:3);
    v2 = eigenVector(2,1:3);
    v3 = eigenVector(3,1:3);
    %v1_length = max(lab_mat(:,1))-min(lab_mat(:,1)); %258.4492
    lab_axis = [v1;v2;v3];
    lab_axis = axis_normalized(lab_axis);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    scale = 10;
    flag = 0;
    color_mat_const = color_mat;
    while flag==0
        color_mat(:) = color_mat_const(:) * scale;
        color_weight = color_mat*inv(color_axis); % p (25x3) = [x y z] (25x3) * [e1;e2;e3] (3x3)
        align_mat = color_weight*lab_axis;
        csvwrite('align_mat.csv',align_mat);    

        for i=1:3
            align_mat(:,i) = align_mat(:,i) + lab_vertices_centroid(1,i);
        end
        csvwrite('lab_color.csv',align_mat);

        for i=1:k
           if lab_boundary_test(align_mat(i,1),align_mat(i,2),align_mat(i,3))==0
                flag = 1;
                break;
           end
        end
        if flag==1 
            max_align_mat = align_mat;
        end
        scale = scale + 1;
    end
    disp(scale);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    rgb_mat = zeros(k,3);
    for i=1:k
        [r,g,b] = Lab2RGB(max_align_mat(i,1),max_align_mat(i,2),max_align_mat(i,3));
        rgb_mat(i,1) = r;
        rgb_mat(i,2) = g;
        rgb_mat(i,3) = b;
    end
    csvwrite('rgb_color.csv',rgb_mat);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    i = 1;
    for j=1:k
        color = rgb_mat(j,1:3);
        fill([i i+1 i+1 i],[j j j+1 j+1],color); % [x1 x2 x3 x4] [y1 y2 y3 y4]
        hold on    
    end
    
end