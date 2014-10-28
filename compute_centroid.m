function outMat = compute_centroid(mat)
    col = size(mat,2);
    row = size(mat,1);
    outMat = zeros(1,col);
    for i=1:col
        for j=1:row
            outMat(1,i) = outMat(1,i) + mat(j,i);
        end
        outMat(1,i) = outMat(1,i)/row;
    end    
end