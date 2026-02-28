# FIR_Filter
a simple low pass FIR filter for a heart rate made using VHDL

Filter designed using http://t-filter.engineerjs.com/

This filter was designed around the idea that a heart rate is generally measured using monitors with a low sampling frequency (in this case 60 Hz). As seen in image 1.1, the stop band attenuates all frequencies between 15 Hz and 30 Hz, and the pass band is set between 0 Hz and 10 Hz, this was chosen as the area of minimal signal distortion.

The frequency region over which the filter can be defined is from 0 Hz to 30 hz, this is according to Nyquist theorem as the sampling frequency is 60 Hz. If a larger or smaller sampling frequency is required then the passband and stopband of the filter must also be change to correctly adjust the filter. Changes to the ripple of the passband or attenuation of the stop band may have unwanted effects on the number of taps required in the filter and so may result in a more complex filter. Adjusting the gap between the passband and stopband may also result in a more complex filter.

The resulting design is a low pass filter with 15 taps, sampling frequency 60 Hz, passband frequency 10 Hz, stopband frequency 15 Hz, and coefficients generated below.

    385
    20
    -1528
    -3156
    -2089
    3079
    9729
    12809
    9729
    3079
    -2089
    -3156
    -1528
    20
    385

image 1.1
![Screenshot 2026-02-26 170715](https://github.com/user-attachments/assets/b13553aa-e144-479b-bb43-dcf9621d4ce5)

For this filter I will need two test waves, one that should get filtered (5 Hz) and one that does not (20 Hz). I will generate the values for these using the MATLAB code below.
            
    fs = 60; % sampling frequency
    numSamples = 256;
    amplitude = 16383; % (2^15 / 2)

    % test frequencies
    f_pass = 5;
    f_stop = 20;

    t = (0:numSamples-1);

    samples_pass = round(sin(2*pi*f_pass/fs * t) * amplitude);
    samples_stop = round(sin(2*pi*f_stop/fs * t) * amplitude);

    print_array('SINE_PASS', samples_pass);
    print_array('SINE_STOP', samples_stop);

    function print_array(name, samples)
        numSamples = length(samples);
        fprintf('const %s : sine_array_t := (\n', name);
        for i = 1:numSamples
            if i < numSamples
                fprintf('   %d,\n', samples(i));
            else
                fprintf('   %d\n', samples(i)); % no comma on last sample
            end
        end
        fprintf(');\n\n');
    end
    % print waves
    figure;
    subplot(2,1,1);
    plot(t, samples_pass);
    title('5 Hz - passband');
    xlabel('sample'); ylabel('amplitude');

    subplot(2,1,2);
    plot(t, samples_stop);
    title('20 Hz - stopband');
    xlabel('sample'); ylabel('amplitude');
These waves will be used as tests in the testbench.
<img width="869" height="563" alt="Screenshot 2026-02-28 160112" src="https://github.com/user-attachments/assets/5615d062-7f8e-4e92-b3b8-891631896001" />



Some issues that may need addressing:
- an output of 32 bits does not take into account that in the worst case, when you sum 15 16-bit values, a 32-bit register will overflow, so realistically the output should be more like 36-bits.
- the multiplying part and accumulating part of the FIR filter happen in two seperate processes, so the accumulator always works on the previous set of multiplications, ideally this should not happen but being aware that there is a 2 cycle latency is good enough for this project.

Considerations for improvements:
- right now this is written for Vivado, it could be used on an FPGA like the basys 3 as I originally intended but that requires extra hardware such as a DAC.
