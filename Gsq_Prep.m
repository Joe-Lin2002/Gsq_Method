% Photoelastic material analysis code based on codework of Karen E. Daniels, Jonathan E. Kollmer, James G. Puckett;
% Photoelastic force measurements in granular materials.
% Rev. Sci. Instrum. 1 May 2017; 88 (5): 051808.
% https://doi.org/10.1063/1.4983049
%% Gsq_Prep, Junyi Lin, Jun19 2024, Version 1

%% Housekeeping
clear all;
close all;

%% File Prep w/ Input
%Loading location defining
file_name = 'IMG_0765.jpg';
directory = 'DATA/static_verification/';
files = dir([directory, file_name]); %Which files are we processing?

% Load the image to get its dimensions
img = imread([directory, file_name]);
[imageHeight, imageWidth, ~] = size(img); % Get image dimensions

nFrames = length(files); %How many files are we processing ?

load_calibration = false; %Whether retrieve previous value set?
save_calibration = true; %Whether save values set defined here?

if load_calibration == true
    load([directory,file_name(1:end-4),'_config.mat']);
elseif load_calibration == false %Manually define values and save
    pxPerMeter = 0.01/194;
    verbose = true; %Generates lots of plots showing results

    % Hough Transform Values

    doParticleDetectionH = true; %Detect particles using Hough Transform?

    RlargeH = [180 200]./2; %What radius (in pixels) range do we expect for the large discs?
    RsmallH = [140 160]./2; %What radius (in pixels) range do we expect for the small discs?
    SL = 0.96; %Sensitivity of the Hough Transform disc detetcor, exact value is Voodo magic...
    SS = 0.96; %Sensitivity of the Hough Transform disc detetcor, exact value is Voodo magic...

    findNeighbours = true;

    fsigma = 390.08; %photoelastic stress coefficient
    g2cal = 100; %Calibration Value for the g^2 method, can be computed by joG2cal.m
    dtol = 5; % How far away can the outlines of 2 particles be to still be considered Neighbours
    override = 1770; % Self assign a value for the top wall for container detection

    contactG2Threshold = 10; %sum of g2 in a contact area larger than this determines a valid contact
    CR = 25; %radius around a contactact point that is checked for contact validation

    if save_calibration==true
        save([directory,file_name(1:end-4),'_config.mat']);
    end
end

%% Processing
for frame = 1:nFrames %Loops for total number of images
    figure(1)
    imshow(img);

    
    imageFile = [directory,files(frame).name]; %input filename
    img = image_process(imread(imageFile)); %read a color image that has particles in red and forces in green channel
    Rimg = img(:,:,1); %particle image
    Gimg = img(:,:,2); %force image
    Gimg = im2double(Gimg);
    Rimg = im2double(Rimg);
    Gimg = Gimg-0.5*Rimg;
    Gimg = Gimg.*(Gimg > 0);
    Gimg = imadjust(Gimg,stretchlim(Gimg));
    particle = particle_trace(Rimg, RlargeH, SL, RsmallH, SS, pxPerMeter, fsigma);
    
    N = length(particle);

    % Delete overlapping particles
    % Initialize a logical array to mark particles for deletion
    toDelete = false(1, N);

    for n = 1:N
        if particle(n).color == 'b' % Only consider small particles for deletion
            % Check if the center of the small particle is within the radius of another circle
            for pointer = 1:N
                if n ~= pointer % Ensure not to compare the particle with itself
                    distance = sqrt((particle(n).x - particle(pointer).x)^2 + (particle(n).y - particle(pointer).y)^2);
                    if distance < (0.5 * particle(pointer).r)
                        toDelete(n) = true;
                        break; % Break the inner loop as we only need to mark the particle once
                    end
                end
            end
        end

        % Check if part of the circle is outside the image boundaries
        if particle(n).x - particle(n).r < 0 || particle(n).x + particle(n).r > imageWidth || ...
                particle(n).y - particle(n).r < 0 || particle(n).y + particle(n).r > imageHeight
            toDelete(n) = true;
        end
    end

    % Delete particles marked for deletion
    particle(toDelete) = [];

    % Update N after deletion and renumbering
    for i = 1:length(particle)
        particle(i).id = i;
    end
    N = length(particle);

    figure(1)
    for n=1:N
        viscircles([particle(n).x; particle(n).y]', particle(n).r,'EdgeColor',particle(n).color); %draw particle outline
        hold on
        plot(particle(n).x,particle(n).y,'rx'); %Mark particle centers
        text(particle(n).x,particle(n).y,num2str(particle(n).id),'Color','w');
    end
end