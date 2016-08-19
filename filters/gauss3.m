function [G] = gauss3(SD,N)
g1  = normpdf(linspace(-3.5*SD,3.5*SD,N),0,SD);
g3a = padarray(shiftdim(g1,-1),[N-1, N-1, 0  ],'replicate','post');
g3b = padarray(g1'*g1,         [0,   0,   N-1],'replicate','post');
G = g3a.*g3b;
G = G./sum(G(:));


