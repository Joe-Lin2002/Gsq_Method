% Photoelastic material analysis based on Karen E. Daniels, Jonathan E. Kollmer, James G. Puckett; 
% Photoelastic force measurements in granular materials. 
% Rev. Sci. Instrum. 1 May 2017; 88 (5): 051808. 
% https://doi.org/10.1063/1.4983049
%% Gsq_Prep, Junyi Lin, Jun19 2024, Version 1

%% Housekeeping
clear all;
close all;

%% File Prep
%Loading location defining
file_name = 'IMG_0765.jpg';
directory = 'DATA/static_verification/';
files = dir([directory, file_name]); %Which files are we processing?

% Load the image to get its dimensions
img = imread([directory, file_name]);
[imageHeight, imageWidth, ~] = size(img); % Get image dimensions

nFrames = length(files); %How many files are we processing ?