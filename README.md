# FIR_Filter
a simple low pass FIR filter for a heart rate made using VHDL

Filter designed using http://t-filter.engineerjs.com/

This filter was designed around the idea that a heart rate is generally measured using monitors with a low sampling frequency (in this case 60 Hz). As seen in image 1.1, the stop band attenuates all frequencies between 15 Hz and 30 Hz, and the pass band is set between 0 Hz and 10 Hz, this was chosen as the area of minimal signal distortion.

The frequency region over which the filter can be defined is from 0 Hz to 30 hz, this is according to Nyquist theorem as the sampling frequency is 60 Hz. If a larger or smaller sampling frequency is required then the passband and stopband of the filter must also be change to correctly adjust the filter. Note that changes to the ripple of the passband or attenuation of the stop band may have unwanted effects on the number of taps required in the filter and so may result in a more complex filter. Note also that adjusting the gap between the passband and stopband may also result in a more complex filter.

