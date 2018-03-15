function [features, metrics] = FeaturesColorExtractor(I) 
% Example color layout feature extractor. Designed for use with bagOfFeatures.
%
% Local color layout features are extracted from truecolor image, I and
% returned in features. The strength of the features are returned in
% metrics.
I=preprocess(I);
[~,~,P] = size(I);

isColorImage = P == 3; 

if isColorImage
    
    % Convert RGB images to the L*a*b* colorspace. The L*a*b* colorspace
    % enables you to easily quantify the visual differences between colors.
    % Visually similar colors in the L*a*b* colorspace will have small
    % differences in their L*a*b* values.
    Ilab = rgb2lab(I);                                                                             
      
    % Compute the "average" L*a*b* color within 16-by-16 pixel blocks. The
    % average value is used as the color portion of the image feature. An
    % efficient method to approximate this averaging procedure over
    % 16-by-16 pixel blocks is to reduce the size of the image by a factor
    % of 16 using IMRESIZE. 
    Ilab = imresize(Ilab, 1/16);
    
    % Note, the average pixel value in a block can also be computed using
    % standard block processing or integral images.
    
    % Reshape L*a*b* image into "number of features"-by-3 matrix.
    [Mr,Nr,~] = size(Ilab);    
    colorFeatures = reshape(Ilab, Mr*Nr, []); 
           
    % L2 normalize color features
    rowNorm = sqrt(sum(colorFeatures.^2,2));
    colorFeatures = bsxfun(@rdivide, colorFeatures, rowNorm + eps);
        
    % Augment the color feature by appending the [x y] location within the
    % image from which the color feature was extracted. This technique is
    % known as spatial augmentation. Spatial augmentation incorporates the
    % spatial layout of the features within an image as part of the
    % extracted feature vectors. Therefore, for two images to have similar
    % color features, the color and spatial distribution of color must be
    % similar.
    
    % Normalize pixel coordinates to handle different image sizes.
    xnorm = linspace(-0.5, 0.5, Nr);      
    ynorm = linspace(-0.5, 0.5, Mr);    
    [x, y] = meshgrid(xnorm, ynorm);
    
    % Concatenate the spatial locations and color features.
    features1 = [colorFeatures y(:) x(:)];
    
    % Use color variance as feature metric.
    metrics1  = var(colorFeatures(:,1:3),0,2);
else
    
    % Return empty features for non-color images. These features are
    % ignored by bagOfFeatures.
    features1 = zeros(0,5);
    metrics1  = zeros(0,1);     
end
[height,width,numChannels] = size(I);
if numChannels > 1
    grayImage = rgb2gray(I);
else
    grayImage = I;
end
gridStep = 8;
gridX = 1:gridStep:width;
gridY = 1:gridStep:height;

[x,y] = meshgrid(gridX,gridY);

gridLocations = [x(:) y(:)];
multiscaleGridPoints = [SURFPoints(gridLocations,'Scale',1.6);
    SURFPoints(gridLocations,'Scale',3.2);
    SURFPoints(gridLocations,'Scale',4.8);
    SURFPoints(gridLocations,'Scale',6.4)];
features2 = extractFeatures(grayImage,multiscaleGridPoints,'Upright',true);
metrics2 = var(features2,[],2);
%multiscaleSURFPoints = detectSURFFeatures(grayImage);
%features2 = extractFeatures(grayImage,multiscaleSURFPoints,'Upright',true);
%metrics2 = multiscaleSURFPoints.Metric;
 if nargout > 2
     varargout{1} = multiscaleGridPoints.Location;
 end

[M1 N1]=size(features1);
[M2 N2]=size(features2);
features=zeros(M1+M2,N1+N2);
metrics=zeros(M1+M2,1);
for i=1:M1
   for j=1:N1
    features(i,j)=features1(i,j);
    metrics(i)=metrics1(i);
   end
end
for i=M1+1:M2+M1
   for j=N1+1:N2+N1
    features(i,j)=features2(i-M1,j-N1);
    metrics(i)=metrics2(i-M1);
   end
end