% imgTestSets = imageSet('C:\Users\Bukhari\Documents\MATLAB\EE146\Project\try3\TESSTING','recursive')
% [labelIdx, scores] = predict(categoryClassifier, imgTestSets);

%cam = webcam('Lenovo EasyCamera')
I = snapshot(cam);
[labelIdx, scores] = predict(categoryClassifier, I);
imshow(I)
% Display the string label
s=categoryClassifier.Labels(labelIdx)
text = char(s);
NET.addAssembly('System.Speech');
obj = System.Speech.Synthesis.SpeechSynthesizer;
obj.Volume = 100;
Speak(obj, text);
