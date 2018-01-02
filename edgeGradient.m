function bmap = edgeGradient(im)

sigma=3;
[mag, theta] = gradientMagnitude(im, sigma);
bmap=nonmax(mag,theta);

end