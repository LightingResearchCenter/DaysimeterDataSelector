function [tabgp,tabs] = panels2tabs(parent,panels)
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
    tabs(iTab) = uitab(tabgp,'Title',panels(iTab).Title);
    tabs(iTab).Tag = panels(iTab).Tag;
    panels(iTab).Parent     = tabs(iTab);
    panels(iTab).Title      = '';
    panels(iTab).BorderType = 'none';
end

end

