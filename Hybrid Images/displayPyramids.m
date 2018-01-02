function displayPyramids(G, L, N)
figure;
fig = tight_subplot(2,N,[.01 .03],[.1 .01],[.01 .01]);
for ii = 1:2*N
    axes(fig(ii));
    if ii <= N
        imshow((G{ii}));
    else
        if ii ~= 2 * N
            imshow((L{ii-N})+0.5);
        else 
            imshow((L{ii-N}));
        end
    end
end

end