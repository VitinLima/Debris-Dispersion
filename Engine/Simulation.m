function Sim = Simulation(Sim)
  if isempty(Sim.WindProfile)
    Sim.WindProfile = [0 0 0];
  endif
  H = waitbar(0);
  for i = 1:length(Sim.Fragments)
    for j = 1:length(Sim.Fragments(i).Fragment)
      Sim.Fragments(i).Fragment(j) = SimulationEngine(Sim.BUSV, Sim.WindProfile, Sim.Fragments(i).Fragment(j));
      waitbar(j/length(Sim.Fragments(i).Fragment), H, strjoin({"List ",num2str(i)," of ",num2str(length(Sim.Fragments))},''));
    endfor
    Sim.Fragments(i).Status = "Simulated";
  endfor
  close(H);
endfunction