function setSliderLim(handles)
%SETSLIDERLIM Summary of this function goes here
%	handles    structure with handles and user data (see GUIDATA)

handles.slider_detailposition.Min = datenum(handles.DisplayData.Time(1));
handles.slider_detailposition.Max = datenum(handles.DisplayData.Time(end));
handles.slider_detailposition.Value = handles.slider_detailposition.Min;

end

