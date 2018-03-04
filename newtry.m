clear all
close all
clc
trainingSets = imageSet('C:\Users\Bukhari\Documents\MATLAB\EE146\Project\try3\TRAININGSET','recursive');
validationSets = imageSet('C:\Users\Bukhari\Documents\MATLAB\EE146\Project\try3\TESTSET','recursive');
% { imgSets.Description } % display all labels on one line
% [imgSets.Count]         % show the corresponding count of images
% minSetCount = min([imgSets.Count]); % determine the smallest amount of images in a category
% 
% Use partition method to trim the set.
% imgSets = partition(imgSets, minSetCount, 'randomize');

% Notice that each set now has exactly the same number of images.
% [imgSets.Count]
% [trainingSets, validationSets] = partition(imgSets, 0.3, 'randomize');
extractorFcn = @FeaturesColorExtractor;
bag = bagOfFeatures(trainingSets,'CustomExtractor',extractorFcn,'VocabularySize',2000)
%bag = bagOfFeatures(trainingSets, 'VocabularySize',2000)%,'Upright',false);
img = read(trainingSets(1), 1);
featureVector = encode(bag, img);

% Plot the histogram of visual word occurrences
figure
bar(featureVector)
title('Visual word occurrences')
xlabel('Visual word index')
ylabel('Frequency of occurrence')
categoryClassifier = trainImageCategoryClassifier(trainingSets, bag);

confMatrix = evaluate(categoryClassifier, trainingSets);

confMatrix = evaluate(categoryClassifier, validationSets);

% Compute average accuracy
mean(diag(confMatrix));
