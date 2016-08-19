% Jesse Knight 2015
% Copyright: Khademi Lab (Image Analysis in Medicine Lab).
%            Not to be distributed or copied.
% 
% Combine images I1 and I2 to an RGB image.
% Vary for each: colourmap and minmax range...
% First two minmax ranges and colourmaps will 
% be assigned to I1 and I2 respectively.

function [VC] = volcombine(V1,V2,varargin)

if size(V1) ~= size(V2)
    error('Images must have the same size.');
end

[minmax,clrmap] = parseinputs(varargin);

VC = 0.5 * img2rgb(V1,clrmap{1},minmax{1}) + ...
     0.5 * img2rgb(V2,clrmap{2},minmax{2});
close all;

function [minmax,clrmap] = parseinputs(argsin)
minmax{1} = [];
minmax{2} = [];
minmaxctr = 1;
clrmap{1} = gray;
clrmap{2} = gray;
clrmapctr = 1;
% handle arguments based on their dimensions
for a = 1:numel(argsin)
    sizea = size(argsin{a});
    if sizea(2) == 3 % clrmap
        if clrmapctr <= 2
            clrmap{clrmapctr} = argsin{a};
            clrmapctr = clrmapctr + 1;
        end
    else % min-max
        if minmaxctr <= 2
            if sizea(1) == 0
                minmax{minmaxctr} = [];
            elseif sizea(1) == 1
                minmax{minmaxctr} = argsin{a};
            end
            minmaxctr = minmaxctr + 1;
        end
    end
end

