function varargout = reposition_overview_highlight(handles)
%REPOSITION_OVERVIEW_HIGHLIGHT Reposition overview highlight
%   Detailed explanation goes here

yyaxis(handles.axes_detail,'left');
xHighlight = [handles.axes_detail.XLim(1),handles.axes_detail.XLim(1),handles.axes_detail.XLim(2),handles.axes_detail.XLim(2)];
yHighlight = [    0,    1,    1,    0];

handles.OverviewHighlight = findobj(handles.axes_overview,'Tag','OverviewHighlight');
set(handles.OverviewHighlight,'XData',xHighlight,'YData',yHighlight);

if nargout == 1
    varargout = {handles};
end


end

