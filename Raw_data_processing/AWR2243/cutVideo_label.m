function [] = cutVideo_label(fIn, fOut, beginFrame, endFrame) 
a = VideoReader(fIn);
vidObj = VideoWriter(fOut);
vidObj.FrameRate = a.FrameRate;
open(vidObj);
for img = beginFrame:endFrame
    b = read(a, img);
    writeVideo(vidObj,b)
end
close(vidObj)
delete(a)
end