clc;
clear;
close all;

low_threshold=40;
high_threshold=120;
videoFile=VideoReader("barrido_2.mp4");
num_frames=videoFile.numFrames;
%Pruebas codigo LIM
currentFrame=readFrame(videoFile);
A=read(videoFile,250);
A_gray=rgb2gray(A);
A_th=(A_gray>low_threshold) & (A_gray<high_threshold);

% A_gray=double(A_gray)/255;
figure(1);imshow(A_gray);title("Frame A");
% for i=2:num_frames
%     B=read(videoFile,i);
%     B_Gray=rgb2gray(B);
%     %B_Gray=double(B_Gray)/255;
%     DF = mov_frame(A_gray, B_Gray, 1, 25);
%     SI = stitching(contrast_stretching(A_gray), contrast_stretching(B_Gray), DF, 50);
%     figure(1);
%     imshow(SI);
%     A_gray=SI;
%     %A_gray=double(A_gray)/255;
% end
%SI = uint8(SI * 255);
B=read(videoFile,320);
B_Gray=rgb2gray(B);
B_th=(B_Gray>low_threshold) & (B_Gray<high_threshold);
figure(2);imshow(B_Gray);title("Frame B");
% DF = mov_frame(A_gray, B_Gray, 1, 25);
% disp(['Desplazamiento DF: ', num2str(DF)]);
% SI = stitching(A_gray, B_Gray, DF, 50);
% figure(3);
% imshow(SI);title("Stitching");

pointsA = detectKAZEFeatures(A_th);
pointsB = detectKAZEFeatures(B_th);
[featuresA, validPointsA] = extractFeatures(A_th, pointsA);
[featuresB, validPointsB] = extractFeatures(B_th, pointsB);
indexPairs = matchFeatures(featuresA, featuresB);
matchedPointsA = validPointsA(indexPairs(:, 1));
matchedPointsB = validPointsB(indexPairs(:, 2));
figure;
showMatchedFeatures(A_gray, B_Gray, matchedPointsA, matchedPointsB, 'montage');
title('Emparejamiento de puntos entre A y B usando KAZE');
tform = estimateGeometricTransform(matchedPointsB, matchedPointsA, 'affine');
outputView = imref2d(size(A_gray));
B_aligned = imwarp(B_Gray, tform, 'OutputView', outputView);
panorama = max(A_gray, B_aligned);
figure;
imshow(panorama);
title('Panorámica usando características KAZE');
% 
% %-----------
% panorama_th=(panorama>low_threshold) & (panorama<high_threshold);
% figure;
% imshow(panorama_th);
% title("Panorama")
% C=read(videoFile,300);
% C_Gray=rgb2gray(C);
% C_th=C_Gray>threshold;
% pointsPanorama = detectKAZEFeatures(panorama_th);
% pointsC = detectKAZEFeatures(C_th);
% [featuresPanorama, validPointsPanorama] = extractFeatures(panorama_th, pointsPanorama);
% [featuresC, validPointsC] = extractFeatures(C_th, pointsC);
% indexPairs = matchFeatures(featuresPanorama, featuresC);
% matchedPointsPanorama = validPointsPanorama(indexPairs(:, 1));
% matchedPointsC = validPointsC(indexPairs(:, 2));
% figure;
% showMatchedFeatures(panorama, C_Gray, matchedPointsPanorama, matchedPointsC, 'montage');
% title('Emparejamiento de puntos entre A y B usando KAZE');
% tform = estimateGeometricTransform(matchedPointsC, matchedPointsPanorama, 'affine');
% outputView = imref2d(size(panorama));
% C_aligned = imwarp(C_Gray, tform, 'OutputView', outputView);
% panorama = max(panorama, C_aligned);
% figure;
% imshow(panorama);
% title('Panorámica usando características KAZE');