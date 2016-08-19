function [VO] = medfilter(V, K)

% check required memory
MR = memcheck(V,10000*numel(K));

if MR < 1 % no issues
  VK = cast(kernelcat(V,K),class(V));
  VO = squeeze(median(VK,1));
else % blocked processing (1st dimension only)
  VO = zeros(size(V),class(V));
  wk = ceil(size(K,1)/2);  % kernel width (for padding)
  wv = ceil(size(V,1)/MR); % max data block size
  sv = size(V,1);
  
  % for each data block
  for b = 1:ceil(MR)
    % finding range
    
    % computing for sub-block
    VKb = kernelcat(V(vp,:,:,:),K);
    VO(v,:,:,:) = squeeze(median(VKb,1));
  end
  fprintf('.');
end

function [] = blockvs(wk,wv,sv,b)
vpmin = max(         1, -wk+(wv*(b-1))+1 );
vpmax = min( size(V,1), +wk+(wv*(b))     );
vp    = vpmin:vmax;
