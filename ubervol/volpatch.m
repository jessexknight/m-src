% Jesse Knight 2015
% Copyright: Khademi Lab (Image Analysis in Medicine Lab).
%            Not to be distributed or copied.
% 
% Create a 6D array of 3D patches out of image I
% Dimension indexes: ([y,x,z],[py,px,pz])
% where [y,x,z] are indexes in the patch P
% and [py,px,pz] are the indexes of patch P in I

function [patches] = volpatch(V, patchsize)

vsize = size(V);
if numel(vsize) == 2
    vsize(end+1) = 1;
end
if numel(patchsize) == 2
    patchsize(end+1) = 1;
end

npatch = floor(vsize./patchsize);
patches = zeros([patchsize,npatch]);

for py = 1:npatch(1)
    idy = [1+(py-1)*patchsize(1) : (py)*patchsize(1)];
    for px = 1:npatch(2)
        idx = [1+(px-1)*patchsize(2) : (px)*patchsize(2)];
        for pz = 1:npatch(3)
            idz = [1+(pz-1)*patchsize(3) : (pz)*patchsize(3)];            
            
            patches(:,:,:,py,px,pz) = V(idy,idx,idz);
        end
    end
end

    
