function [IBF] = bilat3filter(I, Syxz, Sr, Qyxz, Qr)
I = double(I);
% size of image
[NY,NX,NZ] = size(I);
% sampling in space
Qy = Qyxz(1);
Qx = Qyxz(2);
Qz = Qyxz(3);
% spatial dimension bins
BY = ceil(NY/Qy);
BX = ceil(NX/Qx);
BZ = ceil(NZ/Qz);
% padded size
PY = BY*Qy;
PX = BX*Qx;
PZ = BZ*Qz;
% difference
RY = ceil((PY-NY)/2);
RX = ceil((PX-NX)/2);
RZ = ceil((PZ-NZ)/2);
% Pad the image to obtain size divisible by sampling rate
Ip = padarray(I,[RY,RX,RZ],0);
I  = Ip(1:PY, 1:PX, 1:PZ);
clearvars Ip;

% (1) - Sampling & exploding into graylevel dimension
% Quantize graylevels
Iq = round( (I-min(I(:))) / range(I(:)) / Qr );
% Grid of y-x-z coordinates
[Y,X,Z] = ndgrid(1:PY,1:PX,1:PZ);
by = floor((Y-1)/Qy)+1;
bx = floor((X-1)/Qx)+1;
bz = floor((Z-1)/Qz)+1;
clearvars X Y Z;
bw = repmat(reshape(1:prod(Qyxz),[Qy,Qx,Qz]),[BY,BX,BZ]);
% initialize bilateral matrices
D  = zeros(BY,BX,BZ,(Qy*Qx*Qz));
W  = D;
D(sub2ind(size(D),by(:),bx(:),bz(:),bw(:))) = I(:);
W(sub2ind(size(D),by(:),bx(:),bz(:),bw(:))) = Iq(:);
clearvars Iq by bx bz bw;
% 4D matrices W = locations of data points, D = value of the data point
GD = zeros(BY,BX,BZ,1/Qr);
GW = zeros(BY,BX,BZ,1/Qr);
for k = 1:(1/Qr)
  idx = (W==k);
  Dk  = zeros(size(D));
  Dk(idx) = D(idx);
  % Weights: number of pixels in the kth range bin for all (y-x-z)
  GW(:,:,:,k) = sum(idx,4);
  % Data: sum of their values
  GD(:,:,:,k) = sum(Dk,4);
end

% (2) - Gaussian smoothing
% kernels
Ky = gaussk(Syxz(1)/Qy);
Kx = gaussk(Syxz(2)/Qx);
Kz = gaussk(Syxz(3)/Qz);
Kr = gaussk(Sr/Qr);
% ND convolution
GW = convnsep({Ky,Kx,Kz,Kr},GW,'same');
GD = convnsep({Ky,Kx,Kz,Kr},GD,'same');

% (3) - Define output
[ny,nx,nz,nr] = size(GD);
% re-find indexes for output volume
yi = repmat(shiftdim(linspace(1,ny,PY),+1),[01 PX PZ]);
xi = repmat(shiftdim(linspace(1,nx,PX), 0),[PY 01 PZ]);
zi = repmat(shiftdim(linspace(1,nz,PZ),-1),[PY PX 01]);
ri = (I-min(I(:)))./range(I(:))*((1/Qr)-1)+1;
% calculate the pixel values for these locations
idx = (GW ~= 0);
D   = zeros(size(GD));
D(idx) = GD(idx)./GW(idx);
clearvars GD GW idx;
% interpolate the missing data
IBF = interpn(D,yi,xi,zi,ri);
clearvars D yi xi zi ri;
% remove pads
IBF = IBF(RY+1:NY+RY, RX+1:NX+RX, RZ+1:NZ+RZ);

function [K,L] = gaussk(sd)
if sd
  L = ceil(3.5*sd);
  K = exp(-0.5*((-L:+L)'/sd).^2);
  K = K./sum(K);
else
  L = 1;
  K = 1;
end
  














