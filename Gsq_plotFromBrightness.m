% Plotting the g^2 map from the solve.mat
%% Gsq_plotFromSolve, Junyi Lin, Jun19 2024, Version 1

%% Housekeeping
clear all;
close all;

% Load the .mat file
dataPath = fullfile('DATA', 'static_verification', 'IMG_0765_preprocessing.mat');
load(dataPath);

% Extract necessary variables
g2 = arrayfun(@(p) mean(p.contactG2s, 'omitnan'), particle); % Ignore NaNs in mean calculation
x = [particle.x];
y = [particle.y];
r = [particle.r];
N = length(particle);

% Normalize g2 values to the range [0, 1], ignoring NaNs
g2_min = min(g2(~isnan(g2)));
g2_max = max(g2(~isnan(g2)));
g2_normalized = (g2 - g2_min) / (g2_max - g2_min);

% Create a figure for the scatter plot with back picture and lines
figure(1);
imshow([dataPath(1:end-18), '.jpg']);
hold on;
scatter(x, y, r, g2, 'filled'); % Adjust size multiplier if needed
colormap jet; % Change colormap if needed
colorbar;

% Draw contact lines with transparency representing particle.contactG2s
for n = 1:N
    z = particle(n).z; % Get particle coordination number
    if z > 0 % If the particle does have contacts
        for m = 1:z % For each contact
            % Draw contact lines
            lineX = [particle(n).x, particle(n).x + particle(n).r * cos(particle(n).betas(m))];
            lineY = [particle(n).y, particle(n).y + particle(n).r * sin(particle(n).betas(m))];
            contactG2 = particle(n).contactG2s(m);
            if ~isnan(contactG2)
                contactG2_normalized = (contactG2 - g2_min) / (g2_max - g2_min); % Normalize alpha to [0, 1] range
                contactG2_normalized = max(0, min(1, contactG2_normalized)); % Clamp to [0, 1]
                patch(lineX, lineY, 'y', 'EdgeAlpha', contactG2_normalized, 'LineWidth', 2); % Use patch for transparency
            end
        end
    end
end

% Set axis properties for the scatter plot
axis equal;
title('g2 Map - Scatter Plot with Lines');
xlabel('x position');
ylabel('y position');
set(gca, 'XGrid', 'off', 'YGrid', 'off'); % Turn off the grid

% Define the grid for interpolation
gridX = linspace(min(x), max(x), 200);
gridY = linspace(min(y), max(y), 200);
[gridX, gridY] = meshgrid(gridX, gridY);

% Perform the interpolation
F = scatteredInterpolant(x', y', g2', 'linear', 'none'); % Handle NaNs in interpolation
gridG2 = F(gridX, gridY);

% Create a figure for the contour plot
figure(2);
contourf(gridX, gridY, gridG2, 20, 'LineColor', 'none'); % Adjust number of contour levels if needed
colormap jet;
colorbar;

% Set axis properties for the contour plot
axis equal;
title('g2 Map - Contour Plot');
xlabel('x position');
ylabel('y position');
set(gca, 'XGrid', 'off', 'YGrid', 'off'); % Turn off the grid

% Create a figure for the line structure plot
figure(3);

% Draw contact lines with transparency representing particle.contactG2s
for n = 1:N
    z = particle(n).z; % Get particle coordination number
    if z > 0 % If the particle does have contacts
        for m = 1:z % For each contact
            % Draw contact lines
            lineX = [particle(n).x, particle(n).x + particle(n).r * cos(particle(n).betas(m))];
            lineY = [particle(n).y, particle(n).y + particle(n).r * sin(particle(n).betas(m))];
            contactG2 = particle(n).contactG2s(m);
            if ~isnan(contactG2)
                contactG2_normalized = (contactG2 - g2_min) / (g2_max - g2_min); % Normalize alpha to [0, 1] range
                contactG2_normalized = max(0, min(1, contactG2_normalized)); % Clamp to [0, 1]
                patch(lineX, lineY, 'y', 'EdgeAlpha', contactG2_normalized, 'LineWidth', 2); % Use patch for transparency
            end
        end
    end
end

% Set axis properties for the line structure plot
axis equal;
title('Contact Line Structure');
xlabel('x position');
ylabel('y position');
set(gca, 'XGrid', 'off', 'YGrid', 'off'); % Turn off the grid
