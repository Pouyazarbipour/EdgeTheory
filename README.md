# EdgeTheory - Wave Simulation GUI

EdgeTheory is a MATLAB-based graphical user interface (GUI) for simulating wave propagation over sloping bathymetry. This tool is designed for researchers, students, and engineers interested in coastal and marine applications.

## Features
- Simulate wave profiles for up to three modes with decay factors based on seabed slope.
- Interactive GUI with user-defined input parameters:
  - **Wave Period (T)**: Time period of the waves (in seconds).
  - **Mean Slope**: Average slope of the seabed.
  - **Max Offshore Distance**: The farthest distance for the simulation.
- Real-time animated visualization of wave propagation.
- Simple and intuitive interface for easy use.

## Requirements
- MATLAB (R2017a or later is recommended).
- No additional toolboxes required.

## Installation
1. Clone or download the repository:
   ```bash
   git clone https://github.com/pouyazarbipour/EdgeTheory.git
   ```
2. Open MATLAB and navigate to the downloaded folder.
3. Open `EdgeTheory.m` in MATLAB and run the script.

## Usage
1. Run the `EdgeTheory` function in MATLAB to launch the GUI.
2. Enter the following parameters:
   - **Wave Period (sec)**: Default is `3.0`.
   - **Mean Slope**: Default is `0.1`.
   - **Max Offshore Distance (m)**: Default is `5.0`.
3. Click the **Calculate** button to start the wave simulation.
4. Observe the animated wave profiles on the graph. Each mode is represented by a unique color.
5. Click **Stop** to halt the animation at any time.

## File Structure
- `EdgeTheory.m`: Main script containing the GUI and simulation logic.
- Helper functions:
  - `generateBathymetry`: Creates the seabed profile based on slope and distance.
  - `initializeWave`: Initializes wave properties, including decay factors and modes.

## Example
To simulate waves with a period of 5 seconds, a slope of 0.15, and a maximum offshore distance of 10 meters:
1. Set the inputs:
   - Wave Period: `5.0`
   - Mean Slope: `0.15`
   - Max Offshore Distance: `10.0`
2. Click **Calculate** to view the animated wave modes.

---

## License  
This project is licensed under the MIT License. See the `LICENSE` file for details.  

---

## Contact  
For questions or feedback, please reach out to pouyazarbipour@gmail.com.

Enjoy using the **EdgeTheory** to explore and analyze coastal engineering scenarios!
