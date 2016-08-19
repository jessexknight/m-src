function [B] = bindisk(r)
N = 2*r;
B = zeros(round(2*r));
for y = 1:N
    for x = 1:N
        H = sqrt((y-((N+1)/2))^2 + (x-((N+1)/2))^2);
        if H <= r
            B(y,x) = 1;
        end
    end
end