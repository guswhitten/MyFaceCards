function [] = jacks(name,mpc)

%jacks.m
%   Takes in parameter 'name' which checks in file 'ins/name/.jpg' for the
%   matching name of person's photo. Detects eyes and nose of person's face
%   using Computer Vision Toolbox and resizes.
%   
%   Digitizes and transposes these facial features onto the four jacks
%   from a deck of standard Bicycle playing cards. .jpg's automatically 
%   saved to 'outs/name/jpg' for download or printing purposes.
%   
%   Additional variable 'mpc' which allows the user to format their .jpg's
%   specifically for uploading to the Hong Kong based MyPlayingCards.com
%   site for high-quality playing card printing.
%   
%   Set mpc to 1 to frame card to fit MPC site
%   Omit mpc variable or set to 0 to get standard card cutout

 if ~exist('mpc','var')
     % mpc parameter does not exist, so default to 0
      mpc = 0;
 end


I = resize(['ins/' name '.jpg']);

nose_detector = vision.CascadeObjectDetector('Nose');
eye_detector = vision.CascadeObjectDetector('EyePairSmall');  
% eye_detector.MergeThreshold = 0; 
% nose_detector.MergeThreshold = 0;

nbox = step(nose_detector, I); % box around the nose
ebox = step(eye_detector, I); % box around the eyes
nbox = nbox(1,:); % guess the first box is correct

% extend the box to include the mouth
nbox(1) = nbox(1) - 0.3*nbox(3);
nbox(2) = ebox(2) +  ebox(4);
nbox(3) = 1.6*nbox(3);
nbox(4) = 1.8*nbox(4);

% extend the eye box to include the eyebrows
ebox(2) = ebox(2) - 0.5*ebox(4);
ebox(4) = 1.5*ebox(4);

%find center of nose Haar box
nx = nbox(1) + nbox(3)/2;
ny = nbox(2) + nbox(4)/2;

%find center of eye box
ex = ebox(1) + ebox(3)/2;
ey = ebox(2) + ebox(4)/2;

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

%                            Jack Club
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

C=imread('outs/Jclubface1.jpg');
C1=imread('bw/Jclub.jpg');
C2=imread('outs/Jclubface2.jpg');
% C=rgb2gray(C);
                %W is whole face
                %E1 is eyes snapshot
                %M1 is nose/mouth snapshot
%eyes
mult1=size(C,2) / size(E1,2);
E=imresize(E1,mult1);

for i=1:size(E,1)
    for j=1:size(E,2)
        if (C(i,j)>200)
            C(i,j)=E(i,j);
        end
    end
end
for i=1:size(E,1)
    for j=1:size(E,2)
        if (C2(i,j)>200)
            C2(i,j)=E(i,j);
        end
    end
end

%nose and mouth
mult2=(size(C,1)-size(E,1)) / size(M1,1);
M=imresize(M1,mult2);

if (ex>nx)
    x=220.5-mult1*(ex-nx);
elseif (nx>ex)
    x=220.5+mult1*(nx-ex);
else
    x=220.5;
end


cLow=x-0.5*size(M,2);
cHigh=x+0.5*size(M,2)-1;

if (size(M,1)==size(C,1)-size(E,1)+1)
    M=M(1:size(M,1)-1,1:size(M,2));
end


% paste nose and mouth on king's face, P
C((size(E,1):size(C,1)-1),cLow:cHigh)=M;
C2((size(E,1):size(C,1)-1),cLow:cHigh)=M;

%thicken
for i=2:410
    for j=3:439
        if (C(i,j)>175)
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
C1(780:1190,1550:1990)=C;
C1=flip(C1,1);
C1=flip(C1,2);
C1(790:1200,1560:2000)=C2;
C1=flip(C1,1);
C1=flip(C1,2);
%                           Jack Heart
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

H=imread('outs/Jheartface1.jpg');
H1=imread('bw/Jheart.jpg');

                %W is whole face
                %E1 is eyes snapshot
                %M1 is nose/mouth snapshot
%eyes
for i=1:size(E,1)
    for j=1:size(E,2)
        if (H(i,j)>200)
            H(i,j)=E(i,j);
        end
    end
end

% nose and mouth
H((size(E,1):size(H,1)-1),cLow:cHigh)=M;

%thicken
for i=2:410
    for j=3:439
        if (H(i,j)>175)
            H(i,j)=255;
        elseif (H(i,j)<10)
            H(i,j-1)=30;
            H(i,j)=30;
            H(i,j+1)=30;
            H(i+1,j)=30;
            H(i-1,j)=30;
        end
    end
end

%final pasting
H1(690:1100,1210:1650)=H;
H1=flip(H1,1);
H1=flip(H1,2);
H1(752:1162,1320:1760)=H;
H1=flip(H1,1);
H1=flip(H1,2);
%                           Jack Spade
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

S=imread('outs/Jspadeface1.jpg');
S1=imread('bw/Jspade.jpg');
S2=imread('outs/Jspadeface2.jpg');
                %W is whole face
                %E1 is eyes snapshot
                %M1 is nose/mouth snapshot
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
S((size(E,1):size(H,1)-1),cLow:cHigh)=M;
S2((size(E,1):size(S,1)-1),cLow:cHigh)=M;

%thicken
for i=2:410
    for j=3:439
        if (S(i,j)>175)
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
S1(770:1180,1450:1890)=S;
S1=flip(S1,1);
S1=flip(S1,2);
S1(745:1155,1470:1910)=S;
S1=flip(S1,1);
S1=flip(S1,2);

%                           Jack Diamond
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

D=imread('outs/Jdiamondface1.jpg');
D1=imread('bw/Jdiamond.jpg');
                %W is whole face
                %E1 is eyes snapshot
                %M1 is nose/mouth snapshot
%eyes
for i=1:size(E,1)
    for j=1:size(E,2)
        if (D(i,j)>200)
            D(i,j)=E(i,j);
        end
    end
end

%nose and mouth
D((size(E,1):size(D,1)-1),cLow:cHigh)=M;

%thicken
for i=2:410
    for j=3:439
        if (D(i,j)>175)
            D(i,j)=255;
        elseif (D(i,j)<10)
            D(i,j-1)=30;
            D(i,j)=30;
            D(i,j+1)=30;
            D(i+1,j)=30;
            D(i-1,j)=30;
        end
    end
end
%final pasting

D1(800:1210,1270:1710)=D;
D1=flip(D1,1);
D1=flip(D1,2);
D1(788:1198,1285:1725)=D;
D1=flip(D1,1);
D1=flip(D1,2);

% imwrite(D1,'ok/austonKdiamond.jpg');

%                       COLOR TIME
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

JH=imread('orig/Jheart2.jpg');
% KH=imrotate(KH,90);
JC=imread('orig/Jclub2.jpg');
% KC=imrotate(KC,90);
JS=imread('orig/Jspade2.jpg');
% KS=imrotate(KS,90);
JD=imread('orig/Jdiamond1.jpg');

ok=H1;
go=C1;
gg=S1;
so=D1;

%                   Jack Heart
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

ok=repmat(ok, [1 1 3]);

for i = 1:4032
    for j = 1:3024
        if (i>=690)&&(i<=1100)          %skip top face pixels
            if (j>=1210)&&(j<=1650)
                continue;
            end
        end
        if (i>=2872)&&(i<=3282)         %skip bottom face pixels
            if (j>=1268)&&(j<=1708)
                continue;
            end
        end
        
        ok(i,j,1)=JH(i,j,1);             %copy color from card
        ok(i,j,2)=JH(i,j,2);
        ok(i,j,3)=JH(i,j,3);
        
        if (ok(i,j,1)>100 && ok(i,j,2)>100)     %also whiten
            if (ok(i,j,3)>100)
                ok(i,j,1)=255;
                ok(i,j,2)=255;
                ok(i,j,3)=255;
            end
        end
    end
end

% now color face
for i=690:1100
    for j=1210:1650
        if (i>1045 && j>1595)
            if (ok(i,j,1)>200)
                y=rand;
                x1=190+y*30;
                x2=150+y*30;
                x3=30+y*20;
                ok(i,j,1)=x1;
                ok(i,j,2)=x2;
                ok(i,j,3)=x3;
            end
        end
        if (i>1015 && j>1620)
            if (ok(i,j,1)>200)
                y=rand;
                x1=190+y*30;
                x2=150+y*30;
                x3=30+y*20;
                ok(i,j,1)=x1;
                ok(i,j,2)=x2;
                ok(i,j,3)=x3;
            end
        end
        if (i>1000 && j<1240)
            if (ok(i,j,1)>200)
                y=rand;
                x1=190+y*30;
                x2=150+y*30;
                x3=30+y*20;
                ok(i,j,1)=x1;
                ok(i,j,2)=x2;
                ok(i,j,3)=x3;
            end
        end
        if (i>1030 && j<1260)
            if (ok(i,j,1)>200)
                y=rand;
                x1=190+y*30;
                x2=150+y*30;
                x3=30+y*20;
                ok(i,j,1)=x1;
                ok(i,j,2)=x2;
                ok(i,j,3)=x3;
            end
        end
        if (i>1070 && j<1298)
            if (ok(i,j,1)>200)
                y=rand;
                x1=190+y*30;
                x2=150+y*30;
                x3=30+y*20;
                ok(i,j,1)=x1;
                ok(i,j,2)=x2;
                ok(i,j,3)=x3;
            end
        end
        
        
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

for i=2872:3282
    for j=1268:1708
        if (i<2922 && j<1318)
            if (ok(i,j,1)>200)
                y=rand;
                x1=190+y*30;
                x2=150+y*30;
                x3=30+y*20;
                ok(i,j,1)=x1;
                ok(i,j,2)=x2;
                ok(i,j,3)=x3;
            end
        end
        if (i<2962 && j<1294)
            if (ok(i,j,1)>200)
                y=rand;
                x1=190+y*30;
                x2=150+y*30;
                x3=30+y*20;
                ok(i,j,1)=x1;
                ok(i,j,2)=x2;
                ok(i,j,3)=x3;
            end
        end
        if (i<2972 && j>1678)
            if (ok(i,j,1)>200)
                y=rand;
                x1=190+y*30;
                x2=150+y*30;
                x3=30+y*20;
                ok(i,j,1)=x1;
                ok(i,j,2)=x2;
                ok(i,j,3)=x3;
            end
        end
        if (i<3022 && j>1690)
            if (ok(i,j,1)>200)
                y=rand;
                x1=190+y*30;
                x2=150+y*30;
                x3=30+y*20;
                ok(i,j,1)=x1;
                ok(i,j,2)=x2;
                ok(i,j,3)=x3;
            end
        end
        if (i<2942 && j>1658)
            if (ok(i,j,1)>200)
                y=rand;
                x1=190+y*30;
                x2=150+y*30;
                x3=30+y*20;
                ok(i,j,1)=x1;
                ok(i,j,2)=x2;
                ok(i,j,3)=x3;
            end
        end
        if (i<2902 && j>1620)
            if (ok(i,j,1)>200)
                y=rand;
                x1=190+y*30;
                x2=150+y*30;
                x3=30+y*20;
                ok(i,j,1)=x1;
                ok(i,j,2)=x2;
                ok(i,j,3)=x3;
            end
        end
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

%                           Jack Spade
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

gg=repmat(gg, [1 1 3]);

for i = 1:4032
    for j = 1:3024
        if (i>=770)&&(i<=1180)          %skip top face pixels
            if (j>=1450)&&(j<=1890)
                continue;
            end
        end
        if (i>=2885)&&(i<=3295)         %skip bottom face pixels
            if (j>=1112)&&(j<=1552)
                continue;
            end
        end
        
        gg(i,j,1)=JS(i,j,1);             %copy color from card
        gg(i,j,2)=JS(i,j,2);
        gg(i,j,3)=JS(i,j,3);
        
        if (gg(i,j,1)>100 && gg(i,j,2)>100)     %also whiten
            if (gg(i,j,3)>100)
                gg(i,j,1)=255;
                gg(i,j,2)=255;
                gg(i,j,3)=255;
            end
        end
    end
end

% now color face
for i=770:1180
    for j=1450:1890
        if (i<805 && j<1485)
            if (gg(i,j,1) > 200) % turn it yellow
                y=rand;
                x1=190+y*30;
                x2=150+y*30;
                x3=30+y*20;
                gg(i,j,1)=x1;
                gg(i,j,2)=x2;
                gg(i,j,3)=x3;
            end
        end
        if (i<845 && j<1465)
            if (gg(i,j,1) > 200) % turn it yellow
                y=rand;
                x1=190+y*30;
                x2=150+y*30;
                x3=30+y*20;
                gg(i,j,1)=x1;
                gg(i,j,2)=x2;
                gg(i,j,3)=x3;
            end
        end
        if (i>1112 && j<1464)
            if (i<1163 && gg(i,j,1)>200) % turn it yellow
                y=rand;
                x1=190+y*30;
                x2=150+y*30;
                x3=30+y*20;
                gg(i,j,1)=x1;
                gg(i,j,2)=x2;
                gg(i,j,3)=x3;
            end
        end
        if (i>889 && j>1877)
            if (i<1150 && gg(i,j,1)>200) % turn it yellow
                y=rand;
                x1=190+y*30;
                x2=150+y*30;
                x3=30+y*20;
                gg(i,j,1)=x1;
                gg(i,j,2)=x2;
                gg(i,j,3)=x3;
            end
        end
        if (gg(i,j,1)~=255)
            if (gg(i,j,1) < 100) 
                y=rand;
                x1=20+y*20;
                x2=30+y*20;
                x3=40+y*20;
                gg(i,j,1)=x1;
                gg(i,j,2)=x2;
                gg(i,j,3)=x3;
            end
        end
        
    end
end

for i=2885:3295
    for j=1112:1552
        if (i>3260 && j>1512)
            if (gg(i,j,1) > 200) % turn it yellow
                y=rand;
                x1=190+y*30;
                x2=150+y*30;
                x3=30+y*20;
                gg(i,j,1)=x1;
                gg(i,j,2)=x2;
                gg(i,j,3)=x3;
            end
        end
        if (i>3200 && j>1535)
            if (gg(i,j,1) > 200) % turn it yellow
                y=rand;
                x1=190+y*30;
                x2=150+y*30;
                x3=30+y*20;
                gg(i,j,1)=x1;
                gg(i,j,2)=x2;
                gg(i,j,3)=x3;
            end
        end
        if (i<2953 && j>1538)
            if (i>2889 && gg(i,j,1)>200) % turn it yellow
                y=rand;
                x1=190+y*30;
                x2=150+y*30;
                x3=30+y*20;
                gg(i,j,1)=x1;
                gg(i,j,2)=x2;
                gg(i,j,3)=x3;
            end
        end
        
        if (i<3176 && j<1126)
            if (i>2915 && gg(i,j,1)>200) % turn it yellow
                y=rand;
                x1=190+y*30;
                x2=150+y*30;
                x3=30+y*20;
                gg(i,j,1)=x1;
                gg(i,j,2)=x2;
                gg(i,j,3)=x3;
            end
        end
        if (gg(i,j,1)~=255)
            if (gg(i,j,1) < 100)
                y=rand;
                x1=20+y*20;
                x2=30+y*20;
                x3=40+y*20;
                gg(i,j,1)=x1;
                gg(i,j,2)=x2;
                gg(i,j,3)=x3;
            end
            
        end
        
    end
end

%                       Jack Club
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

go=repmat(go, [1 1 3]);

for i = 1:4032
    for j = 1:3024
        if (i>=790)&&(i<=1200)          %skip top face pixels
            if (j>=1560)&&(j<=2000)
                continue;
            end
        end
        if (i>=2867)&&(i<=3277)         %skip bottom face pixels
            if (j>=1035)&&(j<=1475)
                continue;
            end
        end
        
        go(i,j,1)=JC(i,j,1);             %copy color from card
        go(i,j,2)=JC(i,j,2);
        go(i,j,3)=JC(i,j,3);
        
        if (go(i,j,1)>100 && go(i,j,2)>100)     %also whiten
            if (go(i,j,3)>100)
                go(i,j,1)=255;
                go(i,j,2)=255;
                go(i,j,3)=255;
            end
        end
    end
end

% now color face
for i=790:1200
    for j=1560:2000
        if (go(i,j,1)~=255)
            if (go(i,j,1) < 100)
                y=rand;
                x1=30+y*20;
                x2=40+y*20;
                x3=50+y*20;
                go(i,j,1)=x1;
                go(i,j,2)=x2;
                go(i,j,3)=x3;
            end
        end
        if (i<1020 && i>=890)     %turn it yellow
            if (go(i,j,1)>200 && j>=1980)
                y=rand;
                x1=190+y*30;
                x2=150+y*30;
                x3=30+y*20;
                go(i,j,1)=x1;
                go(i,j,2)=x2;
                go(i,j,3)=x3;
            end
        end
        if (i>=1072 && j>=1965)     %turn it yellow
            if (go(i,j,1) > 200)
                y=rand;
                x1=190+y*30;
                x2=150+y*30;
                x3=30+y*20;
                go(i,j,1)=x1;
                go(i,j,2)=x2;
                go(i,j,3)=x3;
            end
        end
        if (i>=1150 && j>=1942)     %turn it yellow
            if (go(i,j,1) > 200)
                y=rand;
                x1=190+y*30;
                x2=150+y*30;
                x3=30+y*20;
                go(i,j,1)=x1;
                go(i,j,2)=x2;
                go(i,j,3)=x3;
            end
        end
        
    end
end

for i=2867:3277
    for j=1035:1475
        if (go(i,j,1)~=255)
            if (go(i,j,1) < 100)
                y=rand;
                x1=30+y*20;
                x2=40+y*20;
                x3=50+y*20;
                go(i,j,1)=x1;
                go(i,j,2)=x2;
                go(i,j,3)=x3;
            end
        end
        if (i<=3005 && j<=1065) % turn it yellow
            if (go(i,j,1) > 200)
                y=rand;
                x1=190+y*30;
                x2=150+y*30;
                x3=30+y*20;
                go(i,j,1)=x1;
                go(i,j,2)=x2;
                go(i,j,3)=x3;
            end
        end
        if (i<=2930 && j<=1085) % turn it yellow
            if (go(i,j,1) > 200)
                y=rand;
                x1=190+y*30;
                x2=150+y*30;
                x3=30+y*20;
                go(i,j,1)=x1;
                go(i,j,2)=x2;
                go(i,j,3)=x3;
            end
        end
         if (i>3000 && i<3150) % turn it yellow
            if (go(i,j,1) > 200 && j<1050)
                y=rand;
                x1=190+y*30;
                x2=150+y*30;
                x3=30+y*20;
                go(i,j,1)=x1;
                go(i,j,2)=x2;
                go(i,j,3)=x3;
            end
         end
         if (i>3220 && j>1460) % turn it yellow
            if (go(i,j,1) > 200)
                y=rand;
                x1=190+y*30;
                x2=150+y*30;
                x3=30+y*20;
                go(i,j,1)=x1;
                go(i,j,2)=x2;
                go(i,j,3)=x3;
            end
            
        end
        
    end
end

%                   Jack Diamond
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

so=repmat(so, [1 1 3]);

for i = 1:4032
    for j = 1:3024
        if (i>=800)&&(i<=1210)          %skip top face pixels
            if (j>=1270)&&(j<=1710)
                continue;
            end
        end
        if (i>=2832)&&(i<=3242)         %skip bottom face pixels
            if (j>=1300)&&(j<=1740)
                continue;
            end
        end
        
        so(i,j,1)=JD(i,j,1);             %copy color from card
        so(i,j,2)=JD(i,j,2);
        so(i,j,3)=JD(i,j,3);
        
        if (so(i,j,1)>100 && so(i,j,2)>100)     %also whiten
            if (so(i,j,3)>100)
                so(i,j,1)=255;
                so(i,j,2)=255;
                so(i,j,3)=255;
            end
        end
    end
end

% now color face
for i=800:1210
    for j=1270:1710
        if (so(i,j,1)~=255)
            if (so(i,j,1) < 100)
                y=rand;
                x1=20+y*20;
                x2=30+y*20;
                x3=40+y*20;
                so(i,j,1)=x1;
                so(i,j,2)=x2;
                so(i,j,3)=x3;
            end
        elseif (i>=1070 && j<=1290)
            if (so(i,j,1)>200)         %turn it yellow
                y=rand;
                x1=190+y*30;
                x2=150+y*30;
                x3=30+y*20;
                so(i,j,1)=x1;
                so(i,j,2)=x2;
                so(i,j,3)=x3;
            end
        elseif (i>=1120 && j<=1300)
            if (so(i,j,1)>200)         %turn it yellow
                y=rand;
                x1=190+y*30;
                x2=150+y*30;
                x3=30+y*20;
                so(i,j,1)=x1;
                so(i,j,2)=x2;
                so(i,j,3)=x3;
            end
        elseif (i>=1170 && j<=1320)
            if (so(i,j,1)>200)         %turn it yellow
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

for i=2832:3242
    for j=1300:1740
        if (so(i,j,1)~=255)
            if (so(i,j,1) < 100)
                y=rand;
                x1=20+y*20;
                x2=30+y*20;
                x3=40+y*20;
                so(i,j,1)=x1;
                so(i,j,2)=x2;
                so(i,j,3)=x3;
            end
        
        elseif (i<=2973 && j>=1720)
            if (so(i,j,1)>200)         %turn it yellow
                y=rand;
                x1=190+y*30;
                x2=150+y*30;
                x3=30+y*20;
                so(i,j,1)=x1;
                so(i,j,2)=x2;
                so(i,j,3)=x3;
            end
        elseif (i<=2923 && j>=1710)
            if (so(i,j,1)>200)         %turn it yellow
                y=rand;
                x1=190+y*30;
                x2=150+y*30;
                x3=30+y*20;
                so(i,j,1)=x1;
                so(i,j,2)=x2;
                so(i,j,3)=x3;
            end
        elseif (i<=2872 && j>=1690)
            if (so(i,j,1)>200)         %turn it yellow
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

% Jack Heart
if (mpc==1)
    ok=ok(250:3750,390:2510,:);
else
    ok=imrotate(ok,-0.3);
    ok=ok(170:3800,200:2770,:);
end
imwrite(ok,['ok/' name 'Jheart.jpg']);

% Jack Club
if (mpc==1)
    go=go(250:3750,420:2570,:);
else
    go=imrotate(go,-0.4);
    go=go(170:3860,200:2830,:);
end
imwrite(go,['ok/' name 'Jclub.jpg']);

% Jack Spade
if (mpc==1)
    gg=imrotate(gg,-0.75);
    gg=gg(250:3750,450:2560,:);
else
    gg=imrotate(gg,-0.8);
    gg=gg(170:3800,200:2830,:);
end
imwrite(gg,['ok/' name 'Jspade.jpg']);

% Jack Diamond
if (mpc==1)
    so=so(250:3750,420:2590,:);
else
    so=imrotate(so,-0.3);
    so=so(170:3800,200:2820,:);
end
imwrite(so,['ok/' name 'Jdiamond.jpg']);

%%%%%%%%%%%% Write just faces to blank card %%%%%%%%%%%%%%%%%%%%%
%club
blank=imread('justFaces/blank.jpg');
C3=blank;
C3(780:1190,1550:1990)=C;
C3=flip(C3,1);
C3=flip(C3,2);
C3(790:1200,1560:2000)=C2;
C3=flip(C3,1);
C3=flip(C3,2);

%diamond
D3=blank;
D3(800:1210,1270:1710)=D;
D3=flip(D3,1);
D3=flip(D3,2);
D3(788:1198,1285:1725)=D;
D3=flip(D3,1);
D3=flip(D3,2);

%spade
S3=blank;
S3(770:1180,1450:1890)=S;
S3=flip(S3,1);
S3=flip(S3,2);
S3(745:1155,1470:1910)=S;
S3=flip(S3,1);
S3=flip(S3,2);

%heart
H3=blank;
H3(690:1100,1210:1650)=H;
H3=flip(H3,1);
H3=flip(H3,2);
H3(752:1162,1320:1760)=H;
H3=flip(H3,1);
H3=flip(H3,2);

%size each to 3.5" x 2.5"
D3=D3(:,72:2953);
S3=S3(:,72:2953);
H3=H3(:,72:2953);
C3=C3(:,72:2953);


%write to file
imwrite(D3,['justFaces/' name 'JD.jpg']);
imwrite(S3,['justFaces/' name 'JS.jpg']);
imwrite(C3,['justFaces/' name 'JC.jpg']);
imwrite(H3,['justFaces/' name 'JH.jpg']);

end

