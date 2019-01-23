clc;clear;close all;

% % % --------------Output Folder Preparation--------------------% % %
outputDir = '~/Desktop/underwater_dataset/CLAHE/VOC2007/';

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
            [h, w, c] = size(img_ori);
            
            clip_limit = 0.03;
            tile_num = [round(h/100),round(w/100)];
            if tile_num(1)<2
                tile_num(1)=2;
            end
            if tile_num(2)<2
                tile_num(2)=2;
            end
            
            hsv_img=rgb2hsv(RGBImage);
            hsv_img(:,:,3) = adapthisteq(hsv_img(:,:,3),'NumTiles', tile_num,'ClipLimit',clip_limit);
            RGB_clahe=hsv2rgb(hsv_img);
            
            figure(1);
            subplot(1, 2, 1);
            imshow(RGBImage);
            subplot(1, 2, 2);
            imshow(RGB_clahe);
            imwrite(RGB_clahe, fullfile(outputDirID, [num2str(indFrame-1, '%.4d') '.jpg']));
            hold on;
        end
    end
end 

