# Verilog Signed Multiplier using Booth Encoding
![Verilog](https://img.shields.io/badge/Verilog-FFFFFF?style=for-the-badge&color=FFBF00)
![ModelSim](https://img.shields.io/badge/ModelSim-white?style=for-the-badge&color=428475)
![RTL](https://img.shields.io/badge/RTL-white?style=for-the-badge&color=FF6A1C)
![Digital Design](https://img.shields.io/badge/Digital%20Design-white?style=for-the-badge&color=4647AE)

A compact, fully synthesizable signed multiplier built around **Booth's Algorithm**. All functional verification was performed in **ModelSim**. The testbench feeds the multiplier a sweep of signed inputs -positive and negative edge cases, and random pairs- and compares each result against a behavioral golden model.

<p align="center">
  <img src="https://github.com/user-attachments/assets/580d7fb5-59a9-4b64-a6e5-c66aff2cd11d"
       alt="WF"
       width="950" />
   <br>
   <sub>Figure 1 — A Screen Shot of ModelSim Waveform Outputs</sub>
</p>

Rather than generating a partial product for every bit of the multiplier, this algorithm re-encodes groups of bits to drastically cut down the number of additions—making the hardware path both smaller and faster.

<p align="center">
  <img src="https://github.com/user-attachments/assets/381ed015-0e39-4f66-a33e-dfbe13e98c20"
       alt="Booth 1"
       width="450" />
   <br>
   <sub>Figure 2 — Booth Algorithm (<a href="https://digitalsystemdesign.in/booths-multiplication-algorithm/">source</a>)</sub>
</p>

<p align="center">
  <img src="https://github.com/user-attachments/assets/ae65caf7-de21-4c03-8806-e927e877b7e5"
       alt="Booth 2"
       width="450" />
   <br>
   <sub>Figure 3 — Booth Algorithm (<a href="https://digitalsystemdesign.in/booths-multiplication-algorithm/">source</a>)</sub>
</p>

