function varargout = makeSceneVersions(scene_name, listVersions, StereoMode)
         
    scene = getScene(scene_name);    
    scene.shift = scene.offset + scene.dH;
    
    d = getDisplay(StereoMode);
    
    nV = numel(listVersions);
    varargout = cell(1, nV + 1);
    useNonius = 0;
    
    for l = 1:nV
        [left, right] = makeStereoPair(scene, d, listVersions{l}, useNonius);
        varargout{l} = cat(d.catDim, left, right);
        
    end
    %background = 0;
    %% blank
    blankScene = scene;
    blankScene.right = background*ones(size(scene.right));
    blankScene.left = background*ones(size(scene.right));
    useNonius = 1;
    
    [lS, rS] =  makeStereoPair(blankScene, d, 'O', useNonius);
    varargout{nV + 1} =  cat(d.catDim, lS, rS);
end


function [l, r] = makeStereoPair(scene, d, type, useNonius)
  
    [left, right] = getLeftRight(scene, type);
    [shiftSign, crossSign] = getCrossShiftSigns(type);    
    %crossPosR = crossSign.L*scene.offset;
    l = processScene(left, d, shiftSign.L*scene.shift, useNonius);
    if (d.mirrorFlip)
        right = flipdim(right, 2);
    end
    %crossPosR = crossSign.R*scene.offset;
    r = processScene(right, d, shiftSign.R*scene.shift, -useNonius);    
end
function s = processScene(s0, d, shiftVal, useNonius)
    if(useNonius)
        xs = drawNonius(s0, 25, useNonius);
    else
        xs = s0;
    end
    s1 = imresize(xs, [d.v d.h]);
    s = positionScene(s1, [d.v d.h], shiftVal);
end
function [left, right] = getLeftRight(s, type)

    %% pull out different versions of left/right
    switch type
        case 'S'
            left = s.left;
            right = s.right;
        case 'O'
            left = s.left;
            right = s.left;
        otherwise
    end
end

function [shiftSign, crossSign] = getCrossShiftSigns(sceneType)
    switch sceneType
        case 'S' 
            % cross sign
            crossSign.L = 1;
            crossSign.R = -1;
        
            % shift sign
            shiftSign.L = 1;
            shiftSign.R = 1;
        case 'O'          
            % cross sign
            crossSign.L = 1;
            crossSign.R = 1;
            % shift sign
            shiftSign.L = 1;
            shiftSign.R = -1;
        otherwise
            crossSign.L = 1;
            crossSign.R = 1;
        
            % shift sign
            shiftSign.L = 1;
            shiftSign.R = 1;            
    end
end