function BUSV = BUSV(Sim)
##  if isempty(Sim.BUSV)
##    BUSV = struct();
##  else
##    BUSV = Sim.BUSV;
##  endif
  BUSV = Sim.BUSV;
  
  do
    choice = menu("BUSV",{"interpolate from source file","set BUSV manually","back"});
    switch choice
      case 0
##        if isempty(Sim.BUSV)
##          BUSV = struct();
##        else
##          BUSV = Sim.BUSV;
##        endif
        BUSV = Sim.BUSV;
      case 1
        if !isempty(Sim.SourceFile)
          tmp = inputdlg("Time to interpolate:","Break Up State Vector");
          if !isempty(tmp)
            tmp = str2double(tmp);
            if isnan(tmp) || tmp <= 0
              waitfor(msgbox("Invalid number"));
            else
              BUSV.TimeOfExplosion = tmp;
              BUSV.PositionEastOfLaunch = interp1(Sim.SourceFile.FileData.Time, Sim.SourceFile.FileData.PositionEastOfLaunch, BUSV.TimeOfExplosion);
              BUSV.PositionNorthOfLaunch = interp1(Sim.SourceFile.FileData.Time, Sim.SourceFile.FileData.PositionNorthOfLaunch, BUSV.TimeOfExplosion);
              BUSV.Altitude = interp1(Sim.SourceFile.FileData.Time, Sim.SourceFile.FileData.Altitude, BUSV.TimeOfExplosion);
              BUSV.TotalVelocity = interp1(Sim.SourceFile.FileData.Time, Sim.SourceFile.FileData.TotalVelocity, BUSV.TimeOfExplosion);
              BUSV.VerticalOrientation = interp1(Sim.SourceFile.FileData.Time, Sim.SourceFile.FileData.VerticalOrientation, BUSV.TimeOfExplosion);
              BUSV.LateralOrientation = interp1(Sim.SourceFile.FileData.Time, Sim.SourceFile.FileData.LateralOrientation, BUSV.TimeOfExplosion);
              BUSV.EastVelocity = BUSV.TotalVelocity*cosd(BUSV.VerticalOrientation)*cosd(BUSV.LateralOrientation);
              BUSV.NorthVelocity = BUSV.TotalVelocity*cosd(BUSV.VerticalOrientation)*sind(BUSV.LateralOrientation);
              BUSV.UpVelocity = BUSV.TotalVelocity*sind(BUSV.VerticalOrientation);
              BUSV.PropellantMass = interp1(Sim.SourceFile.FileData.Time, Sim.SourceFile.FileData.PropellantMass, BUSV.TimeOfExplosion);
              BUSV.NormalTrajectory.Time = Sim.SourceFile.FileData.Time;
              BUSV.NormalTrajectory.PositionEastOfLaunch = Sim.SourceFile.FileData.PositionEastOfLaunch;
              BUSV.NormalTrajectory.PositionNorthOfLaunch = Sim.SourceFile.FileData.PositionNorthOfLaunch;
              BUSV.NormalTrajectory.Altitude = Sim.SourceFile.FileData.Altitude;
            endif
          endif
        else
          waitfor(msgbox("You must choose a Open Rocket export file to interpolate."));
        endif
      case 2
        waitfor(msgbox("Not yet implemented"));
    endswitch
  until choice == 0 || choice == 3
endfunction