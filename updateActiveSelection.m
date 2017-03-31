function varargout = updateActiveSelection(hObject, handles)
%UPDATEACTIVESELECTION Summary of this function goes here
%   Detailed explanation goes here


if numel(handles.ActiveSelectionIdx) == 1 && handles.ActiveSelectionIdx > 0
    Lim  = handles.Selections(handles.ActiveSelectionIdx).Lim;
    
    handles.dragLine1.Position = Lim(1);
    handles.dragLine2.Position = Lim(2);
    
    dateFormat =  1; % 'dd-mmm-yyyy', ex. 01-Mar-2000
    timeFormat = 13; % 'HH:MM:SS', ex. 15:45:17
    
    sDate = datestr(Lim(1),dateFormat);
    sTime = datestr(Lim(1),timeFormat);
    startString = sprintf('%s\n%s',sDate,sTime);
    
    eDate = datestr(Lim(2),dateFormat);
    eTime = datestr(Lim(2),timeFormat);
    endString = sprintf('%s\n%s',eDate,eTime);
    
    enable = 'on';
    
    Type = handles.Selections(handles.ActiveSelectionIdx).Type;
    buttonTag = ['radiobutton_',lower(char(Type(1)))];
    button = findobj(handles.uibuttongroup_type,'Tag',buttonTag);
    handles.uibuttongroup_type.SelectedObject = button;
else
    startString = '';
    endString = '';
    
    enable = 'off';
end

handles.text_start.String = startString;
handles.text_end.String   = endString;

handles.dragLine1.Visible = enable;
handles.dragLine2.Visible = enable;

if nargout == 1
    varargout{1} = handles;
end

guidata(hObject,handles);

end

