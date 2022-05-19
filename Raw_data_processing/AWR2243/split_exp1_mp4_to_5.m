clc; clear; close all;



raw_vids = '/mnt/HDD04/Gallaudet_data/raw data/*/*.mp4';
crops = '/mnt/HDD04/Gallaudet_data/output/webcam/exp1_split_to_5/';

files = dir(raw_vids);

numClassPerRecord = 5;
skippep_files = {};
cnt = 1;
for i = 281:length(files)
        try
                vidname = fullfile(files(i).folder, files(i).name);
                vid = VideoReader(vidname);
                num_frm = vid.NumberOfFrames;
                
                for p = 1:numClassPerRecord
                        tic
                        msg = ['File ' int2str(i) '/' int2str(length(files)) ', vid # ' int2str(p)];
                        disp(msg);
                        beginFrame = round((num_frm/numClassPerRecord) * (p-1) + 1);
                        endFrame = floor((num_frm/numClassPerRecord) * p);
                        fOut = [crops files(i).name(1:end-4) '_part' int2str(p) '.mp4'];
                        cutVideo_label(vidname, fOut, beginFrame, endFrame)
                        toc
                end
        catch ME
                skippep_files{cnt} = vidname;
                cnt = cnt + 1;
                disp(['Skipping ' int2str(i) '/' int2str(length(files))  ', vid # ' int2str(p) ' --> ' files(i).name]);
                continue
        end
        
end







