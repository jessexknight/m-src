function [V] = binsphere(R)
[x,y,z] = ndgrid(-R:R);
SE = strel(sqrt(x.^2 + y.^2 + z.^2) <=R);
V = double(SE.getnhood());