classdef Map
    %UNTITLED5 Summary of this class goes here
    %   Detailed explanation goes here

    properties
        size
        startX
        startY
        endX
        endY
    end

    methods
        % inicializácia mapy
        function map = Map(size, startX, startY, endX, endY)
            map.size = size;
            map.startX = startX;
            map.startY = startY;
            map.endX = endX;
            map.endY = endY;
        end

        % Vizualizácia mapy
        function draw(map)
            % Vykreslenie počiatočného a koncového bodu
            hold on;
            plot(map.startX, map.startY, 'o', 'Color', 'green', 'MarkerSize', 10);
            plot(map.endX, map.endY, '+', 'Color', 'red', 'MarkerSize', 10);
            xlim([0, map.size]);
            ylim([0, map.size]);
            xlabel('X-ová os');
            ylabel('Y-ová os');
            grid on;
        end
    end
end