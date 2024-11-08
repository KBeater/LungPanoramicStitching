function J = contrast_stretching(I)
% Summary of this function goes here
%   Detailed explanation goes here
%J = imadjust(I, [0.02 0.5], [0.0 0.9], 1.2);
J = imadjust(I, [0.02 0.7], [0.0 1.0]);
end