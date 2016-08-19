% Jesse Knight 2015
% Copyright: Khademi Lab (Image Analysis in Medicine Lab).
%            Not to be distributed or copied.
% 
% Reconstruct a 3D image out of the 6D array PATCHES
% PATCHES dimension indexes: ([y,x,z],[py,px,pz])
% where [y,x,z] are indexes in the patch P
% and [py,px,pz] are the indexes of patch P in I

function [V] = volunpatch(patches)

psize = size(patches);
if numel(psize) == 5
    psize(end+1) = 1;
end
vsize = [psize(1)*psize(4),psize(2)*psize(5),psize(3)*psize(6)];

V = zeros(vsize);

for pz = 1:psize(6)
    idz = [1+(pz-1)*psize(3) : (pz)*psize(3)];
    for px = 1:psize(5)
        idx = [1+(px-1)*psize(2) : (px)*psize(2)];
        for py = 1:psize(4)
            idy = [1+(py-1)*psize(1) : (py)*psize(1)];
            
            V(idy,idx,idz) = patches(:,:,:,py,px,pz);
        end
    end
end
