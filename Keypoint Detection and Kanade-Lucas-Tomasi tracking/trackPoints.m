function [track_x, track_y] = trackPoints(pt_x, pt_y, im, ws)
% Tracking initial points (pt_x, pt_y) across the image sequence
% track_x: [Number of keypoints] x [2]
% track_y: [Number of keypoints] x [2]

% Initialization
N = numel(pt_x);
nim = numel(im);
track_x = zeros(N, nim); %Act
track_y = zeros(N, nim); %Act
track_x(:, 1) = pt_x(:); %Act
track_y(:, 1) = pt_y(:); %act
%track_x = pt_x(:);
%track_y = pt_y(:);
for t = 1:nim-1
   %disp("%%%%%%%%%%%%%%%%%%%%%%%%Image:%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%")
    %disp(t);
   % disp("%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%")
    [track_x(:, t+1), track_y(:, t+1)] = ...
            getNextPoints(track_x(:, t), track_y(:, t), im{t}, im{t+1}, ws,N);
end
end