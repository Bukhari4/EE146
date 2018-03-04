imgTestSets = imageSet('C:\Users\Bukhari\Documents\MATLAB\EE146\Project\try3\TESSTING','recursive')
[labelIdx, scores] = predict(categoryClassifier, imgTestSets);

% Display the string label
categoryClassifier.Labels(labelIdx)
