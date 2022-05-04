clear; clc; close all;


datapath = '/mnt/HDD04/Gallaudet_data/raw data/*/';
outpath = '/mnt/HDD04/Gallaudet_data/output/radar/RDCs/';
% params = parameters();

files = dir([datapath '*Exp1*.bin']);
filenames2 = {files.name};

for z = 1:length(filenames2)
        temp{1,z} = filenames2{z}(1:end-10);
end
uniqs = unique(temp);

for j = 1:length(uniqs) % 12
        match = strfind(filenames2,uniqs{j}); % find matches
        idx = find(~cellfun(@isempty,match)); % find non-empty indices
        RDC = [];
        
        % concat RDCs with same names
        for r = 1:length(idx)
                tic
                msg = ['Processing: File: ' int2str(j) ' of ' int2str(length(uniqs)) ', Part ' ...
                        num2str(r) '/' num2str(length(idx))];   % loading message
                disp(msg);
                fname = fullfile(files(idx(r)).folder, files(idx(r)).name);
                temp2 = RDC_extract_awr2243(fname);
                RDC = [RDC temp2];
                toc
        end
        
        % divide exp 1 and 2 into 5 rdcs, exp 3 stays as is
        if length(idx) >= 1
                seqPerRecord = 5;
        else
                seqPerRecord = 1;
        end
        
        % divide into sub RDCs
        numChirps = floor(size(RDC,2)/seqPerRecord);
        for r =1:seqPerRecord
                tic
                msg = ['Saving File: ' int2str(j) ' of ' int2str(length(uniqs)) ', Part ' ...
                        num2str(r) '/' num2str(seqPerRecord)];   % loading message
                disp(msg);
                subRDC = RDC(:,(r-1)*numChirps+1:r*numChirps,:);
                savename = [outpath uniqs{j} '_part' num2str(r) '.mat'];
                save(savename, 'subRDC');
                toc
        end

end






