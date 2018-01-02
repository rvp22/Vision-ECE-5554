function bmap = edgeOrientedFilters(im)

[mag, theta] = orientedFilterMagnitude(im);
bmap=nonmax(mag,theta);
bmap=bmap/(max(max(bmap)));
end