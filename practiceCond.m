
%% ADTask v2 - same goal but using the additional singleton paradigm (ASP) instead of the VST

% why no VST? too complicated for a clinical population, and maybe too
% complicated for healthy people too.

% why ASP? stimuli can be much simpler and follow the same idea. the
% overall goal of the task is to load working memory, adminster a selective
% attention task with dual task and cueing components, and probe WM after
% these tasks have been performed. the interesting results of the study
% will come from the interaction between these seperate aspects of
% attention, not from the individual components of the overall task. so, if
% the ASP provides a selective attention task that's eaiser to work with,
% it makes sense to use it. 

% the task will have three conditions - low, medium, and high interference.
% the amount of interference of each condition will be determined by the
% similarity of distractors to a target. in the low interference condition,
% the target will be a red circle among blue squares. in the medium
% interference condition, the target will be a red circle or square among
% blue cirlces and squares. in the high interference condition, the target will
% be a red circle among red and blue squares. the idea is:
%
%       low interference - target and distractors share no dimensions
%       medium interference - target/distractors share one dimension
%       high interference - target/distractors share two dimensions
%
%% Practice Condition

function practiceCond(sjNum)


Screen('Preference','SkipSyncTests',1);    %added for laptop, delete later


sca;
PsychDefaultSetup(2);
InitializePsychSound(1);
ListenChar(0);
screenNumber = max(Screen('Screens'));
white = [255 255 255];
grey = white./2;
red=[255 0 0];
green=[0 255 0];
blue=[0 0 255];
ctr = 0;
error_ctr = 0;
while error_ctr == ctr
    try
        [window,rect] = Screen('OpenWindow',screenNumber,grey);
    catch
        error_ctr = error_ctr+1;
    end
    ctr = ctr+1;
end
[keyboardIndices, ~, ~] = GetKeyboardIndices('Apple Internal Keyboard / Trackpad');
KbName('UnifyKeyNames');
leftResp = KbName('f');
rightResp = KbName('j');
PsychImaging('PrepareConfiguration');
[xCenter, yCenter] = RectCenter(rect);
[~, screenYpixels] = Screen('WindowSize', window);
dim = 1;
[x, y] = meshgrid(dim-1:dim, dim-1:dim);
pixelScale = screenYpixels / (dim*2+2);
x = x .*pixelScale;
y = y .*pixelScale;
x1 = x(1,2);
y1 = y(2,1);
stimX = x - x1/2;
stimY = y - y1/2;
yScale = stimY(1,2);
xScale = stimX(1,2);
numChannels = 1;
soundRep = 1;
soundDur = 0.25;
waitForDeviceStart = 0;

numCond=3;
numTask = 2;
numCue = 1;

numBlocks = 2;
numTrials = 6;
valCueThres=2/3;
invalCueThres=1/3;

for cond=1:numCond
    
    if cond==1
        
        %low intf practice
    
        for task=1:numTask

            Screen('TextSize',window,50);
            Screen('TextFont',window,'Courier');
            ignoreTones=['Respond to the location of \n'...
                'the red circle with the F and J keys \n'...
                '(F = left and J = right) \n'...
                'ignore the tones.'];
            respTones=['Respond to the location of \n'...
                'the red circle with the F and J keys \n'...
                '(F = left and J = right) \n'...
                'unless you hear a high tone. \n'...
                'Do not respond when you \n'...
                'a high tone.'];

            if task==1
                DrawFormattedText(window,ignoreTones,'center','center',white);
                cueCond=1;
            elseif task==2
                DrawFormattedText(window,respTones,'center','center',white);
                cueCond=2;
            end

            Screen('Flip',window);
            KbStrokeWait;

            for cue=1:numCue

                if cueCond==1
                    cueInst=['\n The box is more likely to give \n the location of the target \n' ...
                        'Use this information.'];
                elseif cueCond==2
                    cueInst=['\n The box is less likely to give \n the location of the target \n' ...
                        'Use this information.'];
                end

                for block=1:numBlocks

                    singleTaskInst = ['You are about to see a sequence of letters. \n' ...
                        'Remember these letters in order. \n \n' ... 
                        'Remember to ignore the tones \n' ... 
                        'and respond to the location \n' ... 
                        'of the red circle \n \n'...
                        sprintf('%s',cueInst) '\n \n' ... 
                        'Press space when you are ready \n' ... 
                        'to see the letters.'];
                    dualTaskInst = ['You are about to see a sequence of letters. \n'... 
                        'Remember these letters in order. \n \n'...
                        'Remember to respond to the \n' ... 
                        'location of the red circle \n' ... 
                        'unless you hear a high tone.\n'...
                        'Do not respond when you \n' ...
                        'hear a high tone.\n \n ' ...
                        sprintf('%s',cueInst) '\n \n' ... 
                        'Press space when you are ready \n' ... 
                        'to see the letters.'];

                    Screen('TextSize', window, 30);

                    if task==1
                        DrawFormattedText(window,singleTaskInst,'center','center', white);
                    elseif task==2
                        DrawFormattedText(window,dualTaskInst,'center','center', white);
                    end

                    Screen('Flip',window);
                    KbStrokeWait
                    WaitSecs(.2)

                    %load WM

                    letters = ['A' 'B' 'C' 'D' 'E' 'F' 'G' 'H' 'I' 'J' 'K' 'L' 'M' 'N' 'O' 'P' 'Q' 'R' 'S' 'T' 'U' 'V' 'W' 'X' 'Y' 'Z'];
                    rng('shuffle');
                    LTs = randperm(26,5);
                    LT1 = LTs(1,1);
                    LT2 = LTs(1,2);
                    LT3 = LTs(1,3);
                    LT4 = LTs(1,4);
                    LT5 = LTs(1,5);
                    letter1 = letters(1,LT1);
                    letter2 = letters(1,LT2);
                    letter3 = letters(1,LT3);
                    letter4 = letters(1,LT4);
                    letter5 = letters(1,LT5);
                    Screen('TextSize', window, 35);
                    Screen('DrawText',window,letter1,xCenter - 1.5*xScale,yCenter,white);
                    Screen('DrawText',window,letter2,xCenter - .75*xScale,yCenter,white);
                    Screen('DrawText',window,letter3,xCenter,yCenter,white);
                    Screen('DrawText',window,letter4,xCenter + .75*xScale,yCenter,white);
                    Screen('DrawText',window,letter5,xCenter + 1.5*xScale,yCenter,white);
                    Screen('Flip',window);
                    WaitSecs(2);

                    Screen('FillRect',window,grey,[]);
                    Screen('Flip',window);
                    WaitSecs(0.5);

                    toneOrder=randperm(numTrials);
                    cueOrder=randperm(numTrials);

                    for trial=1:numTrials

                        %cue the target

                        rng('shuffle');
                        boxLctn = randi([0,100]);
                        xLctn = max(stimX);
                        if boxLctn<=50
                            CenX = min(xLctn);
                        elseif 50<boxLctn
                            CenX = max(xLctn);
                        end

                        %draw fixation cross

                        fixCrossDimPix = 20;
                        xCoords = [-fixCrossDimPix fixCrossDimPix 0 0];
                        yCoords = [0 0 -fixCrossDimPix fixCrossDimPix];
                        allCoords = [xCoords; yCoords];
                        lineWidthPix = 2;
                        crossSize=18;
                        baseRect = [0 0 x1 2*y1];
                        boxCenX = xCenter + CenX;
                        centeredRect = CenterRectOnPointd(baseRect, boxCenX, yCenter);
                        rectColor = [0 0 0]; 
                        Screen('BlendFunction', window, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');
                        Screen('TextSize', window, crossSize);
                        Screen('DrawLines',window,allCoords,lineWidthPix,white,[xCenter yCenter], 2);
                        Screen('Flip', window,[],1);
                        Screen('BlendFunction', window, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');
                        Screen('FrameRect',window,rectColor,centeredRect,1);
                        Screen('Flip', window);
                        WaitSecs(0.5);
                        Screen('BlendFunction', window, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');
                        Screen('TextSize', window, crossSize);
                        Screen('DrawLines',window,allCoords,lineWidthPix,white,[xCenter yCenter], 2);
                        Screen('Flip', window,[],1);
                        WaitSecs(0.25);

                        stimRect = [0 0 50 50];
                        maxDiameter = max(stimRect);

                        centeredRect1 = CenterRectOnPointd(stimRect, xCenter+stimX(1,1), yCenter+stimY(1,1));
                        centeredRect2 = CenterRectOnPointd(stimRect, xCenter+stimX(2,1), yCenter+stimY(2,1));
                        centeredRect3 = CenterRectOnPointd(stimRect, xCenter+stimX(1,2), yCenter+stimY(1,2));
                        centeredRect4 = CenterRectOnPointd(stimRect, xCenter+stimX(2,2), yCenter+stimY(2,2));

                        if cueCond == 1
                            thres=numTrials*valCueThres;
                        elseif cueCond==2
                            thres=numTrials*invalCueThres;
                        end

                        rng('shuffle');
                        targetLoc=randi(100);

                        if boxLctn<=50
                            if cueOrder(1,trial)<=thres
                                if targetLoc<=50
                                    Screen('FillOval', window, red, centeredRect1, maxDiameter);
                                    Screen('FillRect', window, blue, centeredRect2);
                                    Screen('FillRect', window, blue, centeredRect3);
                                    Screen('FillRect', window, blue, centeredRect4);
                                    target=1;
                                elseif 50<targetLoc
                                    Screen('FillOval', window, red, centeredRect2, maxDiameter);
                                    Screen('FillRect', window, blue, centeredRect1);
                                    Screen('FillRect', window, blue, centeredRect3);
                                    Screen('FillRect', window, blue, centeredRect4);
                                    target=2;                        
                                end
                            elseif thres<cueOrder(1,trial)
                                if targetLoc<=50
                                    Screen('FillOval', window, red, centeredRect3, maxDiameter);
                                    Screen('FillRect', window, blue, centeredRect1);
                                    Screen('FillRect', window, blue, centeredRect2);
                                    Screen('FillRect', window, blue, centeredRect4);
                                    target=3;
                                elseif 50<targetLoc
                                    Screen('FillOval', window, red, centeredRect4, maxDiameter);
                                    Screen('FillRect', window, blue, centeredRect1);
                                    Screen('FillRect', window, blue, centeredRect2);
                                    Screen('FillRect', window, blue, centeredRect3);
                                    target=4;
                                end
                            end
                        elseif 50<boxLctn
                            if cueOrder(1,trial)<=thres
                                if targetLoc<=50
                                    Screen('FillOval', window, red, centeredRect3, maxDiameter);
                                    Screen('FillRect', window, blue, centeredRect1);
                                    Screen('FillRect', window, blue, centeredRect2);
                                    Screen('FillRect', window, blue, centeredRect4);
                                    target=3;
                                elseif 50<targetLoc
                                    Screen('FillOval', window, red, centeredRect4, maxDiameter);
                                    Screen('FillRect', window, blue, centeredRect1);
                                    Screen('FillRect', window, blue, centeredRect2);
                                    Screen('FillRect', window, blue, centeredRect3);
                                    target=4;
                                end
                            elseif thres<cueOrder(1,trial)
                                if targetLoc<=50
                                    Screen('FillOval', window, red, centeredRect1, maxDiameter);
                                    Screen('FillRect', window, blue, centeredRect2);
                                    Screen('FillRect', window, blue, centeredRect3);
                                    Screen('FillRect', window, blue, centeredRect4);
                                    target=1;
                                elseif 50<targetLoc
                                    Screen('FillOval', window, red, centeredRect2, maxDiameter);
                                    Screen('FillRect', window, blue, centeredRect1);
                                    Screen('FillRect', window, blue, centeredRect3);
                                    Screen('FillRect', window, blue, centeredRect4);
                                    target=2;                        
                                end
                            end
                        end

                        %play tone. 2/3 low tone, 1/3 high tone

                        toneNum = toneOrder(1,trial);
                        if toneNum<=numTrials*(2/3)
                            tone = 300;
                        elseif numTrials*(2/3)<toneNum
                            tone = 600;
                        end
                        pahandle = PsychPortAudio('Open', [], 1, 1, 48000, numChannels);
                        PsychPortAudio('Volume', pahandle, 0.5);
                        beep = MakeBeep(tone, soundDur, 48000);
                        PsychPortAudio('FillBuffer', pahandle, beep);

                        %present stimuli

                        numSecs = 1;

                        taskResp=0;

                        tStart = Screen('Flip', window);
                        PsychPortAudio('Start', pahandle, soundRep, 0, waitForDeviceStart);

                        %record response

                        while GetSecs<=tStart+numSecs
                            if taskResp==0
                            [keyIsDown, tEnd, keyCode, ~] = KbCheck(keyboardIndices);
                                if keyIsDown == 1
                                    ind = find(keyCode ~=0);
                                    if ind == leftResp
                                        taskResp = 1;
                                    elseif ind == rightResp
                                        taskResp = 2;
                                    end
                                end
                            end
                        end
                        if tEnd==0
                            tEnd=GetSecs;
                        end

                        PsychPortAudio('Stop',pahandle,1,1);
                        PsychPortAudio('Close', pahandle);

                        if task==1
                            if target==1||target==2
                                if taskResp==1
                                    Screen('DrawLines',window,allCoords,lineWidthPix,green,[xCenter yCenter], 2);
                                else
                                    Screen('DrawLines',window,allCoords,lineWidthPix,red,[xCenter yCenter], 2);
                                end
                            elseif target==3||target==4
                                if taskResp==2
                                    Screen('DrawLines',window,allCoords,lineWidthPix,green,[xCenter yCenter], 2);
                                else
                                    Screen('DrawLines',window,allCoords,lineWidthPix,red,[xCenter yCenter], 2);
                                end
                            end
                        end
                        if task==2
                            if tone==300
                                if target==1||target==2
                                    if taskResp==1
                                        Screen('DrawLines',window,allCoords,lineWidthPix,green,[xCenter yCenter], 2);
                                    else
                                        Screen('DrawLines',window,allCoords,lineWidthPix,red,[xCenter yCenter], 2);
                                    end
                                elseif target==3||target==4
                                    if taskResp==2
                                        Screen('DrawLines',window,allCoords,lineWidthPix,green,[xCenter yCenter], 2);
                                    else
                                        Screen('DrawLines',window,allCoords,lineWidthPix,red,[xCenter yCenter], 2);
                                    end
                                end
                            elseif tone==600
                                if taskResp==0
                                    Screen('DrawLines',window,allCoords,lineWidthPix,green,[xCenter yCenter], 2);
                                else
                                    Screen('DrawLines',window,allCoords,lineWidthPix,red,[xCenter yCenter], 2);
                                end
                            end
                        end                

                        Screen('Flip', window);
                        WaitSecs(0.25);

                    end

                    %probe wm

                    Screen('TextSize', window, 30);
                    Screen('TextFont', window, 'Courier');
                    DrawFormattedText(window, 'Type the letters', 'center', yCenter + .75*yScale, white);
                    DrawFormattedText(window, 'Press any key to continue', 'center', yCenter - 1.5*yScale, white);
                    Screen('BlendFunction', window, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');
                    Screen('TextSize', window, 35);
                    Screen('DrawText',window,'_',xCenter - 1.5*xScale,yCenter,white);
                    Screen('DrawText',window,'_',xCenter - .75*xScale,yCenter,white);
                    Screen('DrawText',window,'_',xCenter,yCenter,white);
                    Screen('DrawText',window,'_',xCenter + .75*xScale,yCenter,white);
                    Screen('DrawText',window,'_',xCenter + 1.5*xScale,yCenter,white);
                    Screen('Flip',window,[],1);
                    wmResp = zeros(1,5);
                    numResp = 1;
                    loc=[xCenter - 1.5*xScale,xCenter - .75*xScale,xCenter,xCenter + .75*xScale,xCenter + 1.5*xScale];
                    while numResp <= 5
                        thisLoc = loc(1,numResp);
                        RestrictKeysForKbCheck(3:29);
                        [keyIsDown, ~, keyCode, ~] = KbCheck(keyboardIndices);
                            if keyIsDown == 1
                                ind = find(keyCode);
                                if size(ind,2)==1
                                    wmResp(1,numResp) = letters(1,ind-3);
                                    Screen('TextSize', window, 35);
                                    Screen('BlendFunction', window, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');
                                    Screen('DrawText',window,letters(1,ind-3),thisLoc,yCenter,white);
                                    Screen('Flip',window,[],1);
                                    numResp = numResp+1;
                                    KbWait(keyboardIndices,1);
                                end
                            end
                        RestrictKeysForKbCheck([]);
                    end

                    KbStrokeWait;
                    Screen('FillRect',window,grey);

                end

            end

        end
        
    end
    
    if cond==2

        %med intf practice

        for task=1:numTask

            Screen('TextSize',window,50);
            Screen('TextFont',window,'Courier');
            ignoreTones=['Respond to the location of \n'...
                'the red shape with the F and J keys \n'...
                '(F = left and J = right) \n'...
                'ignore the tones.'];
            respTones=['Respond to the location of \n'...
                'the red shape with the F and J keys \n'...
                '(F = left and J = right) \n'...
                'unless you hear a high tone. \n'...
                'Do not respond when you \n'...
                'a high tone.'];

            if task==1
                DrawFormattedText(window,respTones,'center','center',white);
                cueCondOrder=2;
            elseif task==2
                DrawFormattedText(window,ignoreTones,'center','center',white);
                cueCondOrder=1;
            end

            Screen('Flip',window);
            KbStrokeWait;

            for cue=1:numCue

                cueCond=cueCondOrder;

                if cueCond==1
                    cueInst=['\n The box is more likely to give \n the location of the target \n' ...
                        'Use this information.'];
                elseif cueCond==2
                    cueInst=['\n The box is less likely to give \n the location of the target \n' ...
                        'Use this information.'];
                end

                for block=1:numBlocks

                    singleTaskInst = ['You are about to see a sequence of letters. \n' ...
                        'Remember these letters in order. \n \n' ... 
                        'Remember to ignore the tones \n' ... 
                        'and respond to the location \n' ... 
                        'of the red shape. \n \n'...
                        sprintf('%s',cueInst) '\n \n' ... 
                        'Press space when you are ready \n' ... 
                        'to see the letters.'];
                    dualTaskInst = ['You are about to see a sequence of letters. \n'... 
                        'Remember these letters in order. \n \n'...
                        'Remember to respond to the \n' ... 
                        'location of the red shape. \n' ... 
                        'unless you hear a high tone.\n'...
                        'Do not respond when you \n' ...
                        'hear a high tone.\n \n ' ...
                        sprintf('%s',cueInst) '\n \n' ... 
                        'Press space when you are ready \n' ... 
                        'to see the letters.'];

                    Screen('TextSize', window, 30);

                    if task==2
                        DrawFormattedText(window,dualTaskInst,'center','center', white);
                    elseif task==1
                        DrawFormattedText(window,singleTaskInst,'center','center', white);
                    end

                    Screen('Flip',window);
                    KbStrokeWait
                    WaitSecs(.2)

                    %load WM

                    letters = ['A' 'B' 'C' 'D' 'E' 'F' 'G' 'H' 'I' 'J' 'K' 'L' 'M' 'N' 'O' 'P' 'Q' 'R' 'S' 'T' 'U' 'V' 'W' 'X' 'Y' 'Z'];
                    rng('shuffle');
                    LTs = randperm(26,5);
                    LT1 = LTs(1,1);
                    LT2 = LTs(1,2);
                    LT3 = LTs(1,3);
                    LT4 = LTs(1,4);
                    LT5 = LTs(1,5);
                    letter1 = letters(1,LT1);
                    letter2 = letters(1,LT2);
                    letter3 = letters(1,LT3);
                    letter4 = letters(1,LT4);
                    letter5 = letters(1,LT5);
                    Screen('TextSize', window, 35);
                    Screen('DrawText',window,letter1,xCenter - 1.5*xScale,yCenter,white);
                    Screen('DrawText',window,letter2,xCenter - .75*xScale,yCenter,white);
                    Screen('DrawText',window,letter3,xCenter,yCenter,white);
                    Screen('DrawText',window,letter4,xCenter + .75*xScale,yCenter,white);
                    Screen('DrawText',window,letter5,xCenter + 1.5*xScale,yCenter,white);
                    Screen('Flip',window);
                    WaitSecs(2);

                    Screen('FillRect',window,grey,[]);
                    Screen('Flip',window);
                    WaitSecs(0.5);

                    toneOrder=randperm(numTrials);
                    cueOrder=randperm(numTrials);

                    for trial=1:numTrials

                        %cue the target

                        rng('shuffle');
                        boxLctn = randi([0,100]);
                        xLctn = max(stimX);
                        if boxLctn<=50
                            CenX = min(xLctn);
                        elseif 50<boxLctn
                            CenX = max(xLctn);
                        end

                        %draw fixation cross

                        fixCrossDimPix = 20;
                        xCoords = [-fixCrossDimPix fixCrossDimPix 0 0];
                        yCoords = [0 0 -fixCrossDimPix fixCrossDimPix];
                        allCoords = [xCoords; yCoords];
                        lineWidthPix = 2;
                        crossSize=18;
                        baseRect = [0 0 x1 2*y1];
                        boxCenX = xCenter + CenX;
                        centeredRect = CenterRectOnPointd(baseRect, boxCenX, yCenter);
                        rectColor = [0 0 0]; 
                        Screen('BlendFunction', window, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');
                        Screen('TextSize', window, crossSize);
                        Screen('DrawLines',window,allCoords,lineWidthPix,white,[xCenter yCenter], 2);
                        Screen('Flip', window,[],1);
                        Screen('BlendFunction', window, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');
                        Screen('FrameRect',window,rectColor,centeredRect,1);
                        Screen('Flip', window);
                        WaitSecs(0.5);
                        Screen('BlendFunction', window, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');
                        Screen('TextSize', window, crossSize);
                        Screen('DrawLines',window,allCoords,lineWidthPix,white,[xCenter yCenter], 2);
                        Screen('Flip', window,[],1);
                        WaitSecs(0.25);

                        stimRect = [0 0 50 50];
                        maxDiameter = max(stimRect);

                        centeredRect1 = CenterRectOnPointd(stimRect, xCenter+stimX(1,1), yCenter+stimY(1,1));
                        centeredRect2 = CenterRectOnPointd(stimRect, xCenter+stimX(2,1), yCenter+stimY(2,1));
                        centeredRect3 = CenterRectOnPointd(stimRect, xCenter+stimX(1,2), yCenter+stimY(1,2));
                        centeredRect4 = CenterRectOnPointd(stimRect, xCenter+stimX(2,2), yCenter+stimY(2,2));

                        if cueCond == 1
                            thres=numTrials*valCueThres;
                        elseif cueCond==2
                            thres=numTrials*invalCueThres;
                        end

                        RGB1=[0 0 255];
                        RGB2=[0 0 255];
                        RGB3=[0 0 255];
                        RGB4=[0 0 255];

                        rng('shuffle');
                        targetLoc=randi(100);

                        if boxLctn<=50
                            if cueOrder(1,trial)<=thres
                                if targetLoc<=50
                                    RGB1(1,1)=255;
                                    RGB1(1,3)=0;
                                    target=1;
                                elseif 50<targetLoc
                                    RGB2(1,1)=255;
                                    RGB2(1,3)=0;
                                    target=2;                        
                                end
                            elseif thres<cueOrder(1,trial)
                                if targetLoc<=50
                                    RGB3(1,1)=255;
                                    RGB3(1,3)=0;
                                    target=3;
                                elseif 50<targetLoc
                                    RGB4(1,1)=255;
                                    RGB4(1,3)=0;
                                    target=4;
                                end
                            end
                        elseif 50<boxLctn
                            if cueOrder(1,trial)<=thres
                                if targetLoc<=50
                                    RGB3(1,1)=255;
                                    RGB3(1,3)=0;
                                    target=3;
                                elseif 50<targetLoc
                                    RGB4(1,1)=255;
                                    RGB4(1,3)=0;
                                    target=4;
                                end
                            elseif thres<cueOrder(1,trial)
                                if targetLoc<=50
                                    RGB1(1,1)=255;
                                    RGB1(1,3)=0;
                                    target=1;
                                elseif 50<targetLoc
                                    RGB2(1,1)=255;
                                    RGB2(1,3)=0;
                                    target=2;                        
                                end
                            end
                        end

                        rng('shuffle');
                        stimLoc=randi(100);

                        if stimLoc<=25
                            Screen('FillOval', window, RGB1, centeredRect1, maxDiameter);
                            Screen('FillRect', window, RGB2, centeredRect2);
                            Screen('FillRect', window, RGB3, centeredRect3);
                            Screen('FillRect', window, RGB4, centeredRect4);
                        elseif 25<stimLoc&&stimLoc<=50
                            Screen('FillOval', window, RGB2, centeredRect2, maxDiameter);
                            Screen('FillRect', window, RGB1, centeredRect1);
                            Screen('FillRect', window, RGB3, centeredRect3);
                            Screen('FillRect', window, RGB4, centeredRect4);
                        elseif 50<stimLoc&&stimLoc<=75
                            Screen('FillOval', window, RGB3, centeredRect3, maxDiameter);
                            Screen('FillRect', window, RGB1, centeredRect1);
                            Screen('FillRect', window, RGB2, centeredRect2);
                            Screen('FillRect', window, RGB4, centeredRect4);
                        elseif 75<stimLoc
                            Screen('FillOval', window, RGB4, centeredRect4, maxDiameter);
                            Screen('FillRect', window, RGB1, centeredRect1);
                            Screen('FillRect', window, RGB2, centeredRect2);
                            Screen('FillRect', window, RGB3, centeredRect3);
                        end

                        %play tone. 2/3 low tone, 1/3 high tone

                        toneNum = toneOrder(1,trial);
                        if toneNum<=numTrials*(2/3)
                            tone = 300;
                        elseif numTrials*(2/3)<toneNum
                            tone = 600;
                        end
                        pahandle = PsychPortAudio('Open', [], 1, 1, 48000, numChannels);
                        PsychPortAudio('Volume', pahandle, 0.5);
                        beep = MakeBeep(tone, soundDur, 48000);
                        PsychPortAudio('FillBuffer', pahandle, beep);

                        %present stimuli

                        numSecs = 1;

                        taskResp=0;

                        tStart = Screen('Flip', window);
                        PsychPortAudio('Start', pahandle, soundRep, 0, waitForDeviceStart);

                        %record response

                        while GetSecs<=tStart+numSecs
                            if taskResp==0
                            [keyIsDown, tEnd, keyCode, ~] = KbCheck(keyboardIndices);
                                if keyIsDown == 1
                                    ind = find(keyCode ~=0);
                                    if ind == leftResp
                                        taskResp = 1;
                                    elseif ind == rightResp
                                        taskResp = 2;
                                    end
                                end
                            end
                        end
                        if tEnd==0
                            tEnd=GetSecs;
                        end

                        PsychPortAudio('Stop',pahandle,1,1);
                        PsychPortAudio('Close', pahandle);

                        if task==2
                            if target==1||target==2
                                if taskResp==1
                                    Screen('DrawLines',window,allCoords,lineWidthPix,green,[xCenter yCenter], 2);
                                else
                                    Screen('DrawLines',window,allCoords,lineWidthPix,red,[xCenter yCenter], 2);
                                end
                            elseif target==3||target==4
                                if taskResp==2
                                    Screen('DrawLines',window,allCoords,lineWidthPix,green,[xCenter yCenter], 2);
                                else
                                    Screen('DrawLines',window,allCoords,lineWidthPix,red,[xCenter yCenter], 2);
                                end
                            end
                        end
                        if task==1
                            if tone==300
                                if target==1||target==2
                                    if taskResp==1
                                        Screen('DrawLines',window,allCoords,lineWidthPix,green,[xCenter yCenter], 2);
                                    else
                                        Screen('DrawLines',window,allCoords,lineWidthPix,red,[xCenter yCenter], 2);
                                    end
                                elseif target==3||target==4
                                    if taskResp==2
                                        Screen('DrawLines',window,allCoords,lineWidthPix,green,[xCenter yCenter], 2);
                                    else
                                        Screen('DrawLines',window,allCoords,lineWidthPix,red,[xCenter yCenter], 2);
                                    end
                                end
                            elseif tone==600
                                if taskResp==0
                                    Screen('DrawLines',window,allCoords,lineWidthPix,green,[xCenter yCenter], 2);
                                else
                                    Screen('DrawLines',window,allCoords,lineWidthPix,red,[xCenter yCenter], 2);
                                end
                            end
                        end                

                        Screen('Flip', window);
                        WaitSecs(0.25);

                    end

                    %probe wm

                    Screen('TextSize', window, 30);
                    Screen('TextFont', window, 'Courier');
                    DrawFormattedText(window, 'Type the letters', 'center', yCenter + .75*yScale, white);
                    DrawFormattedText(window, 'Press any key to continue', 'center', yCenter - 1.5*yScale, white);
                    Screen('BlendFunction', window, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');
                    Screen('TextSize', window, 35);
                    Screen('DrawText',window,'_',xCenter - 1.5*xScale,yCenter,white);
                    Screen('DrawText',window,'_',xCenter - .75*xScale,yCenter,white);
                    Screen('DrawText',window,'_',xCenter,yCenter,white);
                    Screen('DrawText',window,'_',xCenter + .75*xScale,yCenter,white);
                    Screen('DrawText',window,'_',xCenter + 1.5*xScale,yCenter,white);
                    Screen('Flip',window,[],1);
                    wmResp = zeros(1,5);
                    numResp = 1;
                    loc=[xCenter - 1.5*xScale,xCenter - .75*xScale,xCenter,xCenter + .75*xScale,xCenter + 1.5*xScale];
                    while numResp <= 5
                        thisLoc = loc(1,numResp);
                        RestrictKeysForKbCheck(3:29);
                        [keyIsDown, ~, keyCode, ~] = KbCheck(keyboardIndices);
                            if keyIsDown == 1
                                ind = find(keyCode);
                                if size(ind,2)==1
                                    wmResp(1,numResp) = letters(1,ind-3);
                                    Screen('TextSize', window, 35);
                                    Screen('BlendFunction', window, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');
                                    Screen('DrawText',window,letters(1,ind-3),thisLoc,yCenter,white);
                                    Screen('Flip',window,[],1);
                                    numResp = numResp+1;
                                    KbWait(keyboardIndices,1);
                                end
                            end
                        RestrictKeysForKbCheck([]);
                    end

                    KbStrokeWait;
                    Screen('FillRect',window,grey);

                end

            end

        end
        
    end
    
    if cond==3

        %high intf practice

        for task=1:numTask

            Screen('TextSize',window,50);
            Screen('TextFont',window,'Courier');
            ignoreTones=['Respond to the location of \n'...
                'the red circle with the F and J keys \n'...
                '(F = left and J = right) \n'...
                'ignore the tones.'];
            respTones=['Respond to the location of \n'...
                'the red circle with the F and J keys \n'...
                '(F = left and J = right) \n'...
                'unless you hear a high tone. \n'...
                'Do not respond when you \n'...
                'a high tone.'];

            if task==1
                DrawFormattedText(window,ignoreTones,'center','center',white);
                cueCond=1;
            elseif task==2
                DrawFormattedText(window,respTones,'center','center',white);
                cueCond=2;
            end

            Screen('Flip',window);
            KbStrokeWait;

            for cue=1:numCue

                if cueCond==1
                    cueInst=['\n The box is more likely to give \n the location of the target \n' ...
                        'Use this information.'];
                elseif cueCond==2
                    cueInst=['\n The box is less likely to give \n the location of the target \n' ...
                        'Use this information.'];
                end

                for block=1:numBlocks

                    singleTaskInst = ['You are about to see a sequence of letters. \n' ...
                        'Remember these letters in order. \n \n' ... 
                        'Remember to ignore the tones \n' ... 
                        'and respond to the location \n' ... 
                        'of the red circle. \n \n'...
                        sprintf('%s',cueInst) '\n \n' ... 
                        'Press space when you are ready \n' ... 
                        'to see the letters.'];
                    dualTaskInst = ['You are about to see a sequence of letters. \n'... 
                        'Remember these letters in order. \n \n'...
                        'Remember to respond to the \n' ... 
                        'location of the red circle. \n' ... 
                        'unless you hear a high tone.\n'...
                        'Do not respond when you \n' ...
                        'hear a high tone.\n \n ' ...
                        sprintf('%s',cueInst) '\n \n' ... 
                        'Press space when you are ready \n' ... 
                        'to see the letters.'];

                    Screen('TextSize', window, 30);

                    if task==1
                        DrawFormattedText(window,singleTaskInst,'center','center', white);
                    elseif task==2
                        DrawFormattedText(window,dualTaskInst,'center','center', white);
                    end

                    Screen('Flip',window);
                    KbStrokeWait
                    WaitSecs(.2)

                    %load WM

                    letters = ['A' 'B' 'C' 'D' 'E' 'F' 'G' 'H' 'I' 'J' 'K' 'L' 'M' 'N' 'O' 'P' 'Q' 'R' 'S' 'T' 'U' 'V' 'W' 'X' 'Y' 'Z'];
                    rng('shuffle');
                    LTs = randperm(26,5);
                    LT1 = LTs(1,1);
                    LT2 = LTs(1,2);
                    LT3 = LTs(1,3);
                    LT4 = LTs(1,4);
                    LT5 = LTs(1,5);
                    letter1 = letters(1,LT1);
                    letter2 = letters(1,LT2);
                    letter3 = letters(1,LT3);
                    letter4 = letters(1,LT4);
                    letter5 = letters(1,LT5);
                    Screen('TextSize', window, 35);
                    Screen('DrawText',window,letter1,xCenter - 1.5*xScale,yCenter,white);
                    Screen('DrawText',window,letter2,xCenter - .75*xScale,yCenter,white);
                    Screen('DrawText',window,letter3,xCenter,yCenter,white);
                    Screen('DrawText',window,letter4,xCenter + .75*xScale,yCenter,white);
                    Screen('DrawText',window,letter5,xCenter + 1.5*xScale,yCenter,white);
                    Screen('Flip',window);
                    WaitSecs(2);

                    Screen('FillRect',window,grey,[]);
                    Screen('Flip',window);
                    WaitSecs(0.5);

                    toneOrder=randperm(numTrials);
                    cueOrder=randperm(numTrials);

                    for trial=1:numTrials

                        %cue the target

                        rng('shuffle');
                        boxLctn = randi([0,100]);
                        xLctn = max(stimX);
                        if boxLctn<=50
                            CenX = min(xLctn);
                        elseif 50<boxLctn
                            CenX = max(xLctn);
                        end

                        %draw fixation cross

                        fixCrossDimPix = 20;
                        xCoords = [-fixCrossDimPix fixCrossDimPix 0 0];
                        yCoords = [0 0 -fixCrossDimPix fixCrossDimPix];
                        allCoords = [xCoords; yCoords];
                        lineWidthPix = 2;
                        crossSize=18;
                        baseRect = [0 0 x1 2*y1];
                        boxCenX = xCenter + CenX;
                        centeredRect = CenterRectOnPointd(baseRect, boxCenX, yCenter);
                        rectColor = [0 0 0]; 
                        Screen('BlendFunction', window, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');
                        Screen('TextSize', window, crossSize);
                        Screen('DrawLines',window,allCoords,lineWidthPix,white,[xCenter yCenter], 2);
                        Screen('Flip', window,[],1);
                        Screen('BlendFunction', window, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');
                        Screen('FrameRect',window,rectColor,centeredRect,1);
                        Screen('Flip', window);
                        WaitSecs(0.5);
                        Screen('BlendFunction', window, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');
                        Screen('TextSize', window, crossSize);
                        Screen('DrawLines',window,allCoords,lineWidthPix,white,[xCenter yCenter], 2);
                        Screen('Flip', window,[],1);
                        WaitSecs(0.25);

                        stimRect = [0 0 50 50];
                        maxDiameter = max(stimRect);

                        centeredRect1 = CenterRectOnPointd(stimRect, xCenter+stimX(1,1), yCenter+stimY(1,1));
                        centeredRect2 = CenterRectOnPointd(stimRect, xCenter+stimX(2,1), yCenter+stimY(2,1));
                        centeredRect3 = CenterRectOnPointd(stimRect, xCenter+stimX(1,2), yCenter+stimY(1,2));
                        centeredRect4 = CenterRectOnPointd(stimRect, xCenter+stimX(2,2), yCenter+stimY(2,2));

                        if cueCond == 1
                            thres=numTrials*valCueThres;
                        elseif cueCond==2
                            thres=numTrials*invalCueThres;
                        end

                        RGB1=[0 0 255];
                        RGB2=[0 0 255];
                        RGB3=[0 0 255];
                        RGB4=[0 0 255];

                        rng('shuffle');
                        targetLoc=randi(100);

                        rng('shuffle');
                        stimLoc=randi(100);

                        if boxLctn<=50
                            if cueOrder(1,trial)<=thres
                                if targetLoc<=50
                                    RGB1(1,1)=255;
                                    RGB1(1,3)=0;
                                    Screen('FillOval', window, RGB1, centeredRect1, maxDiameter);
                                    target=1;
                                    if stimLoc<=33
                                        RGB2(1,1)=255;
                                        RGB2(1,3)=0;
                                    elseif 33<stimLoc&&stimLoc<=66
                                        RGB3(1,1)=255;
                                        RGB3(1,3)=0;
                                    elseif 66<stimLoc
                                        RGB4(1,1)=255;
                                        RGB4(1,3)=0;
                                    end
                                    Screen('FillRect', window, RGB2, centeredRect2);
                                    Screen('FillRect', window, RGB3, centeredRect3);
                                    Screen('FillRect', window, RGB4, centeredRect4);
                                elseif 50<targetLoc
                                    RGB2(1,1)=255;
                                    RGB2(1,3)=0;
                                    Screen('FillOval', window, RGB2, centeredRect2, maxDiameter);
                                    target=2;
                                    if stimLoc<=33
                                        RGB1(1,1)=255;
                                        RGB1(1,3)=0;
                                    elseif 33<stimLoc&&stimLoc<=66
                                        RGB3(1,1)=255;
                                        RGB3(1,3)=0;
                                    elseif 66<stimLoc
                                        RGB4(1,1)=255;
                                        RGB4(1,3)=0;
                                    end
                                    Screen('FillRect', window, RGB1, centeredRect1);
                                    Screen('FillRect', window, RGB3, centeredRect3);
                                    Screen('FillRect', window, RGB4, centeredRect4);
                                end
                            elseif thres<cueOrder(1,trial)
                                if targetLoc<=50
                                    RGB3(1,1)=255;
                                    RGB3(1,3)=0;
                                    Screen('FillOval', window, RGB3, centeredRect3, maxDiameter);
                                    target=3;
                                    if stimLoc<=33
                                        RGB1(1,1)=255;
                                        RGB1(1,3)=0;
                                    elseif 33<stimLoc&&stimLoc<=66
                                        RGB2(1,1)=255;
                                        RGB2(1,3)=0;
                                    elseif 66<stimLoc
                                        RGB4(1,1)=255;
                                        RGB4(1,3)=0;
                                    end
                                    Screen('FillRect', window, RGB1, centeredRect1);
                                    Screen('FillRect', window, RGB2, centeredRect2);
                                    Screen('FillRect', window, RGB4, centeredRect4);
                                elseif 50<targetLoc
                                    RGB4(1,1)=255;
                                    RGB4(1,3)=0;
                                    Screen('FillOval', window, RGB4, centeredRect4, maxDiameter);
                                    target=4;
                                    if stimLoc<=33
                                        RGB1(1,1)=255;
                                        RGB1(1,3)=0;
                                    elseif 33<stimLoc&&stimLoc<=66
                                        RGB2(1,1)=255;
                                        RGB2(1,3)=0;
                                    elseif 66<stimLoc
                                        RGB3(1,1)=255;
                                        RGB3(1,3)=0;
                                    end
                                    Screen('FillRect', window, RGB1, centeredRect1);
                                    Screen('FillRect', window, RGB2, centeredRect2);
                                    Screen('FillRect', window, RGB3, centeredRect3);
                                end
                            end
                        elseif 50<boxLctn
                            if cueOrder(1,trial)<=thres
                                if targetLoc<=50
                                    RGB3(1,1)=255;
                                    RGB3(1,3)=0;
                                    Screen('FillOval', window, RGB3, centeredRect3, maxDiameter);
                                    target=3;
                                    if stimLoc<=33
                                        RGB1(1,1)=255;
                                        RGB1(1,3)=0;
                                    elseif 33<stimLoc&&stimLoc<=66
                                        RGB2(1,1)=255;
                                        RGB2(1,3)=0;
                                    elseif 66<stimLoc
                                        RGB4(1,1)=255;
                                        RGB4(1,3)=0;
                                    end
                                    Screen('FillRect', window, RGB1, centeredRect1);
                                    Screen('FillRect', window, RGB2, centeredRect2);
                                    Screen('FillRect', window, RGB4, centeredRect4);
                                elseif 50<targetLoc
                                    RGB4(1,1)=255;
                                    RGB4(1,3)=0;
                                    Screen('FillOval', window, RGB4, centeredRect4, maxDiameter);
                                    target=4;
                                    if stimLoc<=33
                                        RGB1(1,1)=255;
                                        RGB1(1,3)=0;
                                    elseif 33<stimLoc&&stimLoc<=66
                                        RGB2(1,1)=255;
                                        RGB2(1,3)=0;
                                    elseif 66<stimLoc
                                        RGB3(1,1)=255;
                                        RGB3(1,3)=0;
                                    end
                                    Screen('FillRect', window, RGB1, centeredRect1);
                                    Screen('FillRect', window, RGB2, centeredRect2);
                                    Screen('FillRect', window, RGB3, centeredRect3);
                                end
                            elseif thres<cueOrder(1,trial)
                                if targetLoc<=50
                                    RGB1(1,1)=255;
                                    RGB1(1,3)=0;
                                    Screen('FillOval', window, RGB1, centeredRect1, maxDiameter);
                                    target=1;
                                    if stimLoc<=33
                                        RGB2(1,1)=255;
                                        RGB2(1,3)=0;
                                    elseif 33<stimLoc&&stimLoc<=66
                                        RGB3(1,1)=255;
                                        RGB3(1,3)=0;
                                    elseif 66<stimLoc
                                        RGB4(1,1)=255;
                                        RGB4(1,3)=0;
                                    end
                                    Screen('FillRect', window, RGB2, centeredRect2);
                                    Screen('FillRect', window, RGB3, centeredRect3);
                                    Screen('FillRect', window, RGB4, centeredRect4);
                                elseif 50<targetLoc
                                    RGB2(1,1)=255;
                                    RGB2(1,3)=0;
                                    Screen('FillOval', window, RGB2, centeredRect2, maxDiameter);
                                    target=2;
                                    if stimLoc<=33
                                        RGB1(1,1)=255;
                                        RGB1(1,3)=0;
                                    elseif 33<stimLoc&&stimLoc<=66
                                        RGB3(1,1)=255;
                                        RGB3(1,3)=0;
                                    elseif 66<stimLoc
                                        RGB4(1,1)=255;
                                        RGB4(1,3)=0;
                                    end
                                    Screen('FillRect', window, RGB1, centeredRect1);
                                    Screen('FillRect', window, RGB3, centeredRect3);
                                    Screen('FillRect', window, RGB4, centeredRect4);
                                end
                            end
                        end

                        %play tone. 2/3 low tone, 1/3 high tone

                        toneNum = toneOrder(1,trial);
                        if toneNum<=numTrials*(2/3)
                            tone = 300;
                        elseif numTrials*(2/3)<toneNum
                            tone = 600;
                        end
                        pahandle = PsychPortAudio('Open', [], 1, 1, 48000, numChannels);
                        PsychPortAudio('Volume', pahandle, 0.5);
                        beep = MakeBeep(tone, soundDur, 48000);
                        PsychPortAudio('FillBuffer', pahandle, beep);

                        %present stimuli

                        numSecs = 1;

                        taskResp=0;

                        tStart = Screen('Flip', window);
                        PsychPortAudio('Start', pahandle, soundRep, 0, waitForDeviceStart);

                        %record response

                        while GetSecs<=tStart+numSecs
                            if taskResp==0
                            [keyIsDown, tEnd, keyCode, ~] = KbCheck(keyboardIndices);
                                if keyIsDown == 1
                                    ind = find(keyCode ~=0);
                                    if ind == leftResp
                                        taskResp = 1;
                                    elseif ind == rightResp
                                        taskResp = 2;
                                    end
                                end
                            end
                        end
                        if tEnd==0
                            tEnd=GetSecs;
                        end

                        PsychPortAudio('Stop',pahandle,1,1);
                        PsychPortAudio('Close', pahandle);

                        if task==1
                            if target==1||target==2
                                if taskResp==1
                                    Screen('DrawLines',window,allCoords,lineWidthPix,green,[xCenter yCenter], 2);
                                else
                                    Screen('DrawLines',window,allCoords,lineWidthPix,red,[xCenter yCenter], 2);
                                end
                            elseif target==3||target==4
                                if taskResp==2
                                    Screen('DrawLines',window,allCoords,lineWidthPix,green,[xCenter yCenter], 2);
                                else
                                    Screen('DrawLines',window,allCoords,lineWidthPix,red,[xCenter yCenter], 2);
                                end
                            end
                        end
                        if task==2
                            if tone==300
                                if target==1||target==2
                                    if taskResp==1
                                        Screen('DrawLines',window,allCoords,lineWidthPix,green,[xCenter yCenter], 2);
                                    else
                                        Screen('DrawLines',window,allCoords,lineWidthPix,red,[xCenter yCenter], 2);
                                    end
                                elseif target==3||target==4
                                    if taskResp==2
                                        Screen('DrawLines',window,allCoords,lineWidthPix,green,[xCenter yCenter], 2);
                                    else
                                        Screen('DrawLines',window,allCoords,lineWidthPix,red,[xCenter yCenter], 2);
                                    end
                                end
                            elseif tone==600
                                if taskResp==0
                                    Screen('DrawLines',window,allCoords,lineWidthPix,green,[xCenter yCenter], 2);
                                else
                                    Screen('DrawLines',window,allCoords,lineWidthPix,red,[xCenter yCenter], 2);
                                end
                            end
                        end                

                        Screen('Flip', window);
                        WaitSecs(0.25);

                    end

                    %probe wm

                    Screen('TextSize', window, 30);
                    Screen('TextFont', window, 'Courier');
                    DrawFormattedText(window, 'Type the letters', 'center', yCenter + .75*yScale, white);
                    DrawFormattedText(window, 'Press any key to continue', 'center', yCenter - 1.5*yScale, white);
                    Screen('BlendFunction', window, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');
                    Screen('TextSize', window, 35);
                    Screen('DrawText',window,'_',xCenter - 1.5*xScale,yCenter,white);
                    Screen('DrawText',window,'_',xCenter - .75*xScale,yCenter,white);
                    Screen('DrawText',window,'_',xCenter,yCenter,white);
                    Screen('DrawText',window,'_',xCenter + .75*xScale,yCenter,white);
                    Screen('DrawText',window,'_',xCenter + 1.5*xScale,yCenter,white);
                    Screen('Flip',window,[],1);
                    wmResp = zeros(1,5);
                    numResp = 1;
                    loc=[xCenter - 1.5*xScale,xCenter - .75*xScale,xCenter,xCenter + .75*xScale,xCenter + 1.5*xScale];
                    while numResp <= 5
                        thisLoc = loc(1,numResp);
                        RestrictKeysForKbCheck(3:29);
                        [keyIsDown, ~, keyCode, ~] = KbCheck(keyboardIndices);
                            if keyIsDown == 1
                                ind = find(keyCode);
                                if size(ind,2)==1
                                    wmResp(1,numResp) = letters(1,ind-3);
                                    Screen('TextSize', window, 35);
                                    Screen('BlendFunction', window, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');
                                    Screen('DrawText',window,letters(1,ind-3),thisLoc,yCenter,white);
                                    Screen('Flip',window,[],1);
                                    numResp = numResp+1;
                                    KbWait(keyboardIndices,1);
                                end
                            end
                        RestrictKeysForKbCheck([]);
                    end

                    KbStrokeWait;
                    Screen('FillRect',window,grey);

                end

            end

        end
        
    end
    
end

ListenChar(2);
sca;

return

