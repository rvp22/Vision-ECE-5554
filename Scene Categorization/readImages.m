function im = readImages(folder, nums)
im = cell(numel(nums),1);
t = 0;
for k = nums,
    t = t+1;
    im{t} = imread(fullfile(folder, [ num2str(k) '.jpg']));
    im{t} = im2double(im{t});
end 