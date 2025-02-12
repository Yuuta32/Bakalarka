clc;
clear;
close all;

% Počiatočné nastavenia
mapSize = 50; % Veľkosť mapy
startX = 10; startY = 10; % Počiatočné súradnice
endX = 40; endY = 30; % Koncové súradnice
map = Map(mapSize, startX, startY, endX, endY); % Inicializácia mapy

% Parametre genetického algoritmu
populationSize = 100; % Veľkosť populácie
genotypeLength = 178; % Dĺžka genotypu (záleží od tvojej neurónovej siete)
mutationRate = 0.01; % Pravdepodobnosť mutácie génu
eliteCount = 10; % Počet elitných jedincov
maxGenerations = 200; % Maximálny počet iterácií

% Inicializácia populácie
space = [-1 * ones(1, genotypeLength); 1 * ones(1, genotypeLength)]; % Genotypové hranice
population = genrpop(populationSize, space); % Náhodná inicializácia populácie
topFit = []; % Pre uchovanie fitness najlepších jedincov

% Simulačné parametre
maxSteps = 1000; % Maximálny počet krokov simulácie

for generation = 1:maxGenerations

    ln = size(population,1);
    
    fitness = zeros(ln, 1); % Uchovanie fitness hodnôt
    
    % Výpočet fitness pre každého jedinca
    for i = 1:ln
        % Inicializácia robota
        robot = Robot(startX, startY, 0); % Počiatočná pozícia robota
        
        % Výpočet fitness pomocou tvojej funkcie
        fitness(i) = Fitness1(robot, population(i, :), map, maxSteps);
    end
    
    % Najlepšia fitness a index
    [minFitness, bestIdx] = min(fitness);
    topFit = [topFit, minFitness]; % Sledovanie fitness najlepšieho jedinca
    
    % Skontrolovať, či je cieľ dosiahnutý
    if minFitness < 3000 % Napríklad: cieľová fitness hodnota je pozitívna
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
    [~, sortedIdx] = sort(fitness, 'ascend');
    elite = population(sortedIdx(1:eliteCount), :); % Elitní jedinci
    selectedPop = population(sortedIdx(1:ceil(populationSize / 2)), :); % Top 50% populácie

    % Kríženie na vytvorenie novej generácie
    newPop = crossov(selectedPop, 1, 0); % 2-bodové kríženie
    newPop(1:eliteCount, :) = elite; % Pridanie elitných jedincov

    % Mutácia
    newPop = mutx(newPop, mutationRate, space);

    % Aktualizácia populácie
    population = newPop;

    % Výpis stavu
    disp(['Generácia ', num2str(generation), ': Najlepšia fitness hodnota = ', num2str(minFitness)]);
end

% Ak cieľ nebol dosiahnutý
if minFitness <= 0.1
    disp('Maximálny počet generácií dosiahnutý. Cieľ nebol dosiahnutý.');
end

% Graf fitness hodnôt
figure;
plot(1:length(topFit), topFit, 'LineWidth', 2);
xlabel('Generácia');
ylabel('Fitness hodnota');
grid on;
title('Vývoj fitness hodnôt');
