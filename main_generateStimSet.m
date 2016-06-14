function main_generateStimSet()
     
    mpath = main_setPath;
    %by default, use SRC scenes!
    
    listOfScenes = dir2([mpath.matimages filesep '*.mat']);
    if (isempty(listOfScenes))
        listOfScenes = dir2(mpath.source);
    end
    if (isempty(listOfScenes))
        error('Scenes not found, exiting the script');
    end
    %rndScenes = randperm(numel(listOfScenes));
    ListofVersions = {'S', 'O'};
    DisplaySettings = 'leftright';
    
    StimFreq = 4*0.375;
    previewImagesOnly = 1;    
    
    generateAll(listOfScenes, ListofVersions, DisplaySettings, StimFreq, previewImagesOnly, mpath);  
end

function generateAll(listOfScenes, ListofVersions, DisplaySettings, StimFreq, previewImagesOnly, mpath)
    
    nScenes = numel(listOfScenes);
    %rndScenes = randperm(nScenes);
    %rndScenes = listOfScenes;
    
    i = 1;
    imageSequence = calcImageSeq2AFC(StimFreq);
    roosterName = strcat(mpath.results, filesep, 'ScenesAllCND.txt');
    f = fopen(roosterName, 'w+');
    
    
    while i <= nScenes
                
        %num = rndScenes(i);
        num = i;
        list_name = strtok(listOfScenes(num).name, '.');        
        disp(['Generating ' list_name]);
        
        fprintf(f, 'Conditions SO:OS, Trial %d Scene %s\n', i, list_name);
        
        [sceneS, sceneO, blank1, blank2] = makeSceneVersions(list_name, ListofVersions, DisplaySettings);
                      
        %% SO, OS trials     
        writeXDivaStim(mpath.results, double(blank1), sceneS, double(blank2), sceneO, 'SO', i, imageSequence, previewImagesOnly);
        %writeXDivaStim(mpath.results, double(blank1), sceneO, double(blank2), sceneS, 'OS', i, imageSequence, previewImagesOnly);
        i = i + 1;
    end
    fprintf(f, 'Set generated on %s', datestr(clock));   
    fclose(f);
end