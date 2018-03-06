cam = webcam(1);
preview(cam);
DC = 'img_from_cam';
if(exist(DC,'dir')~=7)
    mkdir(DC);
end

for idx = 1:10
    img = snapshot(cam);
    fname = sprintf('%04d.jpg',idx);
    ffn = fullfile(DC,fname);
    imwrite(img,ffn);
    imshow(img);
    pause(1.0);
end

clear cam;
