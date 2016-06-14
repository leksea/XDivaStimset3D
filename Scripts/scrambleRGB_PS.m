function nScrambled = scrambleRGB_PS(inImage)
    xyc = 0.5*size(inImage);
    xy = size(inImage);
    
    % Synthetic image dimensions(multiples of 32)
    dx = 512;
    dy = 896;
    
    Nsx = 2*dy;  
    Nsy = 2*dx;
    
    %cut the center 
    centerCut = inImage(xyc(1) - dx:xyc(1) + dx - 1, xyc(2) - dy:xyc(2) + dy - 1, :);

    Nsc = 3; % Number of pyramid scales
    Nor = 4; % Number of orientations
    Na = 7; % Number of spatial neighbors considered for spatial correlations
    Niter = 25; % Number of iterations of the synthesis loop

    [params] = textureColorAnalysis(centerCut, Nsc, Nor, Na);
    synth = textureColorSynthesis(params, [Nsy Nsx], Niter);
    nScrambled = imresize(synth, [xy(1) xy(2)]);
end