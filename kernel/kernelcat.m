% KERNELCAT
%
% Prepends a dimension to image I which expands the concatenated
% image data for each pixel from the neighbourhood specified by K.
% Output image KI has size: [N,size(I)], where N is the number of
% nonzero elements in K.
%
% This operation is relevant to non-linear image filtering,
% where the statistics of the intensities in the moving binary
% kernel are used, rather than the spatial configuration or weighted
% average (convolution). The image filter can then be simply
% computed using a 1D operation along the first dimension of KI.
%
% This function works for 2D and 3D images and kernels.
%
% Jesse Knight 2015

function [IK, ck] = kernelcat(I, K)
isize  = size(I);
nk     = sum(abs(sign(K(:))));
memcheck(I,nk);
IK = zeros([nk,isize],class(I));
%IK = gpuArray(zeros([nk,isize]));
C  = kcentre(K);
ck = 1;

k = 1;
% looping through the binary kernel (not slow because K is small)
for x3 = 1:size(K,3)
  for x2 = 1:size(K,2)
    for x1 = 1:size(K,1)
      % if kernel element is nonzero
      if(K(x1,x2,x3))
        % compute the shift
        dx = (C - [x1,x2,x3]);
        % add the volume / slice
        IK(k,:,:,:) = imshift(I,dx);
        % if this is the centre, record the index of k
        if sum(dx) ==0
          ck = k;
        end
        k = k + 1;
      end
    end
  end
end

function [] = memcheck(I,nk)
% not really sure if this even works
Mdata = memory;
Idata = whos('I');
if Mdata.MaxPossibleArrayBytes < (Idata.bytes*nk)
  error('Failed memory check: image too big!');
end

function [IS] = imshift(I,T)
pos = sign(T) > 0;
IS = I;
if pos(1) % down
  IS = padarray(IS(1+T(1):end,:,:),[+T(1),0,0],'replicate','post');
else      % up
  IS = padarray(IS(1:end+T(1),:,:),[-T(1),0,0],'replicate','pre');
end
if pos(2) % right
  IS = padarray(IS(:,1+T(2):end,:),[0,+T(2),0],'replicate','post');
else      % left
  IS = padarray(IS(:,1:end+T(2),:),[0,-T(2),0],'replicate','pre');
end
if pos(3) % forward
  IS = padarray(IS(:,:,1+T(3):end),[0,0,+T(3)],'replicate','post');
else      % backward
  IS = padarray(IS(:,:,1:end+T(3)),[0,0,-T(3)],'replicate','pre');
end


