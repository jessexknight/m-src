function [VO] = medfilter(V, K)

% check required memory (10 for safety)
MR = memcheck(V,2*numel(K));

if MR < 1 % no issues: be free, be fast!
  VO = squeeze(median(cast(kernelcat(V,K),class(V)),1));
  
else % blocked processing (3rd dimension only, much slower)
  VO = zeros(size(V),class(V));
  ZK = size(K,3);
  ZV = size(V,3);
  % one slice at a time
  for z = 1:ZV
    zi = [z-floor(ZK/2) : z+floor(ZK/2)];     % raw z indexes
    zcentre  = zi(round(numel(zi)/2));        % z at centre value
    zi(zi<1) = []; zi(zi>ZV) = [];            % cropping for edges
    zcentre  = find(zi == zcentre);           % z value to block index
    VOZ = squeeze(median(cast(kernelcat(V(:,:,zi),K),class(V)),1));
    VO(:,:,z) = VOZ(:,:,zcentre);
  end
end