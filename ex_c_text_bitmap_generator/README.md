# Digital Design and Computer Architecture
## IC 27: ex_c_test_bitmap_generator VGA Example
## Introduction
This example will drive letter code (as set by the switches) to the VGA screen. The letter code will appear at each location on the VGA screen.

__vga_sync.vhd__
   * This vhdl generates the timing signals for the VGA port.

__font_rom.vhd__
   * This vhdl file contains the bitmap ROM for the different characters

__font_test_gen.vhd__
   * This vhdl file wires up the font_rom and generates output signals that are sent to the VGA port

__font_test_top.vhd__
   * This vhdl file interfaces to the board.

# Important notes:
* If you leave the Vivado project running when you got to re-run the project generation (./gen.sh), the generation will fail! You MUST close Vivado when re-generating a project!
* Always READ the outputs of the ./gen.sh script. If you see Error messages, something is wrong and you will need to fix the errors!
* Warnings are not neccessarily a problem.

# Generating the bistream
This project does not have a simulation. To generate a bitstream, do the following, open a bash terminal in vscode, and run the following command in the terminal:
```
./gen.sh
```
This will generate the Vivado project automatically. Open the folder multibitshifter/ that the script generates and run the .xpr file for the vivado project.

# Understanding the setup_project.tcl script
The setup_project.tcl file here has been configured for this project. 