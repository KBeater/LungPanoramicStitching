function [ATW, sATW] = arctan_window(L, M)
%ARCTAN_WINDOW Summary of this function goes here
%   Detailed explanation goes here
v = [(1-L):2:(L-1)].';
V = max(v);
ATW_raw = atan(M*v/V);
ATW_max = max(ATW_raw);
ATW = ATW_raw/(2*ATW_max) + 0.5;
half_factor = round(L/2) + 1;
sATW = ATW;
sATW(half_factor:end) = 1 - sATW(half_factor:end);
end
