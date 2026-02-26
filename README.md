# FIR_Filter
a simple low pass FIR filter for a heart rate made using VHDL

Filter designed using http://t-filter.engineerjs.com/

This filter was designed around the idea that a heart rate is generally measured using monitors with a low sampling frequency (in this case 60 Hz). As seen in image 1.1, the stop band attenuates all frequencies between 15 Hz and 30 Hz, and the pass band is set between 0 Hz and 10 Hz, this was chosen as the area of minimal signal distortion.

The frequency region over which the filter can be defined is from 0 Hz to 30 hz, this is according to Nyquist theorem as the sampling frequency is 60 Hz. If a larger or smaller sampling frequency is required then the passband and stopband of the filter must also be change to correctly adjust the filter. Note that changes to the ripple of the passband or attenuation of the stop band may have unwanted effects on the number of taps required in the filter and so may result in a more complex filter. Note also that adjusting the gap between the passband and stopband may also result in a more complex filter.

The resulting design is a low pass filter with 15 taps, sampling frequency 60 Hz, passband frequency 10 Hz, stopband frequency 15 Hz, and coefficients generated below.


    0.011762664953569835
    0.0006065719670822352
    -0.04663514522505109
    -0.09630716635633031
    -0.06375317701636816
    0.09396217337929874
    0.29692016726804943
    0.39090884269286097
    0.29692016726804943
    0.09396217337929874
    -0.06375317701636816
    -0.09630716635633031
    -0.04663514522505109
    0.0006065719670822352
    0.011762664953569835


image 1.1
![Screenshot 2026-02-26 170715](https://github.com/user-attachments/assets/b13553aa-e144-479b-bb43-dcf9621d4ce5)


