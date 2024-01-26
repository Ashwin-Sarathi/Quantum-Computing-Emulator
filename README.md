# Quantum-Computing-Emulator
Implementation of a nearly fully functional quantum emulator with complex values, with qubits ranging from 2 to 4.

This project was a part of course ECE 564 at NC State Univerity under Dr. Paul Franzon and the course dealt with FPGA and ASIC Design with Verilog.

To emulate a matrix multiplier needed for quantum computations, this project used a 2 MAC + Adder architecture. 

The result folder holds the output and runtime information of all the test runs the project underwent.
The synth folder contains all the constraints given to synthesis and the logs from the synthesis process.
The folder v contains the code for the dut, the testbench and the sram that was modeled to feed information to the dut.
