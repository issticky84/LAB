function LAB_test()
%     visible_LAB = zeros(256,3);
%     count = 1;
%     for l=1:100
%         for a=-128:127
%             for b=-128:127
%                 [R,G,B] = Lab2RGB(l,a,b);
%                 [L,A,B] = RGB2Lab(R,G,B);
%                 if (abs(l-L)<1) & (abs(a-A)<1) & (abs(b-B)<1)
%                     %fprintf(fid,'%f %f %f\n',l,a,b);
%                     visible_LAB(count,1) = l;
%                     visible_LAB(count,2) = a;
%                     visible_LAB(count,3) = b;
%                     count = count + 1;
%                 end
%             end
%         end
%     end
    
    
    %csvwrite('test/lab_test.csv',visible_LAB);

    %read text file
    %a = load('haha.txt', '-ascii');
    
    m = csvread('lab_test.csv');
    fid = fopen('lab.txt','w');
    for i=1:size(m,1);
        fprintf(fid,'%f %f %f\n',m(i,1),m(i,2),m(i,3));
    end
end