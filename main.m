clear;
close all;
clc;

tic;

do
  choice = menu("Debris Dispersion main menu:", {"New Simulation", "Load Simulation", "Exit"});
  switch choice
    case 0
      return;
    case 1
      Sim = struct("SourceFile",[],"NormalTrajectory",[],"BUSV",[],"WindProfile",[],"Fragments",[],"Analysis",[]);
    case 2
      cd Simulations;
      [FileName,FilePath,Fileltidx] = uigetfile(".txt","File name:");
      if FileName!=0
        load(FileName,"Sim");
      endif
      cd ..;
    case 3
      return;
  endswitch
until exist('Sim')

do
  choice = menu("Debris Dispersion", {"New Simulation","Load Simulation","Save Simulation","Settings..","Run Simulation","Analysis..","Exit"});
  switch choice
    case 0
      if !isempty(Sim.SourceFile) || !isempty(Sim.NormalTrajectory) || !isempty(Sim.BUSV) || !isempty(Sim.Fragments) || !isempty(Sim.Analysis)
        btn = questdlg("Save current simulation?","Load simulation","Yes");
      else
        btn = "No";
      endif
      if strcmp(btn,"Yes")
        cd Simulations;
        FileName = cell2mat(inputdlg("Save as:", "Save simulation"));
        if !isempty(FileName)
          save(strjoin({FileName,".txt"},''),"Sim");
        endif
        cd ..;
      endif
      if strcmp(btn, "Cancel")
        choice = nan;
      endif
    case 1
      if !isempty(Sim.SourceFile) || !isempty(Sim.NormalTrajectory) || !isempty(Sim.BUSV) || !isempty(Sim.Fragments) || !isempty(Sim.Analysis)
        btn = questdlg("Save current simulation?","Load simulation","Yes");
      else
        btn = "No";
      endif
      if strcmp(btn,"Yes")
        cd Simulations;
        FileName = cell2mat(inputdlg("Save as:", "Save simulation"));
        if !isempty(FileName)
          save(strjoin({FileName,".txt"},''),"Sim");
        endif
        cd ..;
      elseif strcmp(btn, "No")
        Sim = struct("SourceFile",[],"NormalTrajectory",[],"BUSV",[],"WindProfile",[],"Fragments",[],"Analysis",[]);
      endif
    case 2
      cd Simulations;
      if !isempty(Sim.SourceFile) || !isempty(Sim.NormalTrajectory) || !isempty(Sim.BUSV) || !isempty(Sim.Fragments) || !isempty(Sim.Analysis)
        btn = questdlg("Save current simulation?","Load simulation","Yes");
      else
        btn = "No";
      endif
      if strcmp(btn,"Yes")
        FileName = cell2mat(inputdlg("Save as:", "Save simulation"));
        if !isempty(FileName)
          save(strjoin({FileName,".txt"},''),"Sim");
        endif
      elseif strcmp(btn, "No")
        [FileName,FilePath,Fileltidx] = uigetfile(".txt","File name:");
        if FileName!=0
          load(FileName,"Sim");
        endif
      endif
      cd ..;
    case 3
      cd Simulations;
      FileName = cell2mat(inputdlg("Save as:", "Save simulation"));
      if !isempty(FileName)
        save(strjoin({FileName,".txt"},''),"Sim");
      endif
      cd ..;
    case 4
      cd Settings;
      Sim = Settings(Sim);
      cd ..;
    case 5
      cd Engine;
      Sim = Simulation(Sim);
      cd ..;
    case 6
      cd Analysis;
      Sim.Analysis = Analysis(Sim);
      cd ..;
    case 7
      if !isempty(Sim.SourceFile) || !isempty(Sim.NormalTrajectory) || !isempty(Sim.BUSV) || !isempty(Sim.Fragments) || !isempty(Sim.Analysis)
        btn = questdlg("Save current simulation?","Load simulation","Yes");
      else
        btn = "No";
      endif
      if strcmp(btn,"Yes")
        cd Simulations;
        FileName = cell2mat(inputdlg("Save as:", "Save simulation"));
        if !isempty(FileName)
          save(strjoin({FileName,".txt"},''),"Sim");
        endif
        cd ..;
      endif
      if strcmp(btn, "Cancel")
        choice = nan;
      endif
  endswitch
until choice == 0 || choice == 7

toc