# Systolic Array
This is design of an 8x8 systolic array to perform matric multiplication using the output stationary dataflow.<br/>
The testbench code in the file, ‘./testbenches/systolic_array_tb.v’ has the code to read two 8x8 matrices from the files, input.txt and weight.txt. It also has an instantiation of the systolic array module.<br/>
Once systolic array is done computing the output matrix, the ‘compute_done’ signal is driven high.<br/>
This design was synthesized using the Nangate 15nm Free PDK library and a target of 1GHz was set:<br/>
Power: 9.15 mW<br/>
Area: 12006.506609 um2
