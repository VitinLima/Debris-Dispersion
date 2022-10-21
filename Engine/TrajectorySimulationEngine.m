function Fragment = SimulationEngine(BUSV, WindProfile, Fragment, BUEnergyDensity)
  
  Fragment.Position = zeros(Fragment.NumberOfSteps+1,3);
  Fragment.Velocity = zeros(Fragment.NumberOfSteps+1,3);
  Fragment.Acceleration = zeros(Fragment.NumberOfSteps+1,3);
  Fragment.Time = zeros(Fragment.NumberOfSteps+1,1);
  
  Fragment.Position(1,:) = [BUSV.PositionEastOfLaunch BUSV.PositionNorthOfLaunch BUSV.Altitude];
  Fragment.Velocity(1,:) = [BUSV.EastVelocity BUSV.NorthVelocity BUSV.UpVelocity];
  
  Fragment.Velocity(1,:) += (rotz(Fragment.Beta)*roty(Fragment.Alpha)*[Fragment.ImpartedVelocity 0 0]')';
  Fragment.Acceleration(1,:) = AccelerationCalculator(Position, Velocity - WindProfile, Fragment);
  Fragment.Time(1) = [BUSV.TimeOfExplosion];
  
  for k = 2:Fragment.NumberOfSteps+1
    TimeStep = TimeStepCalculator(Position(k-1,:),Velocity(k-1,:),Acceleration(k-1,:));
    Fragment.Position(k,:) = Position(k-1,:) + Velocity(k-1,:).*TimeStep;
    Fragment.Velocity(k,:) = Velocity(k-1,:) + Acceleration(k-1,:).*TimeStep;
    Fragment.Acceleration(k,:) = AccelerationCalculator(Position(k,:),Velocity(k,:) - WindCalculator(WindProfile),Fragment);
    Fragment.Time(k) = Fragment.Time(k-1) + TimeStep;
  endfor
endfunction