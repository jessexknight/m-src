function [] = savefig(savename)
drawnow;
frame = getframe(gcf);
imwrite(frame.cdata,savename,'PNG');

