function varargout = reposition_overview_highlight(handles)
%REPOSITION_OVERVIEW_HIGHLIGHT Reposition overview highlight
%   Detailed explanation goes here

yyaxis(handles.axes_detail,'left');
yyaxis(handles.axes_overview,'left');
xHighlight = [handles.axes_detail.XLim(1),handles.axes_detail.XLim(1),handles.axes_detail.XLim(2),handles.axes_detail.XLim(2)];
yHighlight = [0, handles.axes_overview.YLim(2), handles.axes_overview.YLim(2), 0];

handles.OverviewHighlight = findobj(handles.axes_overview,'Tag','OverviewHighlight');
set(handles.OverviewHighlight,'XData',xHighlight,'YData',yHighlight);

if nargout == 1
    varargout = {handles};
end

end

