clc; clear; close all;

impath = 'microDoppler\';
cropImPath = [impath 'crop\'];
labelPath = [impath 'md_labels\'];
numWordPerRecord = 5;

pattern = strcat(impath, '*.png');    % file pattern
files = dir(pattern);

m = 30;
n = 200;
I_MAX = length(files);

for i = 218:I_MAX
    
    fig = fullfile(files(i).folder,files(i).name);
    fname = files(i).name(1:end-4);
    imlabelname = [labelPath files(i).name(1:end-4) '_md.txt'];
    
    image = imread(fig);
    imlen = size(image,2);
    y_im = zeros(1,imlen);
    underScores = strfind(files(i).name, '_');
    lastUnderScore = underScores(end);
    classStart = strfind(files(i).name, 'class');
    mainclass = str2num(files(i).name(classStart+5:lastUnderScore-1));
    partIdx = str2num(files(i).name(end-4));
    class = int2str((mainclass-1)*numWordPerRecord + partIdx);
    
    hFigure = figure(1);
    set(hFigure, 'ToolBar', 'none');
    imshow(image)
    set(gcf, 'units','normalized','outerposition',[.1 .2 .7 .7]); % 8 8 

    for count = 1:numWordPerRecord
        msg = strcat(['Processing File ', int2str(i),'/',int2str(I_MAX),...
        ' | File: ',files(i).name,' | ', num2str(count), '. Crop, Class: ', class]);
        disp(msg)
        movegui('north')
        
        h = imrect(gca,[150 40 m n]);
        if count ~= 1 % numWordPerRecord
            delete(h); 
            h = imrect(gca,[position(1)+position(3)+30 40 m n]);
        end
        position = round(wait(h)); %[left to right, top to bottom, x length, y length]
        m = position(3);
        delete(h); 
        
        cropColor = imcrop(image, position);
        saveColor = strcat(cropImPath, fname, '_word', class, '_cnt', num2str(count), '.png');
        imwrite(cropColor, saveColor);
        y_im(position(1):position(1)+position(3)) = str2num(class); %#ok<*ST2NM>
        y_im = y_im(1:imlen); % make sure it doesn't go beyond the length
    end
    dlmwrite(imlabelname, y_im,'delimiter',' ');
    close all
end

