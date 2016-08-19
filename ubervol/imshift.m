function [IS] = imshift(I,T)
pos = sign(T) > 0;
IS = I;
if pos(1) % down
    IS = padarray(IS(1+T(1):end,:,:),[+T(1),0,0],'replicate','post');
else      % up
    IS = padarray(IS(1:end+T(1),:,:),[-T(1),0,0],'replicate','pre');
end
if pos(2) % right
    IS = padarray(IS(:,1+T(2):end,:),[0,+T(2),0],'replicate','post');
else      % left
    IS = padarray(IS(:,1:end+T(2),:),[0,-T(2),0],'replicate','pre');
end
if numel(pos) >= 3
    if pos(3) % forward
        IS = padarray(IS(:,:,1+T(3):end),[0,0,+T(3)],'replicate','post');
    else      % backward
        IS = padarray(IS(:,:,1:end+T(3)),[0,0,-T(3)],'replicate','pre');
    end
end