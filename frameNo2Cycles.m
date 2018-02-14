function time = frameNo2Cycles(frameNo)
TimeVector = [0:1/16:10 , 10.25:1/4:390, 390.0625:1/16:400 ]';
time = TimeVector(frameNo);
end
