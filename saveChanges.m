function varargout = saveChanges(hObject, handles)
%SAVECHANGES Summary of this function goes here
%   Detailed explanation goes here

handles.SourceData(handles.ActiveDataIdx) = selections2d12pack(handles.Selections, handles.SourceData(handles.ActiveDataIdx));

guidata(hObject, handles)

if nargout == 1
    varargout = {handles};
end

end

