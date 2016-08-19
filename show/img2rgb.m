function rgb = img2rgb(img, map, minmax)
L   = size(map,1);
img = minmax(1) + (double(img) ./ range(minmax));
zz  = img == 0;
ci  = ceil(L * img / max(img(:)));
ci(zz) = 1;

isize = size(img);
R = reshape(map(ci,1),isize);
G = reshape(map(ci,2),isize);
B = reshape(map(ci,3),isize);
R(zz) = 0;
G(zz) = 0;
B(zz) = 0;

rgb = cat(numel(isize)+1, R, G, B);

                      

