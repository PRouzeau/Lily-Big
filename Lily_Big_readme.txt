To see the simulation of printer, run the Delta_simulator.scad in OpenScad
The parameters of this simulation are defined in 'data_Lily2.scad' which calls 
'angles.scad' for the angle columns parts.
effector simulation use stl files created in Effector_Lily_Big.scad
To creates STL files, define a part Number in data_Lily2.scad in OpenScad
To creates STL files for the effector, define a part Number in Effector_Lily_Big.scad in OpenScad
You also can run the batch files (Windows) to get all the STL files. 
Note that calculmating the stl file will take some time, you may update your file manager.
Wait the final execution of a batch file before starting the next one.

You can also create DXF files for the panels with a batch.

Note that the directory STL_Big and DXF shall exist to have the batch file working.

The parts and instructions for Direct drive extruder is in the repository Dual-Bowden-Extruder-Direct-Drive
Note that the right and left extruders are not identical but mirrored. 
You have to print the parts for each side ('normal' and 'mirrored').

Read the presentation and assembly manual for details

Text/Spreadsheet file formats are Libre office/Open office

references
https://github.com/Prouzeau/Lily-Big
https://github.com/PRouzeau/Bowden-extruder-direct-drive
http://rouzeau.net/Print3D/Lily_Big
http://rouzeau.net/twg/index.php?twg_album=3DPrint%2FLily  Lily photos Gallery
http://rouzeau.net/twg/index.php?twg_album=3DPrint%2FDBox  D-Box photo gallery

and details how to manipulate the printer simulation are in 
https://github.com/PRouzeau/OpenSCAD-Delta-Simulator

Recent versions of OpenSCAD are needed, prefer the development snapshots:
http://www.openscad.org/downloads.html#snapshots

