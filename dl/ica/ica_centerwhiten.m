function [Zcw T mu] = ica_centerwhiten(Z)
%--------------------------------------------------------------------------
% Syntax:       Zcw = ica_centerwhiten(Z);
%               [Zcw T] = ica_centerwhiten(Z);
%               [Zcw T mu] = ica_centerwhiten(Z);
%               
% Inputs:       Z is an (d x n) matrix containing n samples of a
%               d-dimensional random vector
%               
% Outputs:      Zcw is the centered and whitened version of Z
%               
%               T is the (d x d) whitening transformation of Z
%               
%               mu is the (d x 1) sample mean of Z
%               
% Description:  This function returns the centered (zero-mean) and whitened
%               (identity covariance) version of the input samples
%               
%               NOTE: Z = T \ Zcw + repmat(mu,1,n);
%               
% Author:       Brian Moore
%               brimoor@umich.edu
%               
% Date:         April 26, 2015
%--------------------------------------------------------------------------

% Center data
[Zc mu] = ica_center(Z);

% Whiten data
[Zcw T] = ica_whiten(Zc);
