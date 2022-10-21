function Fragment = SimulationEngine(BUSV, WindProfile, Fragment)
  
  Position = [BUSV.PositionEastOfLaunch BUSV.PositionNorthOfLaunch BUSV.Altitude];
  Velocity = [BUSV.EastVelocity BUSV.NorthVelocity BUSV.UpVelocity];
  
  Velocity += (rotz(Fragment.Beta)*roty(Fragment.Alpha)*[Fragment.ImpartedVelocity 0 0]')';
  Acceleration = AccelerationCalculator(Position, Velocity - WindProfile, Fragment);
  Time = [BUSV.TimeOfExplosion];
  
  Fragment.Position = Position;
  Fragment.Velocity = Velocity;
  Fragment.Acceleration = Acceleration;
  Fragment.Time = Time;
  
  Steps = 0;
  
  while Position(3) > 0
    TimeStep = TimeStepCalculator(Position,Velocity,Acceleration);
    Position = Position + Velocity.*TimeStep;
    Velocity = Velocity + Acceleration.*TimeStep;
    Acceleration = AccelerationCalculator(Position,Velocity - WindCalculator(WindProfile),Fragment);
    Time = Time + TimeStep;
    
    Fragment.Position(end+1,:) = Position;
    Fragment.Velocity(end+1,:) = Velocity;
    Fragment.Acceleration(end+1,:) = Acceleration;
    Fragment.Time(end+1) = Time;
    Steps++;
  endwhile
  
  Fragment.ImpactPosition = Position;
  Fragment.ImpactVelocity = Velocity;
  Fragment.ImpactAcceleration = Acceleration;
  Fragment.ImpactTime = Time;
  Fragment.NumberOfSteps = Steps;
endfunction