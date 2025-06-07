<a id="readme-top"></a>

[![Contributors][contributors-shield]][contributors-url]
[![Forks][forks-shield]][forks-url]
[![Stargazers][stars-shield]][stars-url]
[![Issues][issues-shield]][issues-url]
[![Unlicense License][license-shield]][license-url]
[![LinkedIn][linkedin-shield]][linkedin-url]


<!-- TABLE OF CONTENTS -->
<details>
  <summary>Table of Contents</summary>
  <ol>
    <li>
      <a href="#about-the-project">About The Project</a>
	  <ul>
        <li><a href="#key-features">Key Features</a></li>
		<li><a href="#project-components">Project Components</a></li>
		<li><a href="#project-architecture">Project Architecture</a></li>
      </ul>
    </li>
    <li>
      <a href="#getting-started">Getting Started</a>
      <ul>
        <li><a href="#prerequisites">Prerequisites</a></li>
        <li><a href="#installation">Installation</a></li>
      </ul>
    </li>
    <li><a href="#how-to-run">How to run</a></li>
    <li><a href="#achievement">Achievement</a></li>
    <li><a href="#contributing">Contributing</a></li>
    <li><a href="#contact">Contact</a></li>
  </ol>
</details>

<!-- ABOUT THE PROJECT -->
## About The Project

This project features a UVM-based verification environment for a 1x3 Router implemented in Verilog. The router routes packets from a single source to one of three destination channels based on a 2-bit address in the packet header. The verification environment uses the Universal Verification Methodology (UVM) to ensure comprehensive functional verification, including packet generation, monitoring, and coverage analysis.

* RTL block diagram of Router 1x3

![RTL_block](https://github.com/so1taynguyen/Router-1x3-UVM-Verification-IP/blob/main/images/RTL_block_diagram.png)

![RTL](https://github.com/so1taynguyen/Router-1x3-UVM-Verification-IP/blob/main/images/RTL.png)

<p align="right">(<a href="#readme-top">Back to top</a>)</p>

### Key Features

* __1x3 Router Core__: A Verilog implementation of a 1x3 router that routes 8-bit packets from one input to one of three output channels based on the lower 2 bits of the packet header.
* __UVM Verification Environment__: A complete UVM testbench with a driver, monitor, sequencer, agent, scoreboard, and environment to verify router functionality.
* __Randomized Packet Generation__: The [router_trans](https://github.com/so1taynguyen/Router-1x3-UVM-Verification-IP/blob/main/agt_top/router_trans.sv) class generates random packets with valid headers (address != 2'b11) and payloads, ensuring thorough testing.that parses assembly code, handles labels, validates syntax, and generates 32-bit hexadecimal machine code. It also supports error checking for invalid register usage and instruction formats.
* __Scoreboard__: Compares source and destination packets, checking for data integrity and correct routing, with detailed reporting of matches, mismatches, and port errors.
* __Functional Coverage__: A covergroup in the scoreboard tracks data values, destination ports, and payload sizes to ensure comprehensive verification.

<p align="right">(<a href="#readme-top">Back to top</a>)</p>

### Project Components

#### Verilog Modules

* [__router_top.v__](https://github.com/so1taynguyen/Router-1x3-UVM-Verification-IP/blob/main/rtl/router_top.v): Top-level module integrating the router's FIFO, FSM, synchronizer, and register modules.
* [__router_fifo.v__](https://github.com/so1taynguyen/Router-1x3-UVM-Verification-IP/blob/main/rtl/router_fifo.v): Implements a 16-entry FIFO for each output channel, handling packet storage and retrieval.
* [__router_fsm.v__](https://github.com/so1taynguyen/Router-1x3-UVM-Verification-IP/blob/main/rtl/router_fsm.v): Finite state machine controlling packet routing and state transitions (e.g., DECODE_ADDRESS, LOAD_DATA).
* [__router_sync.v__](https://github.com/so1taynguyen/Router-1x3-UVM-Verification-IP/blob/main/rtl/router_sync.v): Synchronizes control signals and manages FIFO full/empty states and soft resets.
* [__router_reg.v__](https://github.com/so1taynguyen/Router-1x3-UVM-Verification-IP/blob/main/rtl/router_reg.v): Handles packet registration, parity calculation, and error detection.

#### UVM Testbench

* [__router_pkg.sv__](https://github.com/so1taynguyen/Router-1x3-UVM-Verification-IP/blob/main/packages/router_pkg.sv): UVM package importing all verification components.
* [__router_trans.sv__](https://github.com/so1taynguyen/Router-1x3-UVM-Verification-IP/blob/main/agt_top/router_trans.sv): Defines the transaction class for packet generation with constraints and post-randomization logic.
* [__router_env_config.sv__](https://github.com/so1taynguyen/Router-1x3-UVM-Verification-IP/blob/main/env/router_env_config.sv): Configures the environment with settings for agent and scoreboard.
* [__router_drv.sv__](https://github.com/so1taynguyen/Router-1x3-UVM-Verification-IP/blob/main/agt_top/router_drv.sv): Drives packets to the DUT using the interface.
* [__router_mon.sv__](https://github.com/so1taynguyen/Router-1x3-UVM-Verification-IP/blob/main/agt_top/router_mon.sv): Monitors input and output packets, sending data to the scoreboard.
* [__router_sequencer.sv__](https://github.com/so1taynguyen/Router-1x3-UVM-Verification-IP/blob/main/agt_top/router_sequencer.sv): Manages sequence item generation.
* [__router_agent.sv__](https://github.com/so1taynguyen/Router-1x3-UVM-Verification-IP/blob/main/agt_top/router_agent.sv): Integrates driver, monitor, and sequencer.
* [__router_scoreboard.sv__](https://github.com/so1taynguyen/Router-1x3-UVM-Verification-IP/blob/main/env/router_scoreboard.sv): Compares source and destination data, tracks coverage, and reports results.
* [__router_env.sv__](https://github.com/so1taynguyen/Router-1x3-UVM-Verification-IP/blob/main/env/router_env.sv): Top-level environment connecting agent and scoreboard.
* [__router_seqs.sv__](https://github.com/so1taynguyen/Router-1x3-UVM-Verification-IP/blob/main/test/router_seqs.sv): Generates a sequence of 30 randomized packets.
* [__router_test_lib.sv__](https://github.com/so1taynguyen/Router-1x3-UVM-Verification-IP/blob/main/test/router_test_lib.sv): Defines base and extended test classes.
* [__top.sv__](https://github.com/so1taynguyen/Router-1x3-UVM-Verification-IP/blob/main/tb/top.sv): Top-level testbench connecting the DUT and UVM environment.

#### Interface

* [__router_if.sv__](https://github.com/so1taynguyen/Router-1x3-UVM-Verification-IP/blob/main/rtl/router_if.sv): Defines the interface with clocking blocks and assertions for signal validation.

<p align="right">(<a href="#readme-top">Back to top</a>)</p>

### Project Architecture

![Top_architect](https://github.com/so1taynguyen/Router-1x3-UVM-Verification-IP/blob/main/images/Router_UVM.png) 

<p align="right">(<a href="#readme-top">Back to top</a>)</p>

<!-- GETTING STARTED -->
## Getting Started

To set up and run the Router 1x3 UVM Verification IP project locally, install the required tools and follow the steps below.

### Prerequisites

The following tools are required to simulate the router and verify its functionality:

* __UVM Library__: Requires a UVM-compliant simulator with UVM 1.2 or later.
* __Verilog Simulation Tool__: At least one of the following:
   * Cadence Xcelium Logic Simulator: Commercial tool, requires a license. Contact Cadence for installation details.
   * Siemens QuestaSim: Commercial tool, requires a license. Refer to Siemens documentation for setup.
   * Synopsys VCS: Commercial tool, requires a license. Refer to Synopsys documentation for setup.

### Installation

1. Clone the repo.
   ```sh
   git clone https://github.com/so1taynguyen/Router-1x3-UVM-Verification-IP.git
   cd Router-1x3-UVM-Verification-IP
   ```
2. Ensure the SystemVerilog simulation tool, UVM package and waveform viewer are installed and in your PATH.
3. Change the Git remote URL to avoid accidental pushes to the original repository.
   ```sh
   git remote set-url origin https://github.com/your_username/your_repo.git
   git remote -v # Confirm the changes
   ```

<p align="right">(<a href="#readme-top">Back to top</a>)</p>

<!-- USAGE EXAMPLES -->
## How to run

Follow these steps to simulate the Router 1x3 and verify its functionality:

1. Ensure all Verilog and UVM files are in the correct directories.
2. Run the simulation through Makefile using make all command.
      ```sh
      cd sim
      make all
      ```
3. Check simulation results and waveform.

<p align="right">(<a href="#readme-top">Back to top</a>)</p>

<!-- ROADMAP -->
## Achievement

* __Functional Verification__: The UVM testbench successfully verifies the router's functionality, ensuring packets are correctly routed to the intended destination based on the header address.

* __Coverage Analysis__: The covergroup ensures adequate testing of data values, destination ports, and payload sizes, achieving high functional coverage.

* __Log file result__:

![log](https://github.com/so1taynguyen/Router-1x3-UVM-Verification-IP/blob/main/images/logs.png)

* __Waveform result__:

![wave](https://github.com/so1taynguyen/Router-1x3-UVM-Verification-IP/blob/main/images/waveform.png)

* __Functional Coverage result__:

![coverage](https://github.com/so1taynguyen/Router-1x3-UVM-Verification-IP/blob/main/images/coverage.png)

<p align="right">(<a href="#readme-top">Back to top</a>)</p>

<!-- CONTRIBUTING -->
## Contributing

Contributions are welcome to enhance the project. Suggestions include optimizing the assembler, adding new instructions, or improving simulation scripts.

1. Fork the project
2. Create a feature branch
    ```sh
    git checkout -b feature/YourFeatureName
    ```
3. Commit your changes
    ```sh
    git commit -m "Add YourFeatureName"
    ```
4. Push to the branch
    ```sh
    git push origin feature/YourFeatureName
    ```
4. Open a pull request

<p align="right">(<a href="#readme-top">Back to top</a>)</p>

<!-- CONTACT -->
## Contact

[![Instagram](https://img.shields.io/badge/Instagram-%23E4405F.svg?logo=Instagram&logoColor=white)](https://www.instagram.com/_2imlinkk/) [![LinkedIn](https://img.shields.io/badge/LinkedIn-%230077B5.svg?logo=linkedin&logoColor=white)](https://www.linkedin.com/in/linkk-isme/) [![email](https://img.shields.io/badge/Email-D14836?logo=gmail&logoColor=white)](mailto:nguyenvanlinh0702.1922@gmail.com) 

<p align="right">(<a href="#readme-top">Back to top</a>)</p>

<!-- MARKDOWN LINKS & IMAGES -->
<!-- https://www.markdownguide.org/basic-syntax/#reference-style-links -->
[contributors-shield]: https://img.shields.io/github/contributors/othneildrew/Best-README-Template.svg?style=for-the-badge
[contributors-url]: https://github.com/so1taynguyen/Router-1x3-UVM-Verification-IP/graphs/contributors
[forks-shield]: https://img.shields.io/github/forks/so1taynguyen/Simple-MIPS32-Hardware-Implementation-with-Python-Assembler.svg?style=for-the-badge
[forks-url]: https://github.com/so1taynguyen/Router-1x3-UVM-Verification-IP/network/members
[stars-shield]: https://img.shields.io/github/stars/so1taynguyen/Simple-MIPS32-Hardware-Implementation-with-Python-Assembler.svg?style=for-the-badge
[stars-url]: https://github.com/so1taynguyen/Router-1x3-UVM-Verification-IP/stargazers
[issues-shield]: https://img.shields.io/github/issues/so1taynguyen/Simple-MIPS32-Hardware-Implementation-with-Python-Assembler.svg?style=for-the-badge
[issues-url]: https://github.com/so1taynguyen/Router-1x3-UVM-Verification-IP/issues
[license-shield]: https://img.shields.io/github/license/so1taynguyen/Simple-MIPS32-Hardware-Implementation-with-Python-Assembler.svg?style=for-the-badge
[license-url]: https://github.com/so1taynguyen/Router-1x3-UVM-Verification-IP/blob/main/LICENSE
[linkedin-shield]: https://img.shields.io/badge/-LinkedIn-black.svg?style=for-the-badge&logo=linkedin&colorB=555
[linkedin-url]: https://www.linkedin.com/in/linkk-isme/
