classdef Selection
    %SELECTION Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        StartDateTime  datetime
        EndDateTime    datetime
        Type           char
        GraphicsHandle matlab.graphics.GraphicsPlaceholder
    end
    
    methods
        function obj = Selection(varargin)
            if nargin > 0
                p = inputParser;
                expectedTypes = {'observation','error','noncompliance','bed'};
                
                addRequired(p,'StartDateTime',@isdatetime);
                addRequired(p,'EndDateTime',@isdatetime);
                addOptional(p,'Type','noncompliance',...
                    @(x) any(validatestring(x,expectedTypes)));
                addOptional(p,'Axes',gca)
                
                parse(p,varargin{:});
                
                obj.StartDateTime = p.Results.StartDateTime;
                obj.EndDateTime   = p.Results.EndDateTime;
                obj.Type          = p.Results.Type;
            end % end of if nargin > 0
        end % end of class constructor method
        
        function obj = UpdateGraphic(obj)
            if ~isvalid(obj.GraphicsHandle)
                % Create graphic
                
            end % end of ~isvalid
        end % end of UpdateGraphic method
    end % end of public methods
    
end

