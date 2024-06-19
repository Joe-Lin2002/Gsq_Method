function post_img = image_process(image)
    % Process the images captured in Askari's Lab
    %% image_process, Junyi Lin, Jun8 2023, Version 2.

    % Convert image to HSV color space
    hsvImage = rgb2hsv(image);

    % Decrease saturation
    hsvImage(:, :, 2) = hsvImage(:, :, 2) * 1.15; % Decrease saturation factor (e.g., 0.5)

    % Convert the image back to RGB color space
    processedImage = hsv2rgb(hsvImage);

    % Adjust exposure
    exposedImage = processedImage * 1.2; % Decrease exposure factor (e.g., 0.8)

    % Invert the image
    invertedImage = imcomplement(exposedImage);

    % Save
    post_img = invertedImage;
end
