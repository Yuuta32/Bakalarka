function fitness = Fitness1(robot, genotyp, map, maxSteps)
% Inicializácia premenných
fitness = 0; % Fitness začína na 0
threshold = 0.1; % Prah na zastavenie (robot sa považuje za "na mieste")
stepSize = 0.1; % Veľkosť jedného kroku
neunet = NNI8(genotyp);

for step = 1:maxSteps
    input = generateInput(robot, map);
    % Výpočet rýchlostí kolies pomocou neurónovej siete
    [Vl, Vr] = NeuronovaSiet(neunet, input); % Implementujte forward pass siete

    % Nastavenie rýchlostí kolies
    robot = robot.setWheelSpeed(Vr, Vl);

    % Aktualizácia stavu robota
    robot = robot.update(stepSize);

    % Výpočet vzdialenosti od cieľa
    distanceToTarget = sqrt((robot.xt - map.endX)^2 + (robot.yt - map.endY)^2);

    % Pridanie vzdialenosti do fitness funkcie
    fitness = fitness + distanceToTarget;

    % Kontrola, či robot dosiahol cieľ
    if distanceToTarget < threshold
        break; % Ak robot dosiahol cieľ, ukončite simuláciu
    end
end

% Penalizácia za zlyhanie
if distanceToTarget >= threshold
    fitness = fitness + 100; % Penalizácia za nedosiahnutie cieľa
end
end
function input = generateInput(robot, map)
% Získanie aktuálnej pozície
[currentX, currentY, currentPhi] = getCurrentPosition(robot);

% Získanie predchádzajúcej pozície
[prevX, prevY, prevPhi] = getPreviousPosition(robot);

% Vytvorenie vstupného vektora
input = [
    currentX; currentY; currentPhi; prevX; prevY; prevPhi; map.endX; map.endY
    ];
end
