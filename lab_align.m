function lab_align()
    tic %time start
    obj = read_wobj('LAB_33.obj');
    lab_vertices = obj.vertices(:,:);
    vTotal = size(lab_vertices,1);    
    cluster_center_mat = read_csv('csv_data/cluster_center_BigData_20140330_0006_c25.csv');
    k = size(cluster_center_mat,1);
    %k = 25;
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %計算cluster center重心
    cluster_center_mat_centroid = compute_centroid(cluster_center_mat);
    %全部的點減去重心(將重心平移到原點)
    for i=1:k
        for j=1:size(cluster_center_mat,2)
            cluster_center_mat(i,j) = cluster_center_mat(i,j) - cluster_center_mat_centroid(1,j);
        end
    end
    %計算lab vertices重心
    lab_vertices_centroid = compute_centroid(lab_vertices);
    %全部的點減去重心(將重心平移到原點)
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
    %PCA的三個軸:e1,e2,e3
    e1 = eigenVector(1,1:3);
    e2 = eigenVector(2,1:3);
    e3 = eigenVector(3,1:3);
    %e1_length = max(color_mat(:,1))-min(color_mat(:,1)); %2.1346
    color_axis = [e1;e2;e3];
    color_axis = axis_normalized(color_axis);
    %PCA dimension reduction : LAB vertices
    [eigenVector,score,eigenvalue] = princomp(lab_vertices);
    %transMatrix2(:,1:3) = eigenVector(:,1:3);
    %lab_mat = lab_vertices * transMatrix2;
    %PCA的三個軸:v1,v2,v3
    v1 = eigenVector(1,1:3);
    v2 = eigenVector(2,1:3);
    v3 = eigenVector(3,1:3);
    %v1_length = max(lab_mat(:,1))-min(lab_mat(:,1)); %258.4492
    lab_axis = [v1;v2;v3];
    lab_axis = axis_normalized(lab_axis);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    move = (-1.0:0.1:1.0);
    %flag:判斷是否遇到了一個不合法的LAB點
    color_mat_const = color_mat;

    %const_invert_color_axis = eye(3)/color_axis;
    max_move = 0;
    max_scale = 0;
    %max_align_mat = zeros(k,3);   
    max_align_mat = color_mat;
    
    luminance_threshold = 30;
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    for i=1:length(move)
        flag = 0;
        scale = 10.0;
        while flag==0
            if(scale < max_scale)
                scale = scale + 1.0;
                continue;
            end
            color_mat(:) = ( color_mat_const(:) + move(i) ) * scale;
            color_weight = color_mat/color_axis; % p (25x3) = [x y z] (25x3) * [e1;e2;e3] (3x3)
            %color_weight = color_mat*const_invert_color_axis;
            align_mat = color_weight*lab_axis;   

            for j=1:3
                %將重心平移回去
                align_mat(:,j) = align_mat(:,j) + lab_vertices_centroid(1,j);
            end

            for j=1:k
               if lab_boundary_test(align_mat(j,1),align_mat(j,2),align_mat(j,3))==0
                    flag = 1;
                    break;
               end
               if align_mat(j,1)<luminance_threshold
                    flag = 1;
                    break;
               end
            end
            
            if flag==0
                if scale > max_scale
                    max_scale = scale;
                    max_move = move(i);
                    max_align_mat = align_mat;
                end
            end
            
            %scale = scale + 0.05;
            scale = scale + 1.0;
        end
    end
    
    if max_scale == 0
        for j=1:3
            %將重心平移回去
            max_align_mat(:,j) = max_align_mat(:,j) + lab_vertices_centroid(1,j);
        end
    end 
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    toc %time end
    %fprintf('time elapsed : %f\n',t);
    fprintf('max_move : %f max_scale : %f\n',max_move,max_scale);
    
    csvwrite('output/lab_color.csv',max_align_mat);

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    rgb_mat = LABtoRGB(max_align_mat);
    csvwrite('output/rgb_color.csv',rgb_mat);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    i = 1;
    for j=1:k
        color = rgb_mat(j,1:3);
        fill([i i+1 i+1 i],[j j j+1 j+1],color); % [x1 x2 x3 x4] [y1 y2 y3 y4]
        hold on    
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end