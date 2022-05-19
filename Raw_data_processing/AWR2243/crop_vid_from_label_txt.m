clc; clear; close all;

main = '/mnt/HDD04/Gallaudet_data/output/webcam/';
raw_vids = [main 'exp1_split_to_5/'];
labels = '/mnt/HDD04/Gallaudet_data/output/radar/microDoppler/md_labels/*.txt';
crops = [main 'crop/'];

if ~exist(crops,'dir')
   mkdir(crops);
end

files = dir(labels);
numWordPerRecord = 5;
delay_btw_radarANDvideo = 20; % 30 in terms of frames

for i = 1:length(files)
        tic
    mss = ['Processing ' int2str(i) '/' num2str(length(files))];
    disp(mss);
    
    fname = files(i).name;
    
    vidname = [raw_vids fname(1:end-7) '.mp4.avi'];
    vid = VideoReader(vidname);
    num_frm = vid.NumberofFrames;
    delete(vid)

    y_md = textread([files(i).folder '/' files(i).name]);
    y_vid = zeros(1,num_frm);
    ratio = length(y_md) / length(y_vid);
%     y_md(round(end-delay_btw_radarANDvideo*ratio): end) =[];
%     y_vid(1:delay_btw_radarANDvideo) =[];
%     ratio = length(y_md) / length(y_vid);
    
    for j = 1:length(y_vid) - 1
          y_vid(j) = y_md(floor(ratio * j + 1));
    end
    y_vid(end) = y_md(end);
    
    for j = 1:delay_btw_radarANDvideo
            y_vid = circshift(y_vid, -1);
            y_vid(1) = 0;  % make sure shifting doesn't aliase to the beginning
    end
    
    underScores = strfind(files(i).name, '_');
    lastUnderScore = underScores(end-1);
    classStart = strfind(files(i).name, 'class');
    mainclass = str2num(files(i).name(classStart+5:lastUnderScore-1));
    partIdx = str2num(files(i).name(end-7));
    class = int2str((mainclass-1)*numWordPerRecord + partIdx);
    
    state = y_vid(1);
    start = 1;
    cnt = 1;
    
    for j = 1:length(y_vid)
         if y_vid(j) == state
             continue
         else
             stop = j-1;
             if state == 0
                     start = j;
                     state = y_vid(j);
                     continue
             end
             cropname = strcat(crops, fname(1:end-7), '_word', class, '_cnt', num2str(cnt), '.avi');
             cutVideo_label(vidname, cropname, start, stop)
             start = j;
             state = y_vid(j);
             cnt = cnt + 1;
         end
    end
    toc
end

