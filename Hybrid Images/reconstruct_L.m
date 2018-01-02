function reconstructed_image=reconstruct_L(L,N,filter)
G=cell(1,N);   
   for i=1:1:(N-1)
        if i==1
            G{N-i}=L{N-i}+imfilter(imresize(L{N+1-i},2,'nearest'),filter,'replicate');
        else
            G{N-i}=L{N-i}+imfilter(imresize(G{N+1-i},2,'nearest'),filter,'replicate');
        end
    end
    reconstructed_image=G{1};
end

