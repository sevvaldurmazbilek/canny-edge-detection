# canny-edge-detection

The edge of an image is usually described as a part in which the gray value of the image changes rapidly. Edge detection is one of the most widely used image processing applications to identify objects because it would be more difficult and slow for a system to examine all object details to recognize objects. There is a lot of traditional edge detection algorithms such as the Canny algorithm, the Sobel algorithm, the Laplacian algorithm. Canny edge detection is an image processing method used to detect edges in an image while suppressing noise. The suppression of noise in the image is important for an edge detection process because the noise in the image can be detected as an edge by the algorithm. A Canny edge detection algorithm consists of 6 main steps.

1. Grayscale Conversion
2. Smoothing
3. Finding Gradients
4. Non-maximum suppresiom
5. Double Thresholding
6. Edge Tracking by hystresis

A. Grayscale Conversion
Among the various image classes which are supported by MATLAB, double class is the most suitable image class for more complex mathematical operations so we need to convert the image to double from uint8 after reading the image into the program. This is the process of dividing the pixel values in the image by 255. It can do automatically with the “im2double” function. Grayscale is simply reducing complexity compare to RGB images. Many tasks do not work better with a 3 dimensional matrix (eg. edge detection). That’s why we need to convert images to grayscale from RGB for the Canny algorithm. This can be done automatically with the “rgb2gray” funcition, on the otber hand, the image can convert with divided into bands and multiplied by each band weight. This step is not necessary for single band image.

![image](https://github.com/sevvaldurmazbilek/canny-edge-detection/assets/59259659/cd724b7b-3de0-4106-a81d-88dabaa0c7f9)


B. Smoothing
Smoothing is used for blurring and noise reduction. It is a very significant step in Canny edge detection. It prevents recognizing the noise in the image as an edge by reduces noise in the image and by blurring image. We can categorize smoothing filters as linear filters and also as nonlinear filters. Linear filter is simply the average of the pixels contained in the neighborhood of the filter mask [2] . On the other hand, non-linear filters have many applications, especially in the removal of certain types of noise that are not additive. The difference in applying the two is the type of noise in the image. Gaussian filter which is one of the linear filters is used for smoothing operations in Canny edge detection.

σ is the standard deviation. It will vary depending on the desired noise reduction in the image. Smoothing with larger standard deviations suppresses noise, but also blurs the image. It is important to understand that the selection of the size of the Gaussian kernel will affect the performance of the detector. The larger the size is, the lower the detector’s sensitivity to noise. A 5×5 is a good size for most cases, but this will also vary depending on specific situations.

![image](https://github.com/sevvaldurmazbilek/canny-edge-detection/assets/59259659/53222ae1-0627-4d42-8253-75af5f66d8ee)


C. Finding Gradients
An image gradient is a directional change in the intensity or color in an image. Mathematically, the gradient of a two-variable function at each image point is a 2D vector with the components given by the derivatives in the horizontal and vertical directions. The magnitude of the gradient tells us how quickly the image is changing, while the direction of the gradient tells us the direction in which the image is changing most rapidly. The image gradient is one of the most significant operations in image processing applications like the Canny edge detector. It uses the image gradient to detection edges. Some special filters are used, such as sobel operator, to determine the horizontal and vertical edges in the image.

![image](https://github.com/sevvaldurmazbilek/canny-edge-detection/assets/59259659/277a262f-ede1-4e37-b810-c49e54a5c591)

![image](https://github.com/sevvaldurmazbilek/canny-edge-detection/assets/59259659/56b9b393-5c34-49ff-a410-326c9aa7b03c)

![image](https://github.com/sevvaldurmazbilek/canny-edge-detection/assets/59259659/6ac52ee0-7d42-46cf-b24c-3b72095025a7)


D. Non-Maximum Suppression
Non-Maximum Suppression (NMS) is the task of finding all local maxima in an image. Ideally, the final image should have thin edges. Thus, we must perform non-maximum suppression to thin out the edges. The algorithm goes through all the points on the gradient intensity matrix and finds the pixels with the maximum value in edge directions. The purpose of the algorithm is to check if the pixels on the same direction are more or less intense than the ones being processed. In the example in Figure 7, the pixel (i, j) is being processed, and the pixels on the same direction are highlighted in blue (i, j-1) and (i, j+1). If one those two pixels are more intense than the one being processed, then only the more intense one is kept. Pixel (i, j-1) seems to be more intense, because it is white (value of 255). Hence, the intensity value of the current pixel (i, j) is set to 0. If there are no pixels in the edge direction having more intense values, then the value of the current pixel is kept.

![image](https://github.com/sevvaldurmazbilek/canny-edge-detection/assets/59259659/a5eb9484-ee58-4428-ac1f-ea27067c0619)


E. Double Thresholding
Thresholding is a step of determining potential edges in an image. This step requires two threshold value. This step aims at identifying 3 kinds of pixels: strong, weak, non-relevant. Strong pixels are pixels that have an intensity so high that we are sure they contribute to the final edge. Weak pixels that have an intensity value that is not enough to be considered as strong ones, but yet not small enough to be considered as non-relevant for the edge detection. Other pixels are considered as non-relevant fort he edge. In addition, to choose of thresholding value is important. A threshold set too high can miss important information. On the other hand, a threshold set too low will falsely identify irrelevant information (such as noise) as important. It is difficult to give a generic threshold that works well on all images. No tried and tested approach to this problem yet exists. The threshold values used in the following algorithm were determined by examining the histogram of the “Lenna” image.

F. Edge Tracking by Hystresis
Based on the threshold results, the hystresis consists of transforming weak pixels into strong ones.

![image](https://github.com/sevvaldurmazbilek/canny-edge-detection/assets/59259659/7dd38894-29b1-4a83-9859-b58c9cb52a0d)

![image](https://github.com/sevvaldurmazbilek/canny-edge-detection/assets/59259659/15f9a19f-c048-41a8-b4b8-9197b652461e)

![image](https://github.com/sevvaldurmazbilek/canny-edge-detection/assets/59259659/5121985a-c237-40a0-9d7a-c7186bb16ae5)

![image](https://github.com/sevvaldurmazbilek/canny-edge-detection/assets/59259659/4fe1b849-11b4-47c5-af2e-4a6b05d2a867)





REFERENCES
[1] Zhibin , Hu; Caixia , Deng; Yunhong, Shao; Cui, Wang;, «Edge Detection Method based on Lifting B-Spline Dyadic Wavelet,» International Journal of Performability Engineering, pp. 1472-1481, 2019.

[2] R. C. Gonzalez, Digital Image Processing.

[3] N. Snavely, «Computer Vision, Edge Detection and Resampling».

[4] «Wikipedia,» [Online]. Available: en.wikipedia.org.

[5] D. Jacobs, Image Gradients, 2005.

[6] T. Q. Pham, «Non-maximum Suppression Using Fewer than Two Comparisons per Pixel,» %1 içinde Advanced Concepts for Intelligent Vision Systems, Australia, Canon Information Systems Research Australia (CiSRA), pp. 438-451.
[7] S. Sahir, «Towards Data Science,» [Online]. Available: towardsdatascience.com.




