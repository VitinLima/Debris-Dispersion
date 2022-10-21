function [ENUAcceleration, Yaw, Pitch, Roll] = AccelerationCalculator(ENUPosition,ENUVelocity,Fragment)
  
##  Efetua o somat�rio de for�as atuando em um fragmento para determinar a acelera��o do mesmo.
  
  Yaw = atan2d(ENUVelocity(2), ENUVelocity(1));
  Pitch = atan2d(ENUVelocity(3), sqrt(ENUVelocity(2)*ENUVelocity(2) + ENUVelocity(1)*ENUVelocity(1)));
  Roll = 180;
  R_ENU_V = rotx(-Roll)'*roty(-Pitch)'*rotz(Yaw)';
  
  EarthGravity = 9.80665; %Gravidade da terra
  ENUGravity = [0 0 -EarthGravity]'; %Vetor gravidade do sistema ENU (considerada constante)
  AtmosphereDensity = 1.225; %Densidade da atmosfera a nivel do mar (considerada constante)
  
  D = Fragment.Cd*Fragment.Area*AtmosphereDensity*ENUVelocity*ENUVelocity'/2; %For�a de arrasto (FAA)
  L = Fragment.CldR*D; %For�a de sustenta��o (FAA)
  
  OAcceleration = [-D 0 -L]'/Fragment.Mass; %Acelera��o do objeto orientada em seu sistema de coordenadas
  
  ENUAcceleration = R_ENU_V'*OAcceleration + ENUGravity; %Acelera��o do objeto orientada no sistema ENU
  ENUAcceleration = ENUAcceleration';
endfunction