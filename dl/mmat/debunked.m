% Want A*B: expected size [500 70 300]
A = randn([500,40]);
B = randn([40,70,300]);
% Using mmat
tic;
C = mmat(A,B);
fprintf('mmat time: %.05f seconds\n',toc);
% Using loops
tic;
C = zeros([size(A,1),size(B,2),size(B,3)]);
for c = 1:size(B,3)
  C(:,:,c) = A*B(:,:,d);
end;
fprintf('loop time: %.05f seconds\n',toc);
% Workstation: MATLAB R2011a, Win-10-64, i7(4GHz), 16GB RAM