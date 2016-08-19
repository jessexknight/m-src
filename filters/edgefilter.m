function [E] = edgefilter(I,varargin)
idim = numel(size(I));
[type,kdim] = parseinputs(varargin,idim);

switch type
  case 'diff'
    K = edgekernel3([0,1,0], kdim);
  case 'sobel'
    K = edgekernel3([1,2,1], kdim);
  case 'prewitt'
    K = edgekernel3([1,1,1], kdim);
  otherwise
    error('Unknown edge detector.');
end
switch idim
  case 2
    % 2D components
    E1 = imfilter(I,K, 'replicate');
    E2 = imfilter(I,K','replicate');
    % magnitude
    E = cast(sqrt(double(E1).^2 + double(E2).^2),class(I));
  case 3
    % 3D components (may still have 2D kernel)
    K3{1} = shiftdim(K,0);
    K3{2} = shiftdim(K,1);
    K3{3} = shiftdim(K,2);
    for e = 1:3
      E{e} = imfilter(I,K3{e},'replicate');
    end
    % magnitude
    E = cast(sqrt(double(E{1}).^2 + double(E{2}).^2 + double(E{3}).^2),class(I));
  otherwise
    error('Image must be 2D or 3D.');
end

function [type,kdim] = parseinputs(vargs,idim)
% defaults
kdim = idim;
type = 'sobel';
% user inputs
for v = 1:numel(vargs)
  if isa(vargs{v},'numeric');
    kdim = vargs{v};
  elseif isa(vargs{v},'char');
    type = vargs{v};
  else
    error('Invalid input number %d',v+1);
  end
end
if kdim > idim
  error('Cannot have 3D kernel with 2D image!');
end

function [K] = edgekernel3(k1,dim)
switch dim
  case 2
    K = cat(2, -k1', zeros(3,1), +k1');
  case 3
    k2 = k1'*k1;
    K = cat(3, -k2,  zeros(3,3), +k2);
end

