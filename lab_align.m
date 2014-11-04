function lab_align()
    obj = read_wobj('LAB_33.obj');
    vTotal = size(obj.vertices(:,1),1);
    lab_vertices = obj.vertices(:,:);
    cluster_center_mat = read_csv('csv_data/cluster_center_BigData_20140319_2213_c25.csv');
    k = 25;
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
    move = (-5.0:0.1:5.0);
    %flag:判斷是否遇到了一個不合法的LAB點
    color_mat_const = color_mat;
    array(length(move)).scale = 0.0;
    %while flag==0
    for i=1:length(move)
        flag = 0;
        scale = 1.0;
        while flag==0
            color_mat(:) = ( color_mat_const(:) + move(i) ) * scale;
            color_weight = color_mat*inv(color_axis); % p (25x3) = [x y z] (25x3) * [e1;e2;e3] (3x3)
            align_mat = color_weight*lab_axis;
            csvwrite('output/align_mat.csv',align_mat);    

            for j=1:3
                %將重心平移回去
                align_mat(:,j) = align_mat(:,j) + lab_vertices_centroid(1,j);
            end
            %csvwrite('output/lab_color.csv',align_mat);

            for j=1:k
               if lab_boundary_test(align_mat(j,1),align_mat(j,2),align_mat(j,3))==0
                    flag = 1;
                    break;
               end
               if align_mat(j,1)<40
                    flag = 1;
                    break;
               end
            end
            
            if flag==0
                %max_align_mat = align_mat;
                array(i).scale = scale;
                array(i).move = move(i);
                array(i).mat = align_mat;
            end
            
            scale = scale + 0.05;
        end
    end
   
    max_move = 0;
    max_scale = -100000;
    max_align_mat = zeros(k,3);
    for i=1:length(move)
        if array(i).scale > max_scale
            max_scale = array(i).scale;
            max_move = array(i).move;
            max_align_mat = array(i).mat;
        end
    end
    
    %for i=1:length(move)
    %    fprintf('%f %f\n',array(i).move,array(i).scale);
    %end
    fprintf('max_move : %f max_scale : %f\n',max_move,max_scale);
    
    csvwrite('output/lab_color.csv',max_align_mat);
%     max_luminance = max(max_align_mat(:,1));
%     max_add_amount = 99 - max_luminance;
%     for i=1:k
%         if max_align_mat(i,1)<=50
%             max_align_mat(i,1) = max_align_mat(i,1) + max_add_amount;
%         else
%             max_align_mat(i,1) = max_align_mat(i,1) + max_add_amount;
%         end
%     end
%     csvwrite('output/lab_color_luminance_adjusted.csv',max_align_mat);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    rgb_mat = zeros(k,3);
    lab_img_mat = zeros(k,1,3);
    for i=1:k
        for j=1:3
            lab_img_mat(i,1,j) = max_align_mat(i,j);
        end
    end
    for i=1:k
        %[r,g,b] = Lab2RGB(max_align_mat(i,1),max_align_mat(i,2),max_align_mat(i,3));
        [r,g,b] = LABtoRGB(lab_img_mat);
        rgb_mat(i,1) = r(i,1);
        rgb_mat(i,2) = g(i,1);
        rgb_mat(i,3) = b(i,1);
    end
    csvwrite('output/rgb_color.csv',rgb_mat);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    i = 1;
    for j=1:k
        color = rgb_mat(j,1:3);
        fill([i i+1 i+1 i],[j j j+1 j+1],color); % [x1 x2 x3 x4] [y1 y2 y3 y4]
        hold on    
    end
    
end