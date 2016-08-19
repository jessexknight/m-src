scale  = 0.50;
prefix = '';
suffix = '';
ofmt   = 'JPEG';
idir   = 'C:\Users\jesse\Pictures\People\Mom & Dad\Summer 15\';
odir   = 'C:\Users\jesse\Pictures\People\Mom & Dad\Summer 15\small\';

if ~exist(odir,'dir')
    mkdir(odir);
end

D = dir(idir);
for d = 3:numel(D)
    try
        I = imread([idir,D(d).name]);
        fname = D(d).name(1:strfind(D(d).name,'.')-1);
        I = imresize(I,scale);
        imwrite(I,[odir,prefix,fname,suffix,'.',ofmt],ofmt);
    catch
        keyboard
    end
end