function [theta] = brainangle(brain)
th.vol = 0.05;
th.deg = 10;
th.th0 = 0;
thetas = [];
% fit elipse to brain for all slices (with at laest 10 % mask)
for z = 1:size(brain,3)
  if mean2(brain(:,:,z)) > th.vol
    thetas(end+1) = slicetheta(imresize(brain(:,:,z),[128,128]),th.th0);
  end
end
% shift by 45 to prevent circular artifact
thetas = thetas + 45;
% initial estimate: median of all angles
theta = median(thetas);
% remove angles outside 10 deg of this
thetas(abs(thetas-theta) > th.deg) = [];
% re-calculate angle
theta  = median(thetas) - 45;
thetas = thetas - 45;

function [theta] = slicetheta(brain, th0)
theta = -0.5*fminsearch(@(theta)epoch(theta,brain), th0);

function [sim] = epoch(theta,brain)
sim = -corr2(brain,fliplr(imrotate(brain,theta,'bilinear','crop')));




