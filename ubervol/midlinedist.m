function [D] = midlinedist(brain,vsize)
% calculating brain angle and centroid
[theta] = brainangle(brain)
[cen]   = centroid(brain);
[N]     = planenorm(theta);
% make grid of normalized coordinates
[x,y,z] = meshgrid(1:size(brain,2), 1:size(brain,1), 1:size(brain,3));
YXZ     = bsxfun(@minus,[y(:),x(:),z(:)],cen);
% calculate and threshold distance from angled centre plane
D = reshape(abs(N*diag(vsize)*YXZ'),size(brain)).*cast(brain,class(N));

function [N]  = planenorm(theta)
% [y,x,z]
% create 3 points on the plane
th = -deg2rad(theta-90);
[x,y,z] = sph2cart(th*ones(1,3), deg2rad([+60,-60, 00]), [+1,+1,-1]);
v1 = [y(2)-y(3), x(2)-x(3), z(2)-z(3)];
v2 = [y(1)-y(3), x(1)-x(3), z(1)-z(3)];
N = cross(v1,v2);
N = N./magnitude(N);


