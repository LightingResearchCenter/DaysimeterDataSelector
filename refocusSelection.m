function refocusSelection(hObject, handles)
%REFOCUSSELECTION Summary of this function goes here
%   Detailed explanation goes here

if numel(handles.ActiveSelectionIdx) == 1 && handles.ActiveSelectionIdx > 0
    Lim = handles.Selections(handles.ActiveSelectionIdx).Lim;
    zoomLevel = getXZoom(handles);
    if (Lim(2)-Lim(1)) <= zoomLevel
        value = datenum(Lim(1) + (Lim(2)-Lim(1))/2);
    else
        value = datenum(Lim(1));
    end
    handles.slider_detailposition.Value = value;
    % Position detail window
    handles = reposition_detail_window(handles);
end

guidata(hObject,handles);

end

