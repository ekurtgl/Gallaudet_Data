clear; clc; close all;

datapath = '/mnt/HDD04/Gallaudet_data/output/radar/RDCs/';
outpath = '/mnt/HDD04/Gallaudet_data/output/radar/microDoppler/';

files = dir([datapath '*Exp0*.mat']);

for i = 1:length(files)
        tic
        msg = ['Processing File: ' int2str(i) ' of ' int2str(length(files))]; 
        disp(msg);
        load(fullfile(files(i).folder, files(i).name));
        mD_Out = [outpath files(i).name(1:end-3) 'png'];
        RDC_to_microDopp(subRDC, mD_Out);
        toc
end









