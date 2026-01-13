for iii =1:373
   iii
I = imread(['E:\MPhil Project\Mphil\vasantha3\Training\',num2str(iii),'.jpg']);



%---split&merge---%

if size(I,3) == 3
    Th = graythresh(rgb2gray(I));
else
    Th = graythresh((I));
end

BG = im2bw(I,Th);

I = imresize(I,[256 256]);
R = I(:,:,1);
G = I(:,:,2);
B = I(:,:,3);
BG = imresize(BG,[256 256]);

for ii = 1:size(I,1)
    for jj = 1:size(I,2)
        if BG(ii,jj) == 1
            OUT(ii,jj,1) = 0;
            OUT(ii,jj,2) = 0;
            OUT(ii,jj,3) = 0;
        elseif BG(ii,jj) == 0
            OUT(ii,jj,1) = R(ii,jj);
            OUT(ii,jj,2) = G(ii,jj);
            OUT(ii,jj,3) = B(ii,jj);
        end    

    end
end


% figure('name','BS image');
% 
% imshow(uint8(OUT));  % Display input image
% 
% title('BS Image','FontName','Times New Roman');


% -- Image Resize -- %

row = 256;

col = 256;

Resize = imresize(I,[row col]);

% figure('name','Resized image');

% imshow(Resize);  % Display resized image

% title('Resized Image','FontName','Times New Roman');

% -- Noise Filtering -- %

fmat = 3;    % Filter size

flevel = 0.5;      % Smoothening level

IM = fspecial('gaussian',fmat,flevel);

Filt = imfilter(Resize,IM);

% channel seperation
red = 1; 
green = 2;
blue = 3;

R = Filt(:,:,red);

G = Filt(:,:,green);

B = Filt(:,:,blue);


% -- Feature Extraction -- % 


%---colour feature---%

color = colorAutoCorrelogram(Filt);
% figure('Name','Colour features');
color = color(1:64);
% cf2 = uitable('data',color);


% -- GLCM Texture Feature -- %

GLCM2 = graycomatrix(R,'Offset',[2 0;0 2]);

stats = glcm(GLCM2,0);

v1=stats.autoc(1);
v2=stats.contr(1);
v3=stats.corrm(1);
v4=stats.corrp(1);
v5=stats.cprom(1);
v6=stats.cshad(1);
v7=stats.dissi(1);
v8=stats.energ(1);
v9=stats.entro(1);
v10=stats.homom(1);
v11=stats.homop(1);
v12=stats.maxpr(1);

Glcmfea = [v1 v2 v3 v4 v5 v6 v7];

%--Shape feature---%


Rval1 = regionprops(im2bw(Filt),'EquivDiameter'); 
Rval2 = regionprops(im2bw(Filt),'MinorAxisLength'); 
Rval3 = regionprops(im2bw(Filt),'Area');

Rval4 = regionprops(im2bw(Filt),'MajorAxisLength');
Rval5 = regionprops(im2bw(Filt),'Perimeter');
Rval6 = regionprops(im2bw(Filt),'FilledArea');
Rval7 = regionprops(im2bw(Filt),'FilledImage');
Rval8 = regionprops(im2bw(Filt),'Extent');


R1 = Rval1(1,1).EquivDiameter;
R2 = Rval2(1,1).MinorAxisLength;
R3 = Rval3(1,1).Area;
R4 = Rval4(1,1).MajorAxisLength;
R5 = Rval5(1,1).Perimeter;
R6 = Rval6(1,1).FilledArea;
R7 = Rval7(1,1).FilledImage;
R7 = mean(mean(R7));
R8= Rval8(1,1).Extent;

RPval = [R1 R2 R3 R4 R5 R6 R7 R8];

close all;

Trainfea(iii,:) = [Glcmfea color RPval]; 

end

save Trainfea Trainfea