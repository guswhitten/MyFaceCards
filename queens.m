function [] = queens(name)

%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

I = resize(['ins/' name '.jpg']);

nose_detector = vision.CascadeObjectDetector('Nose');
eye_detector = vision.CascadeObjectDetector('EyePairSmall');   

nbox = step(nose_detector, I); % box around the nose
nbox = nbox(1,:); % guess the first box is correct
ebox = step(eye_detector, I); % box around the eyes

% extend the eye box to include the eyebrows
ebox(2) = ebox(2) - 0.8*ebox(4);
ebox(4) = 1.8*ebox(4);

%coulson's code
% ebox(1) = ebox(1)-0.1*ebox(3);
% ebox(3) = 1.2*ebox(3);

% extend the box to include the mouth
nbox(1) = nbox(1) - 0.1*nbox(3);
nbox(2)=ebox(2)+ebox(4);
nbox(3) = 1.2*nbox(3);
nbox(4) = 1.55*nbox(4);

%coulson's code
% nbox(1) = nbox(1) - 0.5*nbox(3);
% nbox(2) = ebox(2)+ebox(4);
% nbox(3) = 1.9*nbox(3);
% nbox(4) = 2.3*nbox(4);

%find center of nose Haar box
nx = nbox(1) + nbox(3)/2;
ny = nbox(2) + nbox(4)/2;

I_gray = I;
% filter high frequency noise
I_gray = imfilter(I_gray, fspecial('gaussian', [3,3], 0.5));

% calculate second order derivatives (laplacian of gaussians)
f = fspecial('log',[5 5], 0.3);
I_filtered = imfilter(I_gray, f);

%creates black and white likeness
for i=1:112
    for j=1:92
        W(i,j)=255-I_filtered(i,j);
    end
end

E1=W(ebox(2):nbox(2), ebox(1):(ebox(3)+ebox(1)));     %eyes

M1=W(nbox(2):(nbox(2)+nbox(4)), nbox(1):(nbox(3)+nbox(1)));     %nose
l=size(M1,1);
w=size(M1,2);
for i=1:l
    for j=1:w
        if (i>=l-10 && M1(i,j)<30)
            if (j<=7 || j>=w-5)
                M1(i,j)=255;
            end
        end
    end
end
%                            Queen Club
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

C=imread('outs/QclubFace1.jpg');
C2=imread('outs/Qclubface2.jpg');
C1=imread('bw/Qclub.jpg');
%                %W is whole face
%                %E1 is eyes snapshot
%                %M1 is nose/mouth snapshot
  
%eyes
mult1=size(C,2)/size(E1,2);
E=imresize(E1,mult1);
for i=1:size(E,1)               %C
    for j=1:size(E,2)
        if (C(i,j)>200)
            C(i,j)=E(i,j);
        end
    end
end
for i=1:size(E,1)               %C2
    for j=1:size(E,2)
        if (C2(i,j)>200)
            C2(i,j)=E(i,j);
        end
    end
end

%nose and mouth
mult2=(size(C,1)-size(E,1)) / size(M1,1);
M=imresize(M1,mult2);
cLow=round(220.5-0.5*size(M,2));
cHigh=round(220.5+0.5*size(M,2)-1);

for i=size(E,1):size(C,1)-1         %C
    for j=cLow:cHigh
        if (C(i,j)>200)
            C(i,j)=M(i-size(E,1)+1,j-cLow+1);
        end
    end
end
for i=size(E,1):size(C2,1)-1        %C2
    for j=cLow:cHigh
        if (C2(i,j)>200)
            C2(i,j)=M(i-size(E,1)+1,j-cLow+1);
        end
    end
end

%thicken
for i=2:410
    for j=3:439
        if (C(i,j)>150)
            C(i,j)=255;
        elseif (C(i,j)<10)
            C(i,j-1)=30;
            C(i,j)=30;
            C(i,j+1)=30;
            C(i+1,j)=30;
            C(i-1,j)=30;
        end
        if (C2(i,j)>150)
            C2(i,j)=255;
        elseif (C2(i,j)<10)
            C2(i,j-1)=30;
            C2(i,j)=30;
            C2(i,j+1)=30;
            C2(i+1,j)=30;
            C2(i-1,j)=30;
        end
    end
end

%final pasting

%flip image across vertical axis
%P=flip(P,2);
C1(620:1030,1320:1760)=C;
C1=flip(C1,1);
C1=flip(C1,2);
C1(790:1200,1450:1890)=C2;
C1=flip(C1,1);
C1=flip(C1,2);

%                           Queen Heart
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

H=imread('outs/Qheartface1.jpg');
H1=imread('bw/Qheart.jpg');
H2=imread('outs/Qheartface2.jpg');

%               W is whole face
%               E is eyes snapshot
%               M is nose/mouth snapshot

%eyes
for i=1:size(E,1)
    for j=1:size(E,2)
        if (H(i,j)>200)
            H(i,j)=E(i,j);
        end
    end
end
for i=1:size(E,1)
    for j=1:size(E,2)
        if (H2(i,j)>200)
            H2(i,j)=E(i,j);
        end
    end
end

% nose and mouth
H((size(E,1):size(H,1)-1),cLow:cHigh)=M;
H2((size(E,1):size(H,1)-1),cLow:cHigh)=M;

%thicken
for i=2:410
    for j=3:389
        if (H(i,j)>150)
            H(i,j)=255;
        elseif (H(i,j)<10)
            H(i,j-1)=30;
            H(i,j)=30;
            H(i,j+1)=30;
            H(i+1,j)=30;
            H(i-1,j)=30;
        end
        if (H2(i,j)>150)
            H2(i,j)=255;
        elseif (H2(i,j)<10)
            H2(i,j-1)=30;
            H2(i,j)=30;
            H2(i,j+1)=30;
            H2(i+1,j)=30;
            H2(i-1,j)=30;
        end
    end
end
%final pasting

H1(590:1000,1270:1710)=H;
H1=flip(H1,1);
H1=flip(H1,2);
H1(800:1210,1380:1820)=H2;
H1=flip(H1,1);
H1=flip(H1,2);
%                           Queen Spade
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

S=imread('outs/Qspadeface1.jpg');
S1=imread('bw/Qspade.jpg');
S2=imread('outs/Qspadeface2.jpg');

                %W is whole face
                %E1 is eyes snapshot
                %M1 is nose/mouth snapshot

mult1=size(S,2)/size(E1,2);
E=imresize(E1,mult1);
mult2=(size(S,1)-size(E,1)) / size(M1,1);
M=imresize(M1,mult2);

cLow=round(220.5-0.5*size(M,2));
cHigh=round(220.5+0.5*size(M,2)-1);
                %eyes
for i=1:size(E,1)
    for j=1:size(E,2)
        if (S(i,j)>200)
            S(i,j)=E(i,j);
        end
    end
end
for i=1:size(E,1)
    for j=1:size(E,2)
        if (S2(i,j)>200)
            S2(i,j)=E(i,j);
        end
    end
end

%nose and mouth
S((size(E,1):size(S,1)-1),cLow:cHigh)=M;
S2((size(E,1):size(S,1)-1),cLow:cHigh)=M;

%thicken
for i=2:410
    for j=3:439
        if (S(i,j)>150)
            S(i,j)=255;
        elseif (S(i,j)<10)
            S(i,j-1)=30;
            S(i,j)=30;
            S(i,j+1)=30;
            S(i+1,j)=30;
            S(i-1,j)=30;
        end
        if (S2(i,j)>150)
            S2(i,j)=255;
        elseif (S2(i,j)<10)
            S2(i,j-1)=30;
            S2(i,j)=30;
            S2(i,j+1)=30;
            S2(i+1,j)=30;
            S2(i-1,j)=30;
        end
    end
end
%final pasting

S1(750:1160,1710:2150)=S;
S1=flip(S1,1);
S1=flip(S1,2);
S1(640:1050,1600:2040)=S2;
S1=flip(S1,1);
S1=flip(S1,2);
%                           Queen Diamond
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

D=imread('outs/Qdiamondface1.jpg');
D1=imread('bw/Qdiamond.jpg');
D2=imread('outs/Qdiamondface2.jpg');
%                %W is whole face
%                %E1 is eyes snapshot
%                %M1 is nose/mouth snapshot

%eyes
for i=1:size(E,1)
    for j=1:size(E,2)
        if (D(i,j)>200)
            D(i,j)=E(i,j);
        end
    end
end
for i=1:size(E,1)
    for j=1:size(E,2)
        if (D2(i,j)>200)
            D2(i,j)=E(i,j);
        end
    end
end

%nose and mouth
D((size(E,1):size(D,1)-1),cLow:cHigh)=M;
D2((size(E,1):size(D,1)-1),cLow:cHigh)=M;

%thicken
for i=2:410
    for j=3:439
        if (D(i,j)>150)
            D(i,j)=255;
        elseif (D(i,j)<10)
            D(i,j-1)=30;
            D(i,j)=30;
            D(i,j+1)=30;
            D(i+1,j)=30;
            D(i-1,j)=30;
        end
        if (D2(i,j)>150)
            D2(i,j)=255;
        elseif (D2(i,j)<10)
            D2(i,j-1)=30;
            D2(i,j)=30;
            D2(i,j+1)=30;
            D2(i+1,j)=30;
            D2(i-1,j)=30;
        end
    end
end
%final pasting

D1(820:1230,1460:1900)=D;
D1=flip(D1,1);
D1=flip(D1,2);
D1(650:1060,1400:1840)=D2;
D1=flip(D1,1);
D1=flip(D1,2);


%                       COLOR TIME
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

QH=imread('orig/Qheart2.jpg');
% QH=imrotate(QH,90);
QC=imread('orig/Qclub1.jpg');
% QC=imrotate(QC,90);
QS=imread('orig/Qspade2.jpg');
% QS=imrotate(QS,90);
QD=imread('orig/Qdiamond2.jpg');
% QD=imrotate(QD,90);

ok=H1;
go=C1;
gg=S1;
so=D1;

%                   Queen Heart
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

ok=repmat(ok, [1 1 3]);

for i = 1:4032
    for j = 1:3024
        if (i>=590)&&(i<=1000)          %skip top face pixels
            if (j>=1270)&&(j<=1710)
                continue;
            end
        end
        if (i>=2832)&&(i<=3242)         %skip bottom face pixels
            if (j>=1200)&&(j<=1640)
                continue;
            end
        end
        
        ok(i,j,1)=QH(i,j,1);             %copy color from card
        ok(i,j,2)=QH(i,j,2);
        ok(i,j,3)=QH(i,j,3);
        
        if (ok(i,j,1)>100 && ok(i,j,2)>100)     %also whiten
            if (ok(i,j,3)>100)
                ok(i,j,1)=255;
                ok(i,j,2)=255;
                ok(i,j,3)=255;
            end
        end
    end
end
%imshow(ok);

% now color face
for i=590:1000
    for j=1270:1710
        if (ok(i,j,1)~=255)
            if (ok(i,j,1) < 100)
                y=rand;
                x1=20+y*20;
                x2=30+y*20;
                x3=40+y*20;
                ok(i,j,1)=x1;
                ok(i,j,2)=x2;
                ok(i,j,3)=x3;
            end
        end
        
    end
end

for i=2832:3242
    for j=1200:1640
        if (ok(i,j,1)~=255)
            if (ok(i,j,1) < 100)
                y=rand;
                x1=20+y*20;
                x2=30+y*20;
                x3=40+y*20;
                ok(i,j,1)=x1;
                ok(i,j,2)=x2;
                ok(i,j,3)=x3;
            end
            
        end
        
    end
end
% imshow(ok);
%                       Queen Club
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

go=repmat(go, [1 1 3]);

for i = 1:4032
    for j = 1:3024
        if (i>=620)&&(i<=1030)          %skip top face pixels
            if (j>=1330)&&(j<=1770)
                continue;
            end
        end
        if (i>=2832)&&(i<=3232)         %skip bottom face pixels
            if (j>=1135)&&(j<=1575)
                continue;
            end
        end
        
        go(i,j,1)=QC(i,j,1);             %copy color from card
        go(i,j,2)=QC(i,j,2);
        go(i,j,3)=QC(i,j,3);
        
        if (go(i,j,1)>100 && go(i,j,2)>100)     %also whiten
            if (go(i,j,3)>100)
                go(i,j,1)=255;
                go(i,j,2)=255;
                go(i,j,3)=255;
            end
        end
    end
end
%imshow(ok);

% now color face
for i=620:1030
    for j=1330:1770
        if (go(i,j,1)~=255)
            if (go(i,j,1) < 100)
                if (i>790 && j<1420)
                    continue;
                else
                    y=rand;
                    x1=20+y*20;
                    x2=40+y*20;
                    x3=60+y*20;
                    go(i,j,1)=x1;
                    go(i,j,2)=x2;
                    go(i,j,3)=x3;
                end
                
            end
        end
        
    end
end

for i=2832:3232
    for j=1135:1575
        if (go(i,j,1)~=255)
            if (go(i,j,1) < 100)
                if (i<3082 && j>1485)
                    continue;
                else
                    y=rand;
                    x1=20+y*20;
                    x2=40+y*20;
                    x3=60+y*20;
                    go(i,j,1)=x1;
                    go(i,j,2)=x2;
                    go(i,j,3)=x3;
                end
                
            end
            
        end
        
    end
end
% imshow(go);
%                           Queen Spade
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

gg=repmat(gg, [1 1 3]);

for i = 1:4032
    for j = 1:3024
        if (i>=750)&&(i<=1160)          %skip top face pixels
            if (j>=1710)&&(j<=2150)
                continue;
            end
        end
        if (i>=2982)&&(i<=3392)         %skip bottom face pixels
            if (j>=980)&&(j<=1420)
                continue;
            end
        end
        
        gg(i,j,1)=QS(i,j,1);             %copy color from card
        gg(i,j,2)=QS(i,j,2);
        gg(i,j,3)=QS(i,j,3);
        
        if (gg(i,j,1)>100 && gg(i,j,2)>100)     %also whiten
            if (gg(i,j,3)>100)
                gg(i,j,1)=255;
                gg(i,j,2)=255;
                gg(i,j,3)=255;
            end
        end
    end
end
%imshow(ok);

% now color face
for i=750:1160
    for j=1710:2150
        if (gg(i,j,1)~=255)
            if (gg(i,j,1) < 100)
                if (i>790 && j>1750)
                    y=rand;
                    x1=20+y*20;
                    x2=40+y*20;
                    x3=60+y*20;
                    gg(i,j,1)=x1;
                    gg(i,j,2)=x2;
                    gg(i,j,3)=x3;
                end
            end
        end
        
    end
end

for i=2982:3392
    for j=980:1420
        if (gg(i,j,1)~=255)
            if (gg(i,j,1) < 100)
                if (i<3332 && j<1387)
                    y=rand;
                    x1=20+y*20;
                    x2=40+y*20;
                    x3=60+y*20;
                    gg(i,j,1)=x1;
                    gg(i,j,2)=x2;
                    gg(i,j,3)=x3;
                end
            end
        end
    end
end
% imshow(gg);

%                   Queen Diamond
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

so=repmat(so, [1 1 3]);

for i = 1:4032
    for j = 1:3024
        if (i>=820)&&(i<=1230)          %skip top face pixels
            if (j>=1460)&&(j<=1900)
                continue;
            end
        end
        if (i>=2962)&&(i<=3372)         %skip bottom face pixels
            if (j>=1170)&&(j<=1610)
                continue;
            end
        end
        
        so(i,j,1)=QD(i,j,1);             %copy color from card
        so(i,j,2)=QD(i,j,2);
        so(i,j,3)=QD(i,j,3);
        
        if (so(i,j,1)>100 && so(i,j,2)>100)     %also whiten
            if (so(i,j,3)>100)
                so(i,j,1)=255;
                so(i,j,2)=255;
                so(i,j,3)=255;
            end
        end
    end
end
%imshow(ok);

% now color face
for i=820:1230
    for j=1460:1900
        if (so(i,j,1)~=255)
            if (so(i,j,1) < 100)
                y=rand;
                x1=20+y*20;
                x2=40+y*20;
                x3=60+y*20;
                so(i,j,1)=x1;
                so(i,j,2)=x2;
                so(i,j,3)=x3;
            end
        elseif (i>=1070 && j<=1290)
            if (so(i,j,1)>100)         %turn it yellow
                y=rand;
                x1=190+y*30;
                x2=150+y*30;
                x3=30+y*20;
                so(i,j,1)=x1;
                so(i,j,2)=x2;
                so(i,j,3)=x3;
            end
        end        
    end
end

for i=2962:3372
    for j=1170:1610
        if (so(i,j,1)~=255)
            if (so(i,j,1) < 100)
                y=rand;
                x1=20+y*20;
                x2=40+y*20;
                x3=60+y*20;
                so(i,j,1)=x1;
                so(i,j,2)=x2;
                so(i,j,3)=x3;
            end
        
        elseif (i<=2973 && j>=1720)
            if (so(i,j,1)>100)         %turn it yellow
                y=rand;
                x1=190+y*30;
                x2=150+y*30;
                x3=30+y*20;
                so(i,j,1)=x1;
                so(i,j,2)=x2;
                so(i,j,3)=x3;
            end
        end       
        
        
    end
end

%                       TRIM & WRITE TO FILE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Queen Heart
ok=ok(300:3650,420:2550,:);
imwrite(ok,['ok/' name 'Qheart.jpg']);

% Queen Club
go=imrotate(go,0.75);
go=go(300:3660,360:2620,:);
imwrite(go,['ok/' name 'Qclub.jpg']);

% Queen Spade
gg=gg(340:3700,480:2640,:);
imwrite(gg,['ok/' name 'Qspade.jpg']);

% Queen Diamond
so=so(350:3750,450:2620,:);
imwrite(so,['ok/' name 'Qdiamond.jpg']);


end

