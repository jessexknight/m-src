function [Zica A T mu] = ica(Z,r,dispFlag)
%--------------------------------------------------------------------------
% Syntax:       Zica = ica(Z,r);
%               Zica = ica(Z,r,dispFlag);
%               [Zica A T mu] = ica(Z,r);
%               [Zica A T mu] = ica(Z,r,dispFlag);
%               
% Inputs:       Z is an (d x n) matrix containing n samples of an
%               d-dimensional random vector
%               
%               r is the desired number of independent components
%               
%               [OPTIONAL] dispFlag = {true false} sets the stdout print
%               state. The default value is dispFlag = true
%               
% Outputs:      Zica is an (r x n) matrix containing the r independent
%               components - scaled to variance 1 - of the input samples
%               
%               A and T are the ICA transformation matrices such that
%               Zr = T \ pinv(A) * Zica + repmat(mu,1,n);
%               is the r-dimensional ICA approximation of Z
%               
%               mu is the (d x 1) sample mean of Z
%               
% Description:  This function performs independent component analysis (ICA)
%               on the input samples using the FastICA algorithm with 
%               Gaussian negentropy
%               
% Author:       Brian Moore
%               brimoor@umich.edu
%               
% Date:         April 26, 2015
%--------------------------------------------------------------------------

% Knobs
eps = 1e-6;         % Convergence criteria
maxSamples = 1000;  % Max # data points in sample mean calculation
maxIters = 100;     % Maximum # iterations

% Parse display flag
dispFlag = (nargin < 3) || dispFlag;

% Center and whiten input data
[Zcwt T mu] = ica_centerwhiten(Z);

% Parse whitened data
[d n] = size(Zcwt);

% Random initial weights
normRows = @(X) bsxfun(@times,X,1 ./ sqrt(sum(X.^2,2)));
W = normRows(rand(r,d));

% FastICA w/ Gaussian negentropy
k = 0;
err = inf;
while (err > eps) && (k < maxIters)
    % Increment counter
    k = k + 1;
    
    % Update weights
    Wlast = W; % Save last weights
    Sk = permute(Wlast * Zcwt,[1 3 2]);
    G = Sk .* exp(-0.5 * Sk.^2);
    Gp = Sk .* G;
    W = mean(bsxfun(@times,G,permute(Zcwt,[3 1 2])),3) + bsxfun(@times,mean(Gp,3),Wlast);
    W = normRows(W);
    
    % Decorrelate weights
    [U,S,~] = svd(W,'econ');
    W = U * diag(1 ./ diag(S)) * U' * W;
    
    % Update error
    err = max(1 - dot(W,Wlast,2));
    
    % Display progress
    if dispFlag == true
        sprintf('Iteration %i: max(1 - <w%i,w%i>) = %.4g\n',k,k,k - 1,err);
    end
end

% Transformation matrix
A = W;

% Independent components
Zica = A * Zcwt;
