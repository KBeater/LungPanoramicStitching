function SI = stitching(A, B, DF, SL)
%STITCHING SL = 50 (default)
%   Detailed explanation goes here
% Previous DF
PDF = size(A, 2) - size(B, 2);
% Arctan window
overlap_section = cat(3, A(:, PDF+DF+1:end), B(:, 1:end-DF));
L = size(overlap_section, 2);
ATW = arctan_window(L, SL);

% Mask
ML_ATW = repmat((1-ATW).', size(overlap_section, 1), 1);
MR_ATW = repmat(ATW.', size(overlap_section, 1), 1);

% Weighted average (BSW)
overlap = uint8(double(overlap_section(:, :, 1)).*ML_ATW + double(overlap_section(:, :, 2)).*MR_ATW);
SI = [A(:, 1:PDF+DF), overlap , B(:, end-DF+1:end)];
end
