classdef Robot
    %UNTITLED3 Summary of this class goes here
    %   Detailed explanation goes here

    properties
        % Pozícia a orientácia
        xt
        yt
        phi

        % Parametre pohybu
        L = 1 % Vzdialenosť medzi kolesami
        Vl = 0 % Rýchlosť ľavého kolesa
        Vr = 0 % Rýchlosť pravého kolesa
        V = 0 % Lineárna rýchlosť
        omega = 0 % Uhlová rýchlosť
        
        % História pohybu
        minX
        minY
    end

    methods
        % Inicializácia robota
        function rob = Robot(x, y, phi)
            rob.xt = x;
            rob.yt = y;
            rob.phi = phi;
            rob.minX = x;
            rob.minY = y;
        end

        % Aktualizácia stavu robota
        function rob = update(rob, krok)
            % Výpočet rýchlosti
            rob.V = (rob.Vl + rob.Vr) / 2;
            rob.omega = (rob.Vr - rob.Vl) / rob.L;
            
            % Aktualizácia orientácie
            rob.phi = mod(rob.phi + rob.omega * krok + pi, 2*pi) - pi;
            
            % Aktualizácia pozície
            rob.xt = rob.xt + rob.V * cos(rob.phi) * krok;
            rob.yt = rob.yt + rob.V * sin(rob.phi) * krok;
            
            % Uloženie trajektórie
            rob.minX = [rob.minX, rob.xt];
            rob.minY = [rob.minY, rob.yt];
        end

        function rob = setWheelSpeed(rob,SpeedR,SpeedL)
            rob.Vr = SpeedR;
            rob.Vl = SpeedL;
        end

        % Normalizácia pre vstup do neurónovej siete
        function [normX, normY, normPhi] = normalize(obj, mapSize)
            normX = obj.xt / mapSize;
            normY = obj.yt / mapSize;
            normPhi = obj.phi / pi;
        end

        function draw(rob)
            % Výpočet polohy kolies
            prak(1) = rob.xt + (rob.L/2) * sin(rob.phi);
            prak(2) = rob.yt - (rob.L/2) * cos(rob.phi);
        
            lavk(1) = rob.xt - (rob.L/2) * sin(rob.phi);
            lavk(2) = rob.yt + (rob.L/2) * cos(rob.phi);

            plot(prak(1), prak(2), 'o', 'Color', 'green');
            plot(lavk(1), lavk(2), 'o', 'Color', 'red');
            plot([lavk(1), prak(1)], [lavk(2), prak(2)], 'Color', 'blue');

            hold on;
            plot(rob.xt, rob.yt, '+', 'Color', 'blue');
        end
        function drawTrajectory(rob)
            plot(rob.minX, rob.minY, '+', 'Color', 'magenta');
        end
    end
end