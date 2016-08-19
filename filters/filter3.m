function [IF] = filter3(I,filtfcn,W)
i3size = size(I);
ipsize = i3size + [0,2*W,0];
i2size = [ipsize(1),ipsize(2)*ipsize(3)];

% pad along x, then reshape (append along x)
I2  = reshape(padarray(I,[0,W,0],'replicate','both'),i2size);
% median filter (MEX), then reshape (unwrap x -> z)
IF = reshape(filtfcn(I2),ipsize);
% unpad
IF = IF(:,W+1:end-W,:);



