function test = lab_boundary_test(L,A,B)
    test = 0;
    [r,g,b] = Lab2RGB(L,A,B);
    [L1,A1,B1] = RGB2Lab(r,g,b);
    if abs(L1-L)<1.0 & abs(A1-A)<1.0 & abs(B1-B)<1.0
       test = 1; 
    end
end