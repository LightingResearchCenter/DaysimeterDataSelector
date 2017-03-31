function varargout = reposition_detail_window(handles)
%REPOSITION_DETAIL_WINDOW Reposition detail window
%   Detailed explanation goes here

zoomLevel = getXZoom(handles);

% Convert slider position to center point
XCenter = datetime(handles.slider_detailposition.Value,'ConvertFrom','datenum','TimeZone',handles.DisplayData.Time.TimeZone);

% Set detail window axis limits
XLim1 = XCenter - zoomLevel/2;
XLim2 = XCenter + zoomLevel/2;
handles.axes_detail.XLim = [XLim1, XLim2];

handles = reposition_overview_highlight(handles);

if nargout == 1
    varargout = {handles};
end


end

