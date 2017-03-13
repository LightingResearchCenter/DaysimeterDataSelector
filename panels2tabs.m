function tabs = panels2tabs(parent,panels)
%PANELS2TABS Summary of this function goes here
%   Detailed explanation goes here

% Create tab group
tabgp = uitabgroup(parent);

% Scale up because inside of tab is smaller
tabgp.Units = panels(1).Units;
position = panels(1).Position./[1,1,0.9967,0.9634];
tabgp.Position = position;

nTabs = numel(panels);
tabs = gobjects(nTabs,1);
for iTab = 1:nTabs
    % Create tab, copy title from panel
    tabs(iTab) = uitab(tabgp,'Title',panels(iTab).Title);
    % Copy tag from panel
    tabs(iTab).Tag = panels(iTab).Tag;
    % Move children of panel to tab
    children = get(panels(iTab),'Children');
    set(children,'Parent', tabs(iTab));
    % Delete original panel
    delete(panels(iTab));
end

end

