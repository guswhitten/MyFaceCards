function [] = kings(name)

%UNTITLED Summary of this function goes here
%   Detailed explanation goes here


I = resize(['ins/' name '.jpg']);

nose_detector = vision.CascadeObjectDetector('Nose');
eye_detector = vision.CascadeObjectDetector('EyePairSmall');  

nbox = step(nose_detector, I); % box around the nose
ebox = step(eye_detector, I); % box around the eyes
nbox = nbox(1,:); % guess the first box is correct

% extend the box to include the mouth
nbox(1) = nbox(1) - round(0.1*nbox(3));
nbox(2) = ebox(2) +  ebox(4);
nbox(3) = round(1.2*nbox(3));
nbox(4) = round(1.7*nbox(4));

% extend the eye box to include the eyebrows
ebox(2) = ebox(2) - 0.5*ebox(4);
ebox(4) = 1.5*ebox(4);

figure(2)
imshow(I);
hold on
rectangle('Position',ebox(1,:),'LineWidth',3,'LineStyle','-','EdgeColor','g'); %r -red, g-green,b-blue
rectangle('Position',nbox(1,:),'LineWidth',3,'LineStyle','-','EdgeColor','b'); %r -red, g-green,b-blue
hold off;

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

%                            King Club
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

C=imread('outs/Kclubface1.jpg');
C1=imread('bw/Kclub.jpg');
C=rgb2gray(C);
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

%nose and mouth
mult2=(size(C,1)-size(E,1)) / size(M1,1);
M=imresize(M1,mult2);

%nose calculations
value=220.5/ex;
n=value*nx;

cLow=n-0.5*size(M,2);
cHigh=n+0.5*size(M,2)-1;

if (size(M,1)==size(C,1)-size(E,1)+1)
    M=M(1:size(M,1)-1,1:size(M,2));
end

% paste nose and mouth on king's face, P
C((size(E,1):size(C,1)-1),cLow:cHigh)=M;

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
    end
end

%final pasting
C1(760:1170,1310:1750)=C;
C1=flip(C1,1);
C1=flip(C1,2);
C1(840:1250,1310:1750)=C;
C1=flip(C1,1);
C1=flip(C1,2);
%                           King Heart
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

H=imread('outs/Kheartface1.jpg');
H1=imread('bw/Kheart.jpg');
H2=imread('outs/Kheartface2.jpg');
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
        if (H2(i,j)>175)
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
H1(750:1160,1300:1740)=H;
H1=flip(H1,1);
H1=flip(H1,2);
H1(800:1210,1240:1680)=H2;
H1=flip(H1,1);
H1=flip(H1,2);
%                           King Spade
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

S=imread('outs/Kspadeface1.jpg');
S1=imread('bw/Kspade.jpg');

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
%nose and mouth
S((size(E,1):size(H,1)-1),cLow:cHigh)=M;

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
    end
end

%final pasting
S1(870:1280,1530:1970)=S;
S1=flip(S1,1);
S1=flip(S1,2);
S1(810:1220,1520:1960)=S;
S1=flip(S1,1);
S1=flip(S1,2);

%                           King Diamond
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

D=imread('outs/Kdiamondface1.jpg');
D1=imread('bw/Kdiamond.jpg');
D2=imread('outs/Kdiamondface2.jpg');

                %W is whole face
                %E1 is eyes snapshot
                %M1 is nose/mouth snapshot
% mult1=size(D,2)/size(E1,2);
% E=imresize(E1,mult1);
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

% mult2=(size(D,1)-size(E,1)) / size(M1,1);
% M=imresize(M1,mult2);
% cLow=220.5-0.5*size(M,2);
% cHigh=220.5+0.5*size(M,2)-1;

%nose and mouth
D((size(E,1):size(D,1)-1),cLow:cHigh)=M;
D2((size(E,1):size(D,1)-1),cLow:cHigh)=M;

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
        if (D2(i,j)>175)
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

D1(810:1220,1250:1690)=D;
D1=flip(D1,1);
D1=flip(D1,2);
D1(835:1245,1290:1730)=D2;
D1=flip(D1,1);
D1=flip(D1,2);

% imwrite(D1,'ok/austonKdiamond.jpg');

%                       COLOR TIME
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

KH=imread('orig/Kheart2.jpg');
% KH=imrotate(KH,90);
KC=imread('orig/Kclub1.jpg');
% KC=imrotate(KC,90);
KS=imread('orig/Kspade1.jpg');
% KS=imrotate(KS,90);
KD=imread('orig/Kdiamond2.jpg');
% KD=imrotate(KD,90);

ok=H1;
go=C1;
gg=S1;
so=D1;

%                   King Heart
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

ok=repmat(ok, [1 1 3]);

for i = 1:4032
    for j = 1:3024
        if (i>=750)&&(i<=1160)          %skip top face pixels
            if (j>=1300)&&(j<=1740)
                continue;
            end
        end
        if (i>=2832)&&(i<=3242)         %skip bottom face pixels
            if (j>=1339)&&(j<=1779)
                continue;
            end
        end
        
        ok(i,j,1)=KH(i,j,1);             %copy color from card
        ok(i,j,2)=KH(i,j,2);
        ok(i,j,3)=KH(i,j,3);
        
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
for i=750:1160
    for j=1300:1740
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

for i=2822:3232
    for j=1344:1784
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
%                       King Club
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

go=repmat(go, [1 1 3]);

for i = 1:4032
    for j = 1:3024
        if (i>=760)&&(i<=1170)          %skip top face pixels
            if (j>=1310)&&(j<=1750)
                continue;
            end
        end
        if (i>=2782)&&(i<=3192)         %skip bottom face pixels
            if (j>=1284)&&(j<=1724)
                continue;
            end
        end
        
        go(i,j,1)=KC(i,j,1);             %copy color from card
        go(i,j,2)=KC(i,j,2);
        go(i,j,3)=KC(i,j,3);
        
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
for i=760:1170
    for j=1310:1750
        if (go(i,j,1)~=255)
            if (go(i,j,1) < 100)
                y=rand;
                x1=20+y*20;
                x2=30+y*20;
                x3=40+y*20;
                go(i,j,1)=x1;
                go(i,j,2)=x2;
                go(i,j,3)=x3;
            end
        end
        
    end
end

for i=2782:3192
    for j=1310:1750
        if (go(i,j,1)~=255)
            if (go(i,j,1) < 100)
                y=rand;
                x1=20+y*20;
                x2=30+y*20;
                x3=40+y*20;
                go(i,j,1)=x1;
                go(i,j,2)=x2;
                go(i,j,3)=x3;
            end
            
        end
        
    end
end
% imshow(go);
%                           King Spade
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

gg=repmat(gg, [1 1 3]);

for i = 1:4032
    for j = 1:3024
        if (i>=870)&&(i<=1280)          %skip top face pixels
            if (j>=1530)&&(j<=1970)
                continue;
            end
        end
        if (i>=2812)&&(i<=3222)         %skip bottom face pixels
            if (j>=1064)&&(j<=1504)
                continue;
            end
        end
        
        gg(i,j,1)=KS(i,j,1);             %copy color from card
        gg(i,j,2)=KS(i,j,2);
        gg(i,j,3)=KS(i,j,3);
        
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
for i=870:1280
    for j=1530:1970
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

for i=2812:3222
    for j=1064:1504
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
% imshow(gg);

%                   King Diamond
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

so=repmat(so, [1 1 3]);

for i = 1:4032
    for j = 1:3024
        if (i>=810)&&(i<=1220)          %skip top face pixels
            if (j>=1250)&&(j<=1690)
                continue;
            end
        end
        if (i>=2792)&&(i<=3202)         %skip bottom face pixels
            if (j>=1293)&&(j<=1733)
                continue;
            end
        end
        
        so(i,j,1)=KD(i,j,1);             %copy color from card
        so(i,j,2)=KD(i,j,2);
        so(i,j,3)=KD(i,j,3);
        
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
for i=810:1220
    for j=1250:1690
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
        end
        
    end
end

for i=2792:3202
    for j=1293:1733
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
            
        end
        
    end
end

%                       TRIM & WRITE TO FILE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% King Heart
% ok=ok(250:3750,440:2600,:);
imwrite(ok,['ok/' name 'Kheart.jpg']);

% King Club
go=imrotate(go,0.5);
go=go(250:3750,470:2570,:);
imwrite(go,['ok/' name 'Kclub.jpg']);

% King Spade
gg=gg(250:3750,440:2550,:);     % trim boundaries
imwrite(gg,['ok/' name 'Kspade.jpg']);

% King Diamond
so=imrotate(so,0.5);
so=so(250:3750,440:2550,:);
imwrite(so,['ok/' name 'Kdiamond.jpg']);

end

