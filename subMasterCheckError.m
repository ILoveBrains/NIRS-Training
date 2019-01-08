
% if one of the events deviates from the norm throw it on screen
length(rawEdited(1,1).stimulus.values{1,1}.dur)

%% TO DO : create a master values list
mastervalues(1) = 1;
mastervalues(2) = 2;
mastervalues(3) = 3;
mastervalues(4) = 4;
mastervalues(5) = 5;
mastervalues(6) = 6;
mastervalues(7) = 7;
mastervalues(8) = 8;
mastervalues(9) = 9;
mastervalues(10) = 10;
mastervalues(11) = 11;
mastervalues(12) = 12;
mastervalues(13) = 13;
errorSubs = cell(length(raw),1);
% one loop per subject
for i = 1:length(raw)
    % one loop per stim
    for n = 1:length(length(raw(i).stimulus.values))
        
        if length(raw(i,1).stimulus.values(1,n).dur) == length(mastervalues(1,n))
           fprintf('Subject %d stim %d is correct',n,i)
        else
            fprintf('ERROR WITH SUBJECT %d STIM %d',n,i)
            errorSubs{i,1} = raw(i).description;
            break
            %missing an event, throw it on the screen
        end
    end
    disp(errorSubs)
end    