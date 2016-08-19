% Jesse Knight 2015
% Copyright: Khademi Lab (Image Analysis in Medicine Lab).
%            Not to be distributed or copied.
% 
% CDOTFILTER(I, K, VIDX, @OP)
%
% Perform kernel-based vector filtering on the colour image I.  The binary
%   kernel K specifies the neighbourhood of vectors to consider for a given
%   pixel.  For all pixels in I, the vectors corresponding to the neighbourhood
%   K are sorted based on the sum of dot products between one another.
%   The sorted indicies specified by VIDX are then used to select vectors in the
%   neighbourhood.  Operation OP is then applied to these vectors.
%
% Inputs:
%   I    - 2D colour image, any colourspace
%   K    - Binary kernel for selecting a local neighbourhood.
%          Warning: Computation time is of order (N choose 2), where N is the
%                   number of nonzero elements in K.
%   vidx - Indices of sorted vectors in the kernel neighbourhood to be used in 
%          the operation.
%          Warning: No value should exceed N, where N is the number of nonzero
%                   elements in K.
%   op   - Handle to an operation which acts along a single specified dimension
%          of it's first argument.  The dimension must be specified by the 
%          second argument. The required dimension is internal to this function.
%          e.g. @mean: mean(X,D) computes the mean of X along D'th dimension.
%
% Output:
%   IO   - Image result of the vector filtering.


function [IO] = cdotfilter(I,K,vidx,op)
% explode the pixels specified by the kernel (K) in I into a new dimension
IK = kernelcat(I,K);
% consider all pairs of vectors in K
pair = nchoosek(1:sum(K(:)),2);
% for each vector in K, sum the dot products with every other vector in K
% this is the sorting feature - measure of 'centralness' of the vector
Kdot = zeros(size(IK,1),size(IK,2),size(IK,3));
for p = 1:size(pair,1)
    vdot = dot( squeeze(IK(pair(p,1),:,:,:)), squeeze(IK(pair(p,2),:,:,:)), 3 );
    Kdot(pair(p,1),:,:) = Kdot(pair(p,1),:,:) + shiftdim(vdot,-1);
    Kdot(pair(p,2),:,:) = Kdot(pair(p,2),:,:) + shiftdim(vdot,-1);
end
% sort the feature, store the sorting indexes
[~,sidx] = sort(Kdot,1);
% using the sorted feature, select the sorted vectors specified by user's vidx,
% and perform the user-specified operation op on these vectors to compute the
% output image OUT.
IO = spvop(sidx,vidx,IK,op);

% explode the pixels specified by K in I into a new dimension (prepended)
% KI has dimensions [numel(K nonzero), size(I)]
function [KI] = kernelcat(I, K)
I = double(I);
isize = size(I);
ksize = sum(abs(sign(K(:))));
KI = zeros([ksize,isize]);
C  = round([size(K,1),size(K,2),size(K,3)]/2);

k = 1;
for z = 1:size(K,3)
    for x = 1:size(K,2)
        for y = 1:size(K,1)
            if(K(y,x,z))
                KI(k,:,:,:) = imshift(I,(C - [y,x,z]));
                k = k + 1;
            end
        end
    end
end

% custom image shifting function because MATLAB's is overcomplicated
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

function [OUT] = spvop(sidx,vidx,IK,op)
% preallocate the output image
% and exploded output image before OP is performed along the extra dimension
OUT  = zeros(size(IK,2),size(IK,3),size(IK,4));
OUTv = zeros([size(OUT),numel(vidx)]);

% for all desired indexes in the sorted vector list...
% (perform all operations simultaneously across the image pixels)
for v = 1:numel(vidx)
    % consider the vector specified by index vidx(v) in the sorted vectors
    Xv = squeeze(sidx(vidx(v),:,:));
    % sparsely explode the indexes corresponding to the sorted vector
    % into the kernel dimension, and pad by colour dimension
    spidx = padarray(spunique(Xv),[0,0,0,size(IK,4)-1],'replicate','post');
    % the component of the output image contributed by the sorted vector at vidx
    OUTv(:,:,:,v) = sum(spidx.*IK,1);
end
% perform the user-specified operation along the extra dimension of the exploded
% output image to yield the final output image.
OUT = op(OUTv,4);

% encode unique elements along new sparse dimension
function [sp] = spunique(X)
U = unique(X);
sp = zeros([numel(U),size(X)]);
for u = 1:numel(U)
    sp(u,:) = X(:) == u;
end


