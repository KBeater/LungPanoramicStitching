function [DF, I, J, dI, dJ, v] = mov_frame(A, B, mod, L)
%MOV_FRAME mod = 1:4 (default = 1: MEAN-SQUARED ERROR), L = 25 (default)
%   Detailed explanation goes here
I = SH(A); J = SH(B);

% Sliding frame
v = zeros(1, L+1);
switch mod
    case 1
        v(1) = immse(I, J);
        for i = 1:L
            A = s_l(I, i); B = s_r(J, i);
            v(i+1) = immse(A, B);
        end
        [~, DF] = min(v);
    case 2
        v(1) = ssim(I, J);
        for i = 1:L
            A = s_l(I, i); B = s_r(J, i);
            v(i+1) = ssim(A, B);
        end
        [~, DF] = max(v);
    case 3
        v(1) = mean(double(I).*double(J), 'all');
        for i = 1:L
            A = s_l(I, i); B = s_r(J, i);
            v(i+1) = mean(double(A).*double(B), 'all');
        end
        [~, DF] = max(v);
    case 4
        v(1) = mean(abs(double(I)-double(J)), 'all');
        for i = 1:L
            A = s_l(I, i); B = s_r(J, i);
            v(i+1) = mean(abs(double(A)-double(B)), 'all');
        end
        [~, DF] = min(v);
    otherwise
        DF = 0;
        return
end

DF = DF-1;
dI = s_l(I, DF); dJ = s_r(J, DF);

% Functions
    function SF = SH(I)
        F = contrast_stretching(I);
        SF = F(21:320, end-139:end);
%         SF = F(20:200, 50:end);
    end

    function J = s_r(I, i)
        J = I(:, 1:end-i);
    end

    function J = s_l(I, i)
        J = I(:, 1+i:end);
    end
end
