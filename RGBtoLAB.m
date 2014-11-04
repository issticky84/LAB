function lab_mat = RGBtoLAB(rgb_mat)
    %put input matrix into image matrix
    k = size(rgb_mat,1);
    rgb_img_mat = zeros(k,1,3);
    for i=1:k
        for j=1:3
            rgb_img_mat(i,1,j) = rgb_mat(i,j);
        end
    end   
    %convert to lab
    labTransformation = makecform('srgb2lab');
    labI = applycform(rgb_img_mat,labTransformation);
    %seperate l,a,b
    l = labI(:,:,1);
    a = labI(:,:,2);
    b = labI(:,:,3);
 
    lab_mat = zeros(k,3);
    for i=1:k
       lab_mat(i,1) = l(i,1);
       lab_mat(i,2) = a(i,1);
       lab_mat(i,3) = b(i,1);
    end    
end