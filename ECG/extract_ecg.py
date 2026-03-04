import wfdb
import numpy as np

# Configuration
RECORD_NAME = '09541_hr'
OUTPUT_FILE = 'ecg_data.txt'
LEAD_TO_EXTRACT = 0  # 0 = Lead I, 1 = Lead II, etc. (PTB-XL has 12 leads)
NUM_SAMPLES = 2000  # How many samples to extract (2000 = 4 seconds at 500 Hz)

# Read the WFDB record
print(f"Reading {RECORD_NAME}...")
record = wfdb.rdrecord(RECORD_NAME)

# Extract the specified lead
ecg_signal = record.p_signal[:NUM_SAMPLES, LEAD_TO_EXTRACT]

# Scale to 16-bit signed integer range
# PTB-XL data is in millivolts, we need to scale appropriately
# Find the range and scale to fit in 16-bit (-32768 to 32767)
signal_min = np.min(ecg_signal)
signal_max = np.max(ecg_signal)
signal_range = signal_max - signal_min

if signal_range > 0:
    # Scale to use most of 16-bit range (leave some headroom)
    scale_factor = 30000 / signal_range  # Use 30000 instead of 32767 for headroom
    ecg_scaled = ((ecg_signal - signal_min) * scale_factor - 15000).astype(np.int16)
else:
    ecg_scaled = np.zeros(NUM_SAMPLES, dtype=np.int16)

# Write to text file (one sample per line)
print(f"Writing {len(ecg_scaled)} samples to {OUTPUT_FILE}...")
with open(OUTPUT_FILE, 'w') as f:
    for sample in ecg_scaled:
        f.write(f"{sample}\n")

print(f"Done! Created {OUTPUT_FILE}")
print(f"Sample range: {np.min(ecg_scaled)} to {np.max(ecg_scaled)}")
print(f"Mean: {np.mean(ecg_scaled):.1f}")