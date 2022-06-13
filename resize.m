function [outFile] = resize(inFile)

% reads in image of person
% detects face, excludes background
% expands to include all features
% resizes to 112x92

face_Detector = vision.CascadeObjectDetector;
face_Detector.MergeThreshold = 20; 
% nose_Detector = vision.CascadeObjectDetector('Nose');
% nose_Detector.MergeThreshold = 20; 
% nose_Detector.UseROI = true;
% mouth_Detector = vision.CascadeObjectDetector('Mouth');
% mouth_Detector.MergeThreshold = 20; 
% mouth_Detector.UseROI = true;
% eye_Detector = vision.CascadeObjectDetector('EyePairSmall');  
% eye_Detector.UseROI = true;


I = imread(inFile); 
bbox = step(face_Detector,I);
% I=I(bbox(2):bbox(2)+bbox(4),bbox(1):bbox(1)+bbox(3));

% nbox = step(nose_Detector, I); % box around the nose
% nbox = nbox(1,:); % guess the first box is correct
% nbox=step(nose_Detector,I,bbox(1,:));
% ebox = step(eye_Detector,I,bbox(1,:)); % box around the eyes





% extend the eye box to include the eyebrows
% ebox(2) = ebox(2) - ebox(4);
% ebox(4) = 2*ebox(4);
% if (ebox(3)>350)
%     ebox(1)=ebox(1)-0.1*ebox(3);
%     ebox(3)=ebox(3)*1.2;
% end


% extend the box to include the mouth
% nbox(1) = nbox(1) - 0.1*nbox(3);
% nbox(2) = ebox(2) +  ebox(4);
% nbox(3) = 1.2*nbox(3);
% nbox(4) = 1.8*nbox(4);

% %left eye
% Leye = vision.CascadeObjectDetector('LeftEye'); 
% Leye.UseROI = true;
% lbox=step(Leye,I,ebox(1,:));
% 
% %right eye
% Reye = vision.CascadeObjectDetector('RightEye'); 
% Reye.UseROI = true;
% rbox=step(Reye,I,ebox(1,:));

% if (rbox(1,:)==lbox(1,:))
%     if (size(rbox,1)>1)
%         rbox(1,:)=rbox(2,:);
%     elseif (size(lbox,1)>1)
%         lbox(1,:)=lbox(2,:);
%     end
% end

%ensure photo is oriented properly
if isempty(bbox)
    I=imrotate(I,90);
    bbox = step(face_Detector,I);
    if isempty(bbox)
        I=imrotate(I,90);
        bbox = step(face_Detector,I);
        if isempty(bbox)
            I=imrotate(I,90); 
            bbox = step(face_Detector,I);
            if isempty(bbox)
                outFile=0;
                disp('Error: No face detected in image');
                return
            end
        end
    end
end


scale=112/92;                       %for proper dimensions
%extend box to include hair & chin
% bbox(2)=round(bbox(2)-0.1*bbox(4));
% bbox(4)=round(bbox(4)*1.2);

%extend box to include ears
% bbox(1)=round(bbox(1)-bbox(3)*0.8);
% bbox(3)=round(bbox(3)*1.4);

imshow(I);
hold on
rectangle('Position',bbox(1,:),'LineWidth',3,'LineStyle','-','EdgeColor','r'); %r -red, g-green,b-blue

title('Face Detection'); %title of the figure
hold off

height=bbox(4)*scale;
diff=round(0.5*(height-bbox(4)));
bbox(2)=bbox(2)-diff;
bbox(4)=height;

if bbox(2)<0
    bbox(2)=1;
end
if (bbox(1)+bbox(3)>size(I,2))
    bbox(3)=size(I,2)-bbox(1);
end
if (bbox(2)+bbox(4)>size(I,1))
    bbox(4)=size(I,2)-bbox(1);
end





rows=bbox(2) : (bbox(2)+bbox(4));
cols=bbox(1) : (bbox(1)+bbox(3));     

out=I(rows,cols,:);
out=rgb2gray(out);

downScale=112/size(out,1);
out=imresize(out,downScale);
out=im2uint8(out);
outFile=out;

end

