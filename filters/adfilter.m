function [IAD] = adfilter(I,iter,type,kappa,vsize)
dt  = (3/44).*prod(vsize); % from other code - "stability"

% discrete diffusion kernels (difference equations)
for h = 1:26
  hi = h + round(h/27); % skip the centre (self "diffusion")
  H{h} = zeros(3,3,3);  % zeros
  H{h}(hi) = +1;        % except diffusion direction
  H{h}(14) = -1;        % and the centre
end

% distances to the centre voxel
J = zeros(3,3,3);       % dummy variable for bwdist
J(14) = 1;              % centre voxel is 1
D = bwdistsc(J,vsize);  % note aspect ratio scaling is considered
D(14) = [];             % remove the centre same as above (27 -> 26)
X = 1./(D.^2);

% diffusion type
switch type
  case 'edge' % "privileges high-contrast edges over low-contrast ones."
    dfcn = @(x)(exp(-(x/kappa).^2));
  case 'wide' % "privileges wide regions over smaller ones."
    dfcn = @(x)(1./(1+(x/kappa).^2));
end

% diffusion iterations
IAD = double(I);
for i = 1:iter
  % compute gradients (fast!)
  parfor h = 1:26
    del  = imfilter(I,H{h},'same');    % gradient image
    U(:,:,:,h) = X(h)*dfcn(del).*del;  % difference equation
  end
  % apply update
  IAD = IAD + dt.*sum(U,4);
end

IAD = cast(IAD,class(I));



