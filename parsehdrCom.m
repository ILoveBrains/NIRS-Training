function info = parsehdr(file)
% This sub-routine parses the NIRx header info

info=struct;
% set variable fid to file as opened for reading (AM)
fid=fopen(file,'r');

% While true... (AM)
while(1)
   % sets line to the next line in the file (AM)
   line=fgetl(fid);
   % if the line is not a string, break (AM)
   if(~isstr(line))
       break
   end
   % if there are instances of '=' in the line (AM)
   if(~isempty(strfind(line,'=')))
       % if there aren't instances of '#' in this line (AM)
       if(isempty(strfind(line,'#')))
           % set fld to ... (AM)
           fld = line(1:strfind(line,'=')-1);
           % set val to ... (AM)
           val = line(strfind(line,'=')+1:end);
           % if val does not contain any instances of " (AM)
           if(isempty(strfind(val,'"')))
               % convert val from sting/char to numbers (AM)
               val=str2num(val);
           % otherwise, (AM)
           else
               % ... (AM)
               val(strfind(val,'"'))=[];
           end
       % Otherwise... (AM)
       else
           % matrix- read until next #
           fld = line(1:strfind(line,'=')-1);
           cnt=1; val=[];
           while(1)
               line=fgetl(fid);
               if(isempty(strfind(line,'#')))
                   val(cnt,:)=str2num(line);
                   cnt=cnt+1;
               else
                   break;
               end
           end
       end
       fld(strfind(fld,'-'))='_';
       fld(strfind(fld,' '))='_';
       info=setfield(info,fld,val);
   elseif(~isempty(strfind(line,'[')))
       %header skip
   end

end
% Rest at 1 second % 6 is the eventmarker % 1 is the frame
rest = [1,6,1];
% just put the rest on top of the variable
info.Events = vertcat(rest,info.Events);
fclose(fid);