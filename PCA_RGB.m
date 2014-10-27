function matrix = PCA_RGB(mat)
    %sort_mat = sort_descend(histo_mat);
    %sort_mat = sort_mat';
    %mat = mat';
    [eigenVector,score,eigenvalue,tsquare] = princomp(mat); 
    k = 3;
    transMatrix(:,1:k) = eigenVector(:,1:k);
    matrix = mat * transMatrix;
    %csvwrite('PCA_histo_BigData_20140330_0006_c25.csv',transMatrix);
end