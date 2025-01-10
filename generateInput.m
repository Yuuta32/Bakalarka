function input = generateInput(robot, map)
% Získanie aktuálnej pozície
[currentX, currentY, currentPhi] = getCurrentPosition(robot);

% Získanie predchádzajúcej pozície
[prevX, prevY, prevPhi] = getPreviousPosition(robot);

% Vytvorenie vstupného vektora
input = [
    currentX; currentY; currentPhi; prevX; prevY; prevPhi; map.endX; map.endY
    ];
% Diagnostický výpis
   % disp("Vektor 'input':");
   % disp(input);

    % Kontrola správneho počtu prvkov
    if length(input) ~= 8
        error("Vektor 'input' má nesprávny počet prvkov: %d (očakáva sa 8)", length(input));
    end
end