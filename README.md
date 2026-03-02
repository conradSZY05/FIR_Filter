# FIR_Filter
a simple low pass parallel FIR filter for a heart rate made using VHDL, simulated in Vivado.
    
Filter designed using http://t-filter.engineerjs.com/
    
# Designing the filter
Anything above 40-50 Hz on a heartbeat signal (ECG) is mostly noise, so choosing a sampling frequency of 500 Hz, cutoff frequency of 40 Hz (passband) and stopband frequency of 50 Hz. The below image is generated with 53 coefficients 
    
    -25, -359, -454, -653, -805, -872, -816, -625, -318, 53, 409, 662, 736, 592, 243, -243, -745, -1115, -1211, -929, -233, 828, 2122, 3460, 4623, 5414, 5694, 5414, 4623, 3460, 2122, 828, -233, -929, -1211, -1115, -745, -243, 243, 592, 736, 662, 409, 53, -318, -625, -816, -872, -805, -653, -454, -359, -25
    
<img width="1584" height="877" alt="Screenshot 2026-03-01 140218" src="https://github.com/user-attachments/assets/0bb5b559-8b78-45f7-a55b-5970650e2904" />
    
# Testing the filter
## Impulse
Before writing a testbench for real signals, I'll use some known values such as an impulse. That is a single impulse "0000000000000001" for a clock cycle and then a "0000000000000000" input, which will just return my tap coefficients.
<img width="964" height="209" alt="Screenshot 2026-03-01 171641" src="https://github.com/user-attachments/assets/06b13f51-c923-4645-be23-c77b0ea3d394" />
What this shows, although correct, is the pipeline delay because of how the filter is implemented. The multiplication uses freshly shifted input values, but the accumulation occurs in another process i.e. reads in the next clock cycle. So the 0 signals between coefficients in the image above is a result of multiplication of 0 with the coefficients after the impulse shifts through. 

## DC
Since the implementation uses a pipeline, an input of just "0000000000000001" will result in the pipeline being filled for 55 clock cycles and settling to the sum of all coefficients which is 25172.
<img width="956" height="305" alt="Screenshot 2026-03-02 204252" src="https://github.com/user-attachments/assets/778a3797-8a4b-4bc2-9bb7-0fbfb487371d" />

## Square Wave
A square wave at a frequency well within the passband should result in an output that resembles a triangle or sine wave more or less. A square wave at a frequency above the cutoff frequency and in the stopband will result in high attenuation, so smaller amplitude and less visible oscillation.
### 20 Hz Square Wave
<img width="938" height="459" alt="Screenshot 2026-03-02 211409" src="https://github.com/user-attachments/assets/5dc701b5-5ba7-4db1-b2ee-36c8be308e2d" /><img width="954" height="482" alt="Screenshot 2026-03-02 211345" src="https://github.com/user-attachments/assets/88da7fb4-daef-4f98-8685-6b6929c27e1c" />


### 60 Hz Square Wave

