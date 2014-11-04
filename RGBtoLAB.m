function [l,a,b] = RGBtoLAB(rgb_img_mat)
    %convert to lab
    labTransformation = makecform('srgb2lab');
    labI = applycform(rgb_img_mat,labTransformation);
    %seperate l,a,b
    l = labI(:,:,1);
    a = labI(:,:,2);
    b = labI(:,:,3);
    
end