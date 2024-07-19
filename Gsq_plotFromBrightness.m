% Plotting the g^2 map from the solve.mat
%% Gsq_plotFromSolve, Junyi Lin, Jun19 2024, Version 1

%% Housekeeping
clear all;
close all;

% Load the .mat file
dataPath = fullfile('DATA', 'static_verification', 'IMG_0765_preprocessing.mat');
load(dataPath);

% Extract necessary variables
g2 = arrayfun(@(p) mean(p.contactG2s), particle);
x = [particle.x];
y = [particle.y];
r = [particle.r];
N = length(particle);

% Create a figure for the scatter plot
figure(1);
imshow([dataPath(1:end-18),'.jpg']);
hold on;
scatter(x, y, r, g2, 'filled'); % Adjust size multiplier if needed
colormap jet; % Change colormap if needed
colorbar;

% Set axis properties for scatter plot
axis equal;
title('g2 Map - Scatter Plot');
xlabel('x position');
ylabel('y position');
set(gca, 'XGrid', 'off', 'YGrid', 'off'); % Turn off the grid

% Draw contact lines with thickness representing particle.contactG2s
for n = 1:N
    z = particle(n).z; % Get particle coordination number
    if z > 0 % If the particle does have contacts
        for m = 1:z % For each contact
            % Draw contact lines
            lineX(1) = particle(n).x;
            lineY(1) = particle(n).y;
            lineX(2) = lineX(1) + particle(n).r * cos(particle(n).betas(m));
            lineY(2) = lineY(1) + particle(n).r * sin(particle(n).betas(m));
            lineThickness = particle(n).contactG2s(m) * 0.15; % Line thickness based on contactG2s
            hold on; % Don't blow away the image
            plot(lineX, lineY, '-y', 'LineWidth', lineThickness); hold on;
        end
    end
end

% Define the grid for interpolation
gridX = linspace(min(x), max(x), 200);
gridY = linspace(min(y), max(y), 200);
[gridX, gridY] = meshgrid(gridX, gridY);

% Perform the interpolation
F = scatteredInterpolant(x', y', g2');
gridG2 = F(gridX, gridY);

% Create a figure for the contour plot
figure(2);
contourf(gridX, gridY, gridG2, 20, 'LineColor', 'none'); % Adjust number of contour levels if needed
colormap jet;
colorbar;

% Set axis properties for contour plot
axis equal;
title('g2 Map - Contour Plot');
xlabel('x position');
ylabel('y position');
set(gca, 'XGrid', 'off', 'YGrid', 'off'); % Turn off the grid
