function choice = timezoneDlg(str)
%TIMEZONEDLG Summary of this function goes here
%   Detailed explanation goes here

% Determine local time zone
t = datetime('now','TimeZone','local');
thisTz = t.TimeZone;
thisArea = regexprep(thisTz,'(.*)/.*','$1');

areas = {'Africa';'America';'Antarctica';'Arctic';'Asia';'Atlantic';'Australia';'Etc';'Europe';'Indian';'Pacific'};
[~, locArea] = ismember(thisArea,areas);
Tzs = timezones(thisArea);
areaTzNames = Tzs.Name;
[~, locTz] = ismember(thisTz,areaTzNames);


d = dialog('Name','Select Time Zone');
d.Position = [d.Position(1) d.Position(2) 350 250];

txtStr = uicontrol('Parent',d,...
    'Style','text',...
    'Position',[20 180 310 40],...
    'String',str,...
    'FontWeight','bold');

txtArea = uicontrol('Parent',d,...
    'Style','text',...
    'Position',[70 150 210 40],...
    'String','Area');

popupArea = uicontrol('Parent',d,...
    'Style','popup',...
    'Position',[126 140 100 25],...
    'String',areas,...
    'Value',locArea,...
    'Callback',@popupArea_callback);

txtTz = uicontrol('Parent',d,...
    'Style','text',...
    'Position',[70 80 210 40],...
    'String','Time Zone');

popupTz = uicontrol('Parent',d,...
    'Style','popup',...
    'Position',[75 70 200 25],...
    'String',areaTzNames,...
    'Value',locTz,...
    'Callback',@popupTz_callback);

btn = uicontrol('Parent',d,...
    'Position',[140 20 70 25],...
    'String','OK',...
    'Callback','delete(gcf)');

choice = thisTz; % Default choice if window is closed

% Wait for d to close before running to completion
uiwait(d);

    function popupArea_callback(popup,event)
        idx = popup.Value;
        popup_items = popup.String;
        choiceArea = char(popup_items(idx,:));
        
        areaTz = timezones(choiceArea);
        popupTz.Value = 1;
        popupTz.String = areaTz.Name;
        choice = char(popupTz.String(popupTz.Value,:));
    end


    function popupTz_callback(popup,event)
        idx = popup.Value;
        popup_items = popup.String;
        choice = char(popup_items(idx,:));
    end

end

