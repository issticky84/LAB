function outMat = axis_normalized(mat)
    first_axis = mat(1,:);
    for i=1:3
        mat(:,i) = mat(:,i) / max(first_axis);
    end
    outMat = mat;
end