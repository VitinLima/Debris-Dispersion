function Fragments = Fragments(Sim)
    switch choice
          [indx,Ok] = listdlg("ListString", myOptions, "SelectionMode", "Single");
  until choice == 0 || choice == 4