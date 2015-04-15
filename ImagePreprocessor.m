close all;

% (1) Read and display the image
I = imread('sample4.png');
imshow(I);
title("Original sample image");
figure;

% (2) Convert to CIELab colorspace
LAB = RGB2Lab(I);


% (3) Acquire the mean vector m

%     Page 805 of paper
%     'Now define a three-dimensional column vector m', this is the 'mean vector'

%     Old implementation
%        m = [mean(mean(LAB(:,:,1))) ; mean(mean(LAB(:,:,2))) ; mean(mean(LAB(:,:,3)))];

% New implementation (same result)
%   squeeze 'removes singleton dimensions from X and return the result.'
m = squeeze( mean(mean(LAB)) );


% (4) Acquire the covariance matrix R

%     Page 805 of paper
%     'and a 3x3 matric R', this is the 'covariance matrix of a color vector c in the original orthogonal coordinate system (x, y, z)'

R = [0 0 0; 0 0 0; 0 0 0];

for i = 1:120
  for j = 1:120
    cminusm = LAB(i,j) - m;
    primed = (cminusm * cminusm');
    R = R + primed;
  endfor
endfor
R = R / 14400;

% (5) Acquire the eigenvectors V and the eigenvalues D of the covariance matrix R
[V, D] = eig(R);


% (6) Transform the original color vectors in CIELab into the new color vectors of PCA
PCA = zeros(120, 120, 3);

  for i = 1:120
    for j = 1:120
      cprime = V' * (LAB(i, j) - m);
      
      for k = 1:3
        PCA(i,j,k) = cprime(k);
      endfor
    endfor
  endfor

  
% (7) Plot the image in the CIELab colorspace
plot3(LAB(:,:,1), LAB(:,:,2), LAB(:,:,3), 'r.');
xlabel('L');
ylabel('a');
zlabel('b');
title("Sample image in the CIELab colorspace");

% (8) Plot the 1st, 2nd, and 3rd principal components
scale=50;
line1 = line([m(1) - scale * V(1,1) m(1) + scale * V(1,1)], [m(2) - scale * V(2,1) m(2) + scale * V(2,1)],[m(3) - scale * V(3,1) m(3) + scale * V(3,1)]);
line2 = line([m(1) - scale * V(1,2) m(1) + scale * V(1,2)], [m(2) - scale * V(2,2) m(2) + scale * V(2,2)],[m(3) - scale * V(3,2) m(3) + scale * V(3,2)]);
line3 = line([m(1) - scale * V(1,3) m(1) + scale * V(1,3)], [m(2) - scale * V(2,3) m(2) + scale * V(2,3)],[m(3) - scale * V(3,3) m(3) + scale * V(3,3)]);

set(line1, 'color', [0 0 1], "linestyle", "--")
set(line2, 'color', [0 1 0], "linestyle", "--")
set(line3, 'color', [0 1 1], "linestyle", "--")

axis tight;

% (9) On a different figure, plot transformed image c'
figure;

pc1 = PCA(:,:,1);
pc2 = PCA(:,:,2);
pc3 = PCA(:,:,3);

plot3(pc1, pc2, pc3, 'r.');
title("Color vectors after transformation");

xlabel('PC1');
ylabel('PC2');
zlabel('PC3');

axis tight;