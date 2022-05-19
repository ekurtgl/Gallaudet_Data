clc; clear; close all;

main = '/mnt/HDD04/Gallaudet_data/output/radar/microDoppler_mti/';
labels = [main 'md_labels/*.txt'];
crops = [main 'crop/'];

if ~exist(crops,'dir')
   mkdir(crops);
end

files = dir(labels);
numWordPerRecord = 5;

for i = 1:length(files)
    mss = ['Processing ' int2str(i) '/' num2str(length(files))];
    disp(mss);
    fname = files(i).name;
    md = [main fname(1:end-7) '.png'];
    mdim = imread(md);
    y_md = textread([files(i).folder '/' files(i).name]);
    underScores = strfind(md, '_');
    lastUnderScore = underScores(end);
    classStart = strfind(md, 'class');
    mainclass = str2num(md(classStart+5:lastUnderScore-1));
    partIdx = str2num(md(end-4));
    class = int2str((mainclass-1)*numWordPerRecord + partIdx);
    
    state = y_md(1);
    start = 1;
    cnt = 1;
    
    for j = 1:length(y_md)
         if y_md(j) == state
             continue
         else
             stop = j-1;
             if state == 0
                     start = j;
                     state = y_md(j);
                     continue
             end
             crop = mdim(:,start:stop,:);
             cropname = strcat(crops, fname(1:end-7), '_word', class, '_cnt', num2str(cnt), '.png');
             imwrite(crop,cropname)
             start = j;
             state = y_md(j);
             cnt = cnt + 1;
         end
    end
end

