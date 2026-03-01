# FIR_Filter
a simple low pass FIR filter for a heart rate made using VHDL

Filter designed using http://t-filter.engineerjs.com/

Anything above 40-50 Hz on a heartbeat signal (ECG) is mostly noise, so choosing a sampling frequency of 500 Hz, cutoff frequency of 40 Hz (passband) and stopband frequency of 50 Hz. The below image is generated with 53 coefficients 


<img width="1584" height="877" alt="Screenshot 2026-03-01 140218" src="https://github.com/user-attachments/assets/0bb5b559-8b78-45f7-a55b-5970650e2904" />


Some issues that may need addressing:
- an output of 32 bits does not take into account that in the worst case, when you sum 15 16-bit values, a 32-bit register will overflow, so realistically the output should be more like 36-bits.
- the multiplying part and accumulating part of the FIR filter happen in two seperate processes, so the accumulator always works on the previous set of multiplications, ideally this should not happen but being aware that there is a 2 cycle latency is good enough for this project.

Considerations for improvements:
- right now this is written for Vivado, it could be used on an FPGA like the basys 3 as I originally intended but that requires extra hardware such as a DAC.
