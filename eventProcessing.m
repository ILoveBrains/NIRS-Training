% Event to look for
% This function is for addition of events when you know what you are
% looking for as a marker. This means that you can add an event 200ms after
% another marker, or add in one if it is followed by another

%timing should be taking the time of the event and adding or subtracting
%% FORMAT FOR EVENTS
% Time EventMarker Frame
function [eventsOut]=eventProcessing(events,evtMark2Add,timing,firstEvent,samplingRate)
outEventAry = [];
%Checks to see if there are two inputs, the second is used as the second
%mark
if length(evtMark2Add) == 2
    secMarkYes = 1;
end
%is the problem just at the begining of the code?
if firstEvent == 1
    fLine = events(:,1);
    fEvTimeAdd = fLine(1) + timing;
    %Create the first event to add before everything else
    fEventAdd = sprintf('%d %d %d',fEvTimeAdd,evtMark2Add,round(fEvTimeAdd/samplingRate));
    eventsOut = vertcat(fEventAdd,events);
    for i = 1:length(events)
        curLine = events(:,i);
        nextLine = events(:,i+1);
        %write current line
        % check if this is the first marker event
        if curLine == evtMark
            %add in the event
            %Check if you want to check the next event
            if secMarkYes == 1
                if nextLine == Mark2

                end
            %If you dont need a second marker    
            else
               outEventAry = vertcat(outEventAry,event2add); %#ok<AGROW>
            end    
        else
            %Add the curline to output
            outEventAry = vertcat(outEventAry,curLine); %#ok<AGROW>
        end
    end    
end