function rgb_mat = LABtoRGB(lab_mat)
    %put input matrix into image matrix
    k = size(lab_mat,1);
    lab_img_mat = zeros(k,1,3);
    for i=1:k
        for j=1:3
            lab_img_mat(i,1,j) = lab_mat(i,j);
        end
    end    
    %convert to lab
    rgbTransformation = makecform('lab2srgb');
    rgbI = applycform(lab_img_mat,rgbTransformation);
    %seperate l,a,b
    r = rgbI(:,:,1);
    g = rgbI(:,:,2);
    b = rgbI(:,:,3);
    
    rgb_mat = zeros(k,3);
    for i=1:k
       rgb_mat(i,1) = r(i,1);
       rgb_mat(i,2) = g(i,1);
       rgb_mat(i,3) = b(i,1);
    end
end