cam = webcam(1);
preview(cam);
DC = 'img_from_cam';
if(exist(DC,'dir')~=7)
    mkdir(DC);
end
cnt = 1;
while(true)
    img = snapshot(cam);
    fname = sprintf('%04d.jpg',cnt);
    ffn = fullfile(DC,fname);
    cnt = cnt+1;  
%     imwrite(data,ffn);
    imshow(img);
    pause(1.0);
end

% clear cam;
