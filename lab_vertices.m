function lab_vertices()
    obj=read_wobj('LAB_33.obj');
    fid = fopen('lab_25.txt','w');
    vTotal = size(obj.vertices(:,1),1);
    for i=1:vTotal
        if obj.vertices(i,1)>=25.0 & obj.vertices(i,1)<26.0
            fprintf(fid,'%f %f %f\n',obj.vertices(i,1),obj.vertices(i,2),obj.vertices(i,3));
        end
    end
end