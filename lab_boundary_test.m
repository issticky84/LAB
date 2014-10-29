function test = lab_boundary_test(L,A,B)
    test = 1;
    [r,g,b] = Lab2RGB(L,A,B);
    [L1,A1,B1] = RGB2Lab(r,g,b);
    if abs(L1-L)>0.1 | abs(A1-A)>0.1 | abs(B1-B)>0.1
       test = 0; 
    end
end