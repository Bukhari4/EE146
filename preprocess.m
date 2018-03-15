function masked_rgb_image=preprocess(I)
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
    target = pixel_labels(1, 1);
    M = zeros(nrows, ncols);
    for i = 1:nrows
        for j = 1:ncols
            if pixel_labels(i,j) ~= target
                M(i,j) = 1;
            end
        end
    end
    se = strel('disk',10);
    M = imclose(M,se);
    masked_rgb_image = bsxfun(@times, I, cast(M, 'like', I));
end