[FileName,PathName]=uigetfile('*.*','please select the image file');
I=imread(FileName);
%%convert to grayscale
%I=rgb2gray(I);

I=im2double(I);
R=I(:,:,1);
G=I(:,:,2);
B=I(:,:,3);
I=.299*R+.587*G+.114*B;

%%smoothing 

sigma=1.76; %standard deviation
sz=2; 
[x,y]=meshgrid(-sz:sz,-sz:sz);
M=size(x,1)-1;
N=size(y,1)-1;
exp_comp=-(x.^2+y.^2)/(2*sigma*sigma);
Kernel=exp(exp_comp)/(2*pi*sigma*sigma);
img=zeros(size(I));
I=padarray(I,[sz sz]);

%convolution

for i=1:size(I,1)-M
    for j=1:size(I,2)-N
        conv=I(i:i+M,j:j+M).*Kernel;
        img(i,j)=sum(conv(:));
    end
end
figure; subplot(1,2,1); imshow(I); title('Original Image');
subplot(1,2,2); imshow(img); title('Gaussian Blur'); 

%%finding gradients
%vertical edges

filter_1=[-1 0 1;-2 0 2;-1 0 1]/8;
for i=2:size(img,1)-1
    for j=2:size(img,2)-1
        conv2=img(i-1:i+1,j-1:j+1).*filter_1;
        I_x(i+1,j+1)=sum(conv2(:));
    end
end

%horizontal edges

filter_2=[1 2 1;0 0 0;-1 -2 -1]/8;
for i=2:size(img,1)-1
    for j=2:size(img,2)-1
        conv3=img(i-1:i+1,j-1:j+1).*filter_2;
        I_y(i+1,j+1)=sum(conv3(:));
    end
end
figure; subplot(1,2,1); imshow(I_y, []);title('Row Gradient');
subplot(1,2,2); imshow(I_x, []); title('Column Gradient');

%calculate magnitude and directions

mag=sqrt((I_x.^2)+(I_y.^2));
dir=atan2(I_y,I_x);
dir=dir*(180/pi);
[m n]=size(img);
for i=1:m-1
    for j=1:n-1
        if (dir(i,j)<0)
            dir(i,j)=360+dir(i,j);
        end
    end
end
dir2=zeros(m,n);
for i = 1  : m-1
    for j = 1 : n-1
        if ((dir(i, j) >= 0 ) && (dir(i, j) < 22.5) || (dir(i, j) >= 157.5) && (dir(i, j) < 202.5) || (dir(i, j) >= 337.5) && (dir(i, j) <= 360))
            dir2(i, j) = 0;
        elseif ((dir(i, j) >= 22.5) && (dir(i, j) < 67.5) || (dir(i, j) >= 202.5) && (dir(i, j) < 247.5))
            dir2(i, j) = 45;
        elseif ((dir(i, j) >= 67.5 && dir(i, j) < 112.5) || (dir(i, j) >= 247.5 && dir(i, j) < 292.5))
            dir2(i, j) = 90;
        elseif ((dir(i, j) >= 112.5 && dir(i, j) < 157.5) || (dir(i, j) >= 292.5 && dir(i, j) < 337.5))
            dir2(i, j) = 135;
        end
    end
end

figure; imshow(mag, []);title('Gradient Magnitude');
figure; imagesc(dir2); colorbar;  title('Gradient Directions');

%%non-maximum supression

NMS = zeros (m,n);
for i=2:m-1
    for j=2:n-1
        if (dir2(i,j)==0)
            NMS(i,j) = (mag(i,j) == max([mag(i,j), mag(i,j+1), mag(i,j-1)]));
        elseif (dir2(i,j)==45)
            NMS(i,j) = (mag(i,j) == max([mag(i,j), mag(i+1,j-1), mag(i-1,j+1)]));
        elseif (dir2(i,j)==90)
            NMS(i,j) = (mag(i,j) == max([mag(i,j), mag(i+1,j), mag(i-1,j)]));
        elseif (dir2(i,j)==135)
            NMS(i,j) = (mag(i,j) == max([mag(i,j), mag(i+1,j+1), mag(i-1,j-1)]));
        end
    end
end
NMS = NMS.*mag;
figure, imshow(logical(NMS));title('Non-Maximum Suppression');

%%double thresholding

T_Low=0.075;
T_High=0.175;
T_Low=T_Low*max(max(NMS));
T_High=T_High*max(max(NMS));
Thr=zeros(m,n);
for i=1:m
    for j=1:n
        if (NMS(i,j)<T_Low)
            Thr(i,j)=0;
        elseif (NMS(i,j)>T_High)
            Thr(i,j)=1;
            elseif ( NMS(i+1,j)>T_High || NMS(i-1,j)>T_High || NMS(i,j+1)>T_High || NMS(i,j-1)>T_High || NMS(i-1, j-1)>T_High || NMS(i-1, j+1)>T_High || NMS(i+1, j+1)>T_High || NMS(i+1, j-1)>T_High)
            Thr(i,j) = 1; %hysteresis 
        end
    end
end

%%final

edges=uint8(Thr.*255);
figure; subplot(1,2,1); imshow(I); title('Original Image');
subplot(1,2,2); imshow(edges); title('Canny Edge Detection');
%imwrite(edges,'canny_edge_detection.jpg');