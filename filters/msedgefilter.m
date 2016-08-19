function [E] = msedgefilter(I, LPK, weights, type, ndim)

% mutliscale edge filtering
debug = 0;

EK = zeros([numel(LPK), size(I)]);

% for each low pass kernel,
for k = 1:numel(LPK)
  % low pass filter the image [0.30 - 0.50] breaks!
  IK = imfilter(I, LPK{k});
  % compute the edge image and multiply by the weight for this scale
  EK(k,:,:,:) = weights(k) .* edgefilter(IK, type, ndim);
  if debug
    if size(I,3) > 3
      volshow(squeeze(EK(k,:,:,:)));
    else
      imshow(squeeze(EK(k,:,:,:)));
    end
    pause;
  end
end
% sum the resultant image along the extra dimension
E = squeeze(sum(EK,1));

