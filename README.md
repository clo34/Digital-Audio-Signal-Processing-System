# Digital-Audio-Signal-Processing-System
Digital Audio Signal Processing System This project implements a hardware-based Digital Audio Signal Processing System designed to compute and output the amplitude of audio signals for left and right channels (lft_amp and rht_amp).

Features
Finite State Machine (FSM): Controls the system's workflow, channel selection, and update triggers.
Channel-Specific Accumulators: 18-bit accumulation registers (accumReg18) for left and right audio data.
Arithmetic Processing:
Scaling of accumulated values using a multiplier.
Precision adjustment with right-shifting.
Average computation for smoother signal output.
Absolute Value Conversion: Converts signed audio data to absolute values for uniformity.
Magnitude to Thermometric Conversion: Outputs magnitude data in thermometric representation.
Amplitude Registers: 9-bit registers (ampReg9) store the final processed amplitude for each channel.
Block Diagram

This block diagram shows the system’s architecture and signal flow. It processes audio signals (lft_aud and rht_aud) through various stages, including accumulation, averaging, and amplitude computation, under FSM control.

How It Works
The FSM validates the input audio signal (aud_vld) and determines whether to process the left or right channel using the sel_lft signal.
Selected audio channel data is accumulated and processed via:
Scaling, shifting, and averaging to calculate new amplitude values (new_avg).
The final amplitudes (lft_amp and rht_amp) are stored in the respective amplitude registers and updated as per FSM control.
Applications
Real-time audio signal processing.
Amplitude calculation for stereo audio systems.
Audio visualization and analysis.
Repository Structure
markdown
Copy code
/rtl
    - FSM.v
    - accumReg18.v
    - ampReg9.v
    - abs16from15.v
    - mag2therm.v
    - TopModule.v
/testbench
    - FSM_tb.v
    - accumReg18_tb.v
    - TopModule_tb.v
/docs
    - System_Architecture.pdf
    - diagram.png
Getting Started
Clone the Repository
bash
Copy code
git clone https://github.com/<your-username>/<repo-name>.git
Requirements
Quartus Prime or any Verilog-compatible hardware design tool.
ModelSim or Questasim for simulation.
Steps to Run
Open the project in your preferred Verilog design tool.
Simulate the testbenches in /testbench to verify the functionality of individual modules and the full system.
Synthesize the project in your FPGA toolchain.
Deploy the synthesized design on FPGA hardware for real-time operation.
Future Enhancements
Integration of additional audio processing features (e.g., noise reduction, equalization).
Multi-channel audio data support.
Optimization for resource-constrained FPGAs.
License
This project is licensed under the MIT License. See the LICENSE file for details.

Contributing
Contributions are welcome! Please fork the repository and submit a pull request.
