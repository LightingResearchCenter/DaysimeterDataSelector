function varargout = updateSelectionList(hObject, handles)
%UPDATESELECTIONLIST Summary of this function goes here
%   Detailed explanation goes here

filter = handles.popupmenu_filtertype.String{handles.popupmenu_filtertype.Value};

switch filter
    case 'All Types'
        idxFilter = true(size(handles.Selections));
    case 'Bed'
        idxFilter = vertcat(handles.Selections.Type) == SelectionType.Bed;
    case 'Device Error'
        idxFilter = vertcat(handles.Selections.Type) == SelectionType.Error;
    case 'Noncompliance'
        idxFilter = vertcat(handles.Selections.Type) == SelectionType.Noncompliance;
    case 'Observation'
        idxFilter = vertcat(handles.Selections.Type) == SelectionType.Observation;
    case 'Work'
        idxFilter = vertcat(handles.Selections.Type) == SelectionType.Work;
    otherwise
        error('Filter not recognized.');
end

if any(idxFilter)
    listString = handles.Selections.string;
    listString = listString(idxFilter);
    enable = 'on';
    idx = str2idx(listString);
    if numel(handles.ActiveSelectionIdx) == 1 && any(ismember(handles.ActiveSelectionIdx,idx))
        [lia,locb] = ismember(handles.ActiveSelectionIdx,idx);
        value = locb(lia);
    else
        value = 1;
    end
else
    listString = 'none';
    enable = 'off';
    value = 1;
end

handles.listbox_selections.Value  = value;
handles.listbox_selections.String = listString;
handles.listbox_selections.Max    = numel(listString);
handles.listbox_selections.Enable = enable;

handles.ActiveSelectionIdx = getSelectionIndex(handles);

if nargout == 1
    varargout{1} = handles;
end

guidata(hObject,handles)

end


function idx = str2idx(str)
% Convert string entries in listbox to Selection indicies

expression = '^\s*(\d+)\s.*$'; % Extract just the first number
idx = str2double(regexprep(str,expression,'$1'));

end

