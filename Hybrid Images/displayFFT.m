
function displayFFT(G, L, N)
figure;
ha = tight_subplot(2,N,[.01 .03],[.1 .01],[.01 .01]);
for ii = 1:2*N
    axes(ha(ii));
    if ii <= N
        imagesc(10*log(1+abs(fftshift(fft2((G{ii}))))));
    else
        imagesc(10*log(1+abs(fftshift(fft2((L{ii-N})))))); 
    end
end
set(ha(1:4),'XTickLabel',''); set(ha,'YTickLabel','');

end