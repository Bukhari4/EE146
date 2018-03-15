 imgTestSets = imageSet('C:\Users\Bukhari\Documents\MATLAB\EE146\Project\try3\TESSTING','recursive')
%  [labelIdx, scores] = predict(categoryClassifier, imgTestSets);
%  categoryClassifier.Labels(labelIdx)


for idx = 1:100
   % Acquire a single image.
   img = snapshot(cam);

end
I=preprocess(img);
[labelIdx, scores] = predict(categoryClassifier, img);
imshow(I)
% Display the string label
s=categoryClassifier.Labels(labelIdx)
text = char(s)
NET.addAssembly('System.Speech');
obj = System.Speech.Synthesis.SpeechSynthesizer;
obj.Volume = 100;
Speak(obj, text);
