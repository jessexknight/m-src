function [] = dirnumzeropad(dirname,numzeros,context)
D = dir(dirname);
nmax   = 10^numzeros;
padstr = ['%0',num2str(numzeros),'d'];
for d = 3:numel(D)
    for n = 1:nmax
        numstr    = [context{1}, num2str(n),        context{2}];
        numstrpad = [context{1}, num2str(n,padstr), context{2}];
        if strfind(D(d).name,numstr)
            oldname = [dirname,'\',D(d).name];
            newname = [dirname,'\',strrep(D(d).name,numstr,numstrpad)];
            if ~strcmp(oldname,newname)
                command = ['!move "',oldname,'" "',newname,'"'];
                eval(command);
            end
        end
    end
end
    
    