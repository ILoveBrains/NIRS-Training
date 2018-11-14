function info = parsehdr(file)
% This sub-routine parses the NIRx header info

info=struct;

fid=fopen(file,'r');

while(1)
    line=fgetl(fid);
    if(~isstr(line))
        break
    end
    if(~isempty(strfind(line,'=')))
        if(isempty(strfind(line,'#')))
            fld = line(1:strfind(line,'=')-1);
            val = line(strfind(line,'=')+1:end);
            if(isempty(strfind(val,'"')))
                val=str2num(val);
            else
                val(strfind(val,'"'))=[];
            end
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

rest = [1,6,1];
info.Events = vertcat(rest,info.Events);
fclose(fid);
