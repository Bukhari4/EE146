clear all
close all
clc

I = imread('./TESSTING/apple.jpg');
% I_g = rgb2gray(I);
% th = graythresh(I_g);
% mask = imbinarize(I_g,th);
% maskedRgbImage = bsxfun(@times, I, cast(mask, 'like', I));
% imshowpair(maskedRgbImage, mask, 'montage');

I_blur = imgaussfilt(I,5);
cform = makecform('srgb2lab');
I_lab = applycform(I_blur,cform);
ab = double(I_lab(:,:,2:3));
nrows = size(ab,1);
ncols = size(ab,2);
ab = reshape(ab,nrows*ncols,2);

nColors = 2;
% repeat the clustering 3 times to avoid local minima
[cluster_idx, cluster_center] = kmeans(ab,nColors,'distance','sqEuclidean', ...
                                      'Replicates',3);
pixel_labels = reshape(cluster_idx,nrows,ncols);
% figure, imshow(I);
figure, imshow(pixel_labels,[]), title('image labeled by cluster index');
target = pixel_labels(int32(nrows/2), int32(ncols/2));
pixel_labels = pixel_labels - 1;
M = zeros(nrows, ncols);
for i = 1:nrows
    for j = 1:ncols
        if pixel_labels(i,j) ~= target
            M(i,j) = 1;
        end
    end
end
masked_rgb_image = bsxfun(@times, I, cast(M, 'like', I));
% masked_rgb_image = I.*repmat(M,[1,1,3]);
figure, imshow(masked_rgb_image);
