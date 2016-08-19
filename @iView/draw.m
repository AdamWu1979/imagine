function draw(obj, ~, ~)

persistent dBGImg
% dBGImg = [];
if isempty(dBGImg)
    dBGImg = fBGImg(obj(1).hParent.dBGCOLOR);
end

% -------------------------------------------------------------------------
% Timer logic for hd mode
% if nargin > 1
%     % Stop timer to make sure it doesn't fire again
%     stop(obj.STimers.hDrawFancy);
%     lHD = obj.isOn('hd');
% else
%     if obj.isOn('hd')
%         % Reset and start timer
%         stop(obj.STimers.hDrawFancy);
%         start(obj.STimers.hDrawFancy);
%     end
    lHD = false;
% end
% -------------------------------------------------------------------------


% -------------------------------------------------------------------------
% Determine some drawing parameters
% dGamma         = get(obj.SSliders(1).hScatter, 'XData');
% dMaskAlpha     = obj.getSlider('Mask Alpha');
% dQuiverWidth   = obj.getSlider('Quiver Width');
% sDrawMode      = obj.getDrawMode;
% -------------------------------------------------------------------------


% -------------------------------------------------------------------------
% Initialize windowing limits for phase and linked cases
% if strcmp(sDrawMode, 'phase')
%     dMin = -pi; dMax = pi;
% elseif obj.isOn('lock_window') && obj.SView(1).iData
%     dMin = obj.SData(obj.SView(1).iData).dWindowCenter - 0.5.*obj.SData(obj.SView(1).iData).dWindowWidth;
%     dMax = obj.SData(obj.SView(1).iData).dWindowCenter + 0.5.*obj.SData(obj.SView(1).iData).dWindowWidth;
% end
% -------------------------------------------------------------------------


% -------------------------------------------------------------------------
% Loop over all views

% iImgInd = 0;
for iI = 1:numel(obj)
    
    hView = obj(iI);

    if isempty(hView.hData)

        set(hView.hI, 'CData', dBGImg, 'XData', [1 size(dBGImg, 2)], 'YData', [1 size(dBGImg, 1)]);

    else

        for hData = hView.hData

            % -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -
            % Get the image data, do windowing and apply colormap
            for iDimInd = 1:length(hView.hA)
                [dImg, dXData, dYData]  = hData.getData(hView.DrawCenter, iDimInd, lHD);
                set(hView.hI(iDimInd), 'CData', dImg, 'XData', dXData, 'YData', dYData);%, 'AlphaData', dAlpha);
            end
    %                 
    %             case 'vector'
    %                 
    %                 set(SView.hQuiver, 'XData', dXData, 'YData', dYData, 'Visible', 'on', 'LineWidth', dQuiverWidth);
    %                 set(SView.hQuiver.Edge, 'ColorBinding', 'interpolated', 'ColorData', uint8(dImg))
    %         end

    %         set(SView.hText(1, 1, :),  'String', sprintf('[%d]: %s', SView.iData(1), obj.SData(SView.iData(1)).sName), 'Visible', 'on');
            %             set(SView.hAxes, 'Color', obj.dColormap(1,:));

        end
    end
end

function dImg = fBGImg(dColor)
dLogo = [0 0 0 1 1 0 0 0; ...
         0 0 0 1 1 0 0 0; ...
         0 0 0 0 0 0 0 0; ...
         0 0 1 1 1 0 0 0; ...
         0 0 0 1 1 0 0 0; ...
         0 0 0 1 1 0 0 0; ...
         0 0 1 1 1 1 0 0; ...
         0 0 0 0 0 0 0 0;];
dPattern = 0.8 + 0.1*rand(16) + 0.2*padarray(dLogo, [4 4], 0, 'both');
dPattern = dPattern.*repmat(linspace(1, 0.8, 16)', [1, 16]);
dPattern = repmat(dPattern, [1 1 3]);

dImg = repmat(permute(dColor, [1 3 2]), [16 16 1]).*dPattern;