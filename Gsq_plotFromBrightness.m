% Plotting the g^2 map from the solve.mat
%% Gsq_plotFromSolve, Junyi Lin, Jun19 2024, Version 1

%% Housekeeping
clear all;
close all;

% Load the .mat file
dataPath = fullfile('DATA', 'static_verification', 'IMG_0765_preprocessing.mat');
load(dataPath);

% Extract necessary variables
for i = 1:length(particle)
    g2(i) = mean(particle(i).contactG2s);
end
x = [particle.x];
y = [particle.y];
r = [particle.r];

% Create a figure for the scatter plot
figure;
scatter(x, y, r, g2, 'filled'); % Adjust size multiplier if needed
colormap jet; % Change colormap if needed
colorbar;

% Set axis properties for scatter plot
axis equal;
title('g2 Map - Scatter Plot');
xlabel('x position');
ylabel('y position');
set(gca, 'XGrid', 'off', 'YGrid', 'off'); % Turn off the grid

% Define the grid for interpolation
gridX = linspace(min(x), max(x), 200);
gridY = linspace(min(y), max(y), 200);
[gridX, gridY] = meshgrid(gridX, gridY);

% Perform the interpolation
F = scatteredInterpolant(x', y', g2');
gridG2 = F(gridX, gridY);

% Create a figure for the contour plot
figure;
contourf(gridX, gridY, gridG2, 20, 'LineColor', 'none'); % Adjust number of contour levels if needed
colormap jet;
colorbar;

% Set axis properties for contour plot
axis equal;
title('g2 Map - Contour Plot');
xlabel('x position');
ylabel('y position');
set(gca, 'XGrid', 'off', 'YGrid', 'off'); % Turn off the grid