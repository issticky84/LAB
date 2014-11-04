function [r,g,b] = LABtoRGB(lab_img_mat)
    %convert to lab
    rgbTransformation = makecform('lab2srgb');
    rgbI = applycform(lab_img_mat,rgbTransformation);
    %seperate l,a,b
    r = rgbI(:,:,1);
    g = rgbI(:,:,2);
    b = rgbI(:,:,3);
    
end