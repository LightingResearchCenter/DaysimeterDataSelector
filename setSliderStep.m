function setSliderStep(handles)
%SETSLIDERSTEP Summary of this function goes here
%	handles    structure with handles and user data (see GUIDATA)

zoomLevel_days = days(getXZoom(handles));
handles.slider_detailposition.SliderStep = [0.01*zoomLevel_days,0.1*zoomLevel_days];

end