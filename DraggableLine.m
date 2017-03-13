classdef DraggableLine
    %DRAGGABLELINE Summary of this class goes here
    %   Detailed explanation goes here
    
    %% properties public
    properties % (Access = public)
        Handle
    end % end of properties public
    
    %% properties dependent
    properties (Dependent = true)
        Position
    end % end of properties dependent
    
    %% properties protected
    properties (Access = protected)
        
    end % end of properties protected
    
    %% methods public
    methods % (Access = public)
        function obj = DraggableLine(varargin)
            switch nargin
                case 0
                    ax = gca;
                    x  = diff(ax.XLim)/2 + ax.XLim(1);
                    x  = [x, x];
                    lw = 2;
                    c = 'blue';
                case 1
                    ax = varargin{1};
                    x  = diff(ax.XLim)/2 + ax.XLim(1);
                    x  = [x, x];
                    lw = 2;
                    c  = 'blue';
                case 2
                    ax = varargin{1};
                    x  = varargin{2};
                    x  = [x, x];
                    lw = 2;
                    c  = 'blue';
                case 3
                    ax = varargin{1};
                    x  = varargin{2};
                    x  = [x, x];
                    lw = varargin{3};
                    c  = 'blue';
                case 4
                    ax = varargin{1};
                    x  = varargin{2};
                    x  = [x, x];
                    lw = varargin{3};
                    c  = varargin{4};
                otherwise
                    warning('Too many input arguments')
                    ax = gca;
                    x  = diff(ax.XLim)/2 + ax.XLim(1);
                    x  = [x, x];
                    lw = 2;
                    c  = 'blue';
            end % end of switch nargin
            axes(ax);
            f = gcf;
            y = ax.YLim;
            obj.Handle = line(ax, x, y, 'LineWidth', lw, 'Color', c);
            obj.Handle.Tag = 'draggable';
            obj.Handle.ButtonDownFcn = @(src,eventdata)obj.startDrag(src,eventdata);
            f.WindowButtonUpFcn = @(src,eventdata)obj.stopDrag(src,eventdata);
            f.WindowButtonMotionFcn = @(src,eventdata)obj.mouseMove(src,eventdata);
        end % end of DraggableLine method
        
        %--- Property Access Methods ---%
        function obj = set.Position(obj,position)
            obj.Handle.XData = position*[1 1];
        end % end of set Position
        
        function position = get.Position(obj)
            position = obj.Handle.XData(1);
        end % end of get Position
        
    end % end of methods public
    
    %% methods protected
    methods (Access = protected)
        %--- Dragging Methods ---%
        function obj = startDrag(obj,src,eventdata)
            set(gcf,'Pointer','left');
            axes(obj.Handle.Parent);
            f = gcf;
            f.WindowButtonMotionFcn = @(src,eventdata)obj.dragging(src,eventdata);
        end % end of startDrag
        
        function obj = dragging(obj,src,eventdata)
            pt = obj.Handle.Parent.CurrentPoint;
            obj.Handle.XData = pt(1)*[1 1];
        end % end of dragging
        
        function obj = stopDrag(obj,src,eventdata)
            set(gcf,'Pointer','arrow');
            axes(obj.Handle.Parent);
            f = gcf;
            f.WindowButtonMotionFcn = @(src,eventdata)obj.mouseMove(src,eventdata);
        end % end of stopDrag
        
        %--- Hover Methods ---%
        function obj = mouseMove(obj,src,eventdata)
            current_object = hittest;
            if strcmpi(current_object.Tag,'draggable')
                set(gcf,'Pointer','left');
            else
                set(gcf,'Pointer','arrow');
            end
        end % end of mouseMove
        
    end % end of mehtods protected
    
end % end of class definition

