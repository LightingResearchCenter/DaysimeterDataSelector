function idx = getSelectionIndex(handles)
%GETSELECTIONINDEX Summary of this function goes here
%   Detailed explanation goes here

str   = handles.listbox_selections.String;
value = handles.listbox_selections.Value;
if iscell(str)
    sel = str(value);
else
    sel = str;
end

if any(strcmpi(sel,'none'))
    idx = 0;
else
    idx = str2idx(sel);
end

end


function idx = str2idx(str)
% Convert string entries in listbox to Selection indicies

expression = '^\s*(\d+)\s.*$'; % Extract just the first number
idx = str2double(regexprep(str,expression,'$1'));

end

