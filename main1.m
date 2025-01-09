% Rozmery mapy
mapSize = 50;

% Inicializácia mapy
map = Map(mapSize, 10, 10, 40, 30);
map.draw();

% Inicializácia robota
robot = Robot(map.startX, map.startY, 0);

% Parametre simulácie
krok = 0.05;
maxt = 30;

draw(robot);

for t = 0:krok:maxt
    robot = update(robot,krok);
if(t<25)
    robot = robot.setWheelSpeed(1,1);
else
    robot = robot.setWheelSpeed(1,1.5);
end

end
robot.drawTrajectory();
draw(robot);
    
