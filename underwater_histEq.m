clc;clear;close all;

% % % --------------Output Folder Preparation--------------------% % %
outputDir = '~/Desktop/underwater_dataset/histEq/VOC2007/';

% Group the folder's name into cell
sub_dirs_1 = {fullfile(outputDir, 'Annotations'); fullfile(outputDir, 'JPEGImages'); fullfile(outputDir, 'ImageSets')};
sub_dirs_2 = cell(2, 1);
sub_dirs_temp = {'G0024172', 'G0024173', 'G0024174', 'YDXJ0003', 'YDXJ0013', 'YDXJ0012'};

for i = 1:2
    for j = 1:6
        sub_dirs_2{i}{j} = fullfile(sub_dirs_1{i}, sub_dirs_temp{j});
    end
end

% Mkdir folder
if ~exist(outputDir, 'dir')
    mkdir(outputDir);
end

for i = 1 : 3
    if ~exist(sub_dirs_1{i}, 'dir')
        mkdir(sub_dirs_1{i});
    end
end

for j = 1 : 6
    if ~exist(sub_dirs_2{2}{j}, 'dir')
        mkdir(sub_dirs_2{2}{j});
    end
end

outputDir_ImageSets_Main = fullfile(sub_dirs_1{3}, 'Main');

if ~exist(outputDir_ImageSets_Main, 'dir')
    mkdir(outputDir_ImageSets_Main);
end

% % % --------------Input Folder Preparation--------------------% % %
inputDir = '~/Desktop/underwater_dataset/raw_data/VOC2007/';

% Group the folder's name into cell
sub_dirs_3 = {fullfile(inputDir, 'Annotations'); fullfile(inputDir, 'JPEGImages'); fullfile(inputDir, 'ImageSets')};
sub_dirs_4 = cell(2, 1);

for i = 1:2
    for j = 1:6
        sub_dirs_4{i}{j} = fullfile(sub_dirs_3{i}, sub_dirs_temp{j});
    end
end

% % % --------------Copy File--------------------% % %
inputDir_ImageSets = fullfile(inputDir, 'ImageSets');
inputDir_Annotations = fullfile(inputDir, 'Annotations');
outputDir_ImageSets = fullfile(outputDir, 'ImageSets');
outputDir_Annotations = fullfile(outputDir, 'Annotations');
copyfile '~/Desktop/underwater_dataset/raw_data/VOC2007/ImageSets' '~/Desktop/underwater_dataset/histEq/VOC2007/ImageSets'
copyfile '~/Desktop/underwater_dataset/raw_data/VOC2007/Annotations' '~/Desktop/underwater_dataset/histEq/VOC2007/Annotations'

% % % --------------Process Image--------------------% % %
for j = 1 : 6
    dir_nums = size(dir(sub_dirs_4{2}{j}), 1) - 2;
    for k = 1 : dir_nums
        dir_name = fullfile(sub_dirs_4{2}{j}, num2str(k-1, '%.3d'));
        outputDirID = fullfile(sub_dirs_2{2}{j}, num2str(k-1, '%.3d'));
        if ~exist(outputDirID, 'dir')
            mkdir(outputDirID);
        end
        RGBFileInfo = dir(fullfile(dir_name, '*jpg'));
        RGBFrameCount = length(RGBFileInfo);
        for indFrame = 1 : RGBFrameCount
            RGBFileName = RGBFileInfo(indFrame).name;
            RGBImage = imread(fullfile(dir_name, RGBFileName));
            img_ori = double(RGBImage);
            % [h, w, c] = size(img_ori);
            
            % R = img_ori(:, :, 1);
            % G = img_ori(:, :, 2);
            % B = img_ori(:, :, 3);
            
            hsv_img = rgb2hsv(img_ori);
            I = hsv_img(:, :, 3);
            hsv_img(:, :, 3) = HistEq(I);
            RGB_eq = hsv2rgb(hsv_img);
            RGB_eq = uint8(RGB_eq);
            figure(1);
            subplot(1, 2, 1);
            imshow(RGBImage);
            subplot(1, 2, 2);
            imshow(RGB_eq);
            imwrite(RGB_eq, fullfile(outputDirID, RGBFileName));
            hold on;
        end
    end
end 

