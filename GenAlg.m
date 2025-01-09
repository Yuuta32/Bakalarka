clc;
clear;
close all;

% Počiatočné nastavenia
mapSize = 50; % Veľkosť mapy
startX = 0; startY = 0; % Počiatočné súradnice
endX = 40; endY = 30; % Koncové súradnice
map = Map(mapSize, startX, startY, endX, endY); % Inicializácia mapy

% Parametre genetického algoritmu
populationSize = 50; % Veľkosť populácie
genotypeLength = 178; % Dĺžka genotypu (záleží od tvojej neurónovej siete)
mutationRate = 0.01; % Pravdepodobnosť mutácie génu
eliteCount = 5; % Počet elitných jedincov
maxGenerations = 20; % Maximálny počet iterácií

% Inicializácia populácie
space = [-1 * ones(1, genotypeLength); 1 * ones(1, genotypeLength)]; % Genotypové hranice
population = genrpop(populationSize, space); % Náhodná inicializácia populácie
topFit = []; % Pre uchovanie fitness najlepších jedincov

% Simulačné parametre
maxSteps = 1000; % Maximálny počet krokov simulácie

for generation = 1:maxGenerations
    fitness = zeros(populationSize, 1); % Uchovanie fitness hodnôt
    
    % Výpočet fitness pre každého jedinca
    for i = 1:populationSize
        % Inicializácia robota
        robot = Robot(startX, startY, 0); % Počiatočná pozícia robota
        
        % Výpočet fitness pomocou tvojej funkcie
        fitness(i) = Fitness1(robot, population(i, :), map, maxSteps);
    end
    
    % Najlepšia fitness a index
    [maxFitness, bestIdx] = max(fitness);
    topFit = [topFit, maxFitness]; % Sledovanie fitness najlepšieho jedinca
    
    % Skontrolovať, či je cieľ dosiahnutý
    if maxFitness > 0 % Napríklad: cieľová fitness hodnota je pozitívna
        disp(['Cieľ dosiahnutý v generácii ', num2str(generation)]);
        disp('Najlepší genotyp:');
        disp(population(bestIdx, :));
        
        % Vizualizácia trajektórie najlepšieho jedinca
        bestGenotype = population(bestIdx, :);
        robot = Robot(startX, startY, 0);
        figure; hold on; grid on;
        map.draw();
        for step = 1:maxSteps
            
            input = generateInput(robot, map);
            % Výstup neurónovej siete
            neunet = NNI8(bestGenotype);
            [Vl, Vr] = NeuronovaSiet(neunet, input);
            
            % Aktualizácia robota
            robot = robot.setWheelSpeed(Vr, Vl);
            robot = robot.update(0.1);
            
            % Vykreslenie trajektórie
            robot.drawTrajectory();
            pause(0.01);
            
            % Kontrola, či je cieľ dosiahnutý
            if sqrt((robot.xt - endX)^2 + (robot.yt - endY)^2) < 0.1
                break;
            end
        end
        hold off;
        break;
    end
    
    % Výber najlepších jedincov
    [~, sortedIdx] = sort(fitness, 'descend');
    elite = population(sortedIdx(1:eliteCount), :); % Elitní jedinci
    selectedPop = population(sortedIdx(1:ceil(populationSize / 2)), :); % Top 50% populácie

    % Kríženie na vytvorenie novej generácie
    newPop = crossov(selectedPop, 2, 0); % 2-bodové kríženie
    newPop(1:eliteCount, :) = elite; % Pridanie elitných jedincov

    % Mutácia
    newPop = mutx(newPop, mutationRate, space);

    % Aktualizácia populácie
    population = newPop;

    % Výpis stavu
    disp(['Generácia ', num2str(generation), ': Najlepšia fitness hodnota = ', num2str(maxFitness)]);
end

% Ak cieľ nebol dosiahnutý
if maxFitness <= 0
    disp('Maximálny počet generácií dosiahnutý. Cieľ nebol dosiahnutý.');
end

% Graf fitness hodnôt
figure;
plot(1:length(topFit), topFit, 'LineWidth', 2);
xlabel('Generácia');
ylabel('Fitness hodnota');
grid on;
title('Vývoj fitness hodnôt');
