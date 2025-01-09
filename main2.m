clc;
clear;
close all;

% Rozmery mapy
mapSize = 50;
genotypeLength = 178;

% Inicializácia mapy
map = Map(mapSize, 10, 10, 40, 30);
% map.draw();

% Inicializácia robota
robot = Robot(map.startX, map.startY, 0);

% Parametre simulácie
krok = 0.05;
maxt = 100;

space = [-1 * ones(1, genotypeLength); 1 * ones(1, genotypeLength)]; % Genotypové hranice
genotyp = genrpop(1, space); % Náhodná inicializácia populácie

fitness = Fitness1(robot, genotyp, map, maxt);
map.draw();
drawAllStates(robot);

