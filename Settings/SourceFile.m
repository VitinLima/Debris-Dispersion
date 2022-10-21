function SourceFile = SourceFile(Sim)
##  if isempty(Sim.SourceFile)
##    SourceFile = struct();
##  else
##    SourceFile = Sim.SourceFile;
##  endif
  SourceFile = Sim.SourceFile;
  
  cd OpenRocketSimulations;
  [FileName,FilePath,Fileltidx] = uigetfile(".csv","File name:");%strjoin({input("File name:\n", "s"),".csv"},'');
  if FileName == 0
    cd ..;
    return;
  endif
  [fid, MSG] = fopen(FileName);
  cd ..;
  if fid == -1
    waitfor(msgbox(MSG));
    return;
  endif
  
  FileData.Title = substr(fgetl(fid), 3);
  FileData.Info = substr(fgetl(fid), 3);
  fgetl(fid);
  Warnings = {};
  while !strcmp(s = fgetl(fid), "#") && s != -1
    Warnings(end+1) = substr(s, 5);
  endwhile
  FileData.Warnings = Warnings;
  FileData.Variables = strsplit(substr(fgetl(fid), 3), ",");
  FileEvents = {};
  Data = zeros(0, str2double((strsplit(FileData.Info))(1,6)));
  while (s = fgetl(fid)) != -1
    if strncmp(s, "# Event", 7)
      FileEvents(1,end+1) = substr(s, 3);
    else
      Data(end+1,:) = str2double(strsplit(s, ","));
    endif
  endwhile
  FileData.SimulationEvents = FileEvents;
  FileData.Time = Data(:, find(strcmp(FileData.Variables, "Time (s)")));
  FileData.PositionEastOfLaunch = Data(:, find(strcmp(FileData.Variables, "Position East of launch (m)")));
  FileData.PositionNorthOfLaunch = Data(:, find(strcmp(FileData.Variables, "Position North of launch (m)")));
  FileData.Altitude = Data(:, find(strcmp(FileData.Variables, "Altitude (m)")));
  FileData.TotalVelocity = Data(:, find(strcmp(FileData.Variables, "Total velocity (m/s)")));
  FileData.VerticalOrientation = Data(:, find(strcmp(FileData.Variables, "Vertical orientation (zenith) (°)")));
  FileData.LateralOrientation = Data(:, find(strcmp(FileData.Variables, "Lateral orientation (azimuth) (°)")));
  FileData.PropellantMass = Data(:, find(strcmp(FileData.Variables, "Propellant mass (g)")));
  fclose(fid);
  
  SourceFile.FileName = FileName;
  SourceFile.FileData = FileData;
endfunction