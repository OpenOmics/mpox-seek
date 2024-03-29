<div align="center">
   
  <h1>mpox-seek 🔬</h1>
  
  **_Targeted ONT Pipeline for Monkeypox_**

  [![GitHub release (latest SemVer including pre-releases)](https://img.shields.io/github/v/release/OpenOmics/mpox-seek?color=blue&include_prereleases)](https://github.com/OpenOmics/mpox-seek/releases) [![tests](https://github.com/OpenOmics/mpox-seek/workflows/tests/badge.svg)](https://github.com/OpenOmics/mpox-seek/actions/workflows/main.yaml) [![docs](https://github.com/OpenOmics/mpox-seek/workflows/docs/badge.svg)](https://github.com/OpenOmics/mpox-seek/actions/workflows/docs.yml) [![GitHub issues](https://img.shields.io/github/issues/OpenOmics/mpox-seek?color=brightgreen)](https://github.com/OpenOmics/mpox-seek/issues)  [![GitHub license](https://img.shields.io/github/license/OpenOmics/mpox-seek)](https://github.com/OpenOmics/mpox-seek/blob/main/LICENSE) 
  
  <i>
    This is the home of the pipeline, mpox-seek. mpox-seek is a streamlined oxford nanopore pipeline for targeted monkeypox sequencing.
  </i>
</div>

## Overview
Welcome to mpox-seek! Before getting started, we highly recommend reading through [mpox-seek's documentation](https://openomics.github.io/mpox-seek/).

The **`./mpox-seek`** pipeline is composed several inter-related sub commands to setup and run the pipeline across different systems. Each of the available sub commands perform different functions: 

 * [<code>mpox-seek <b>run</b></code>](https://openomics.github.io/mpox-seek/usage/run/): Run the mpox-seek pipeline with your input files.
 * [<code>mpox-seek <b>unlock</b></code>](https://openomics.github.io/mpox-seek/usage/unlock/): Unlocks a previous runs output directory.
 * [<code>mpox-seek <b>install</b></code>](https://openomics.github.io/mpox-seek/usage/install/): Download reference files locally.
 * [<code>mpox-seek <b>cache</b></code>](https://openomics.github.io/mpox-seek/usage/cache/): Cache software containers locally.

**mpox-seek** is a streamlined viral metagenomics pipeline to align, collapse, and visualize targeted monekypox samples. It relies on technologies like [Singularity<sup>1</sup>](https://singularity.lbl.gov/) to maintain the highest-level of reproducibility. The pipeline consists of a series of data processing and quality-control steps orchestrated by [Snakemake<sup>2</sup>](https://snakemake.readthedocs.io/en/stable/), a flexible and scalable workflow management system, to submit jobs to a cluster.

The pipeline is compatible with data generated from [Nanopore sequencing technologies](https://nanoporetech.com/). As input, it accepts a set of FastQ files and can be run locally on a compute instance or on-premise using a cluster. A user can define the method or mode of execution. The pipeline can submit jobs to a cluster using a job scheduler like SLURM (more coming soon!). A hybrid approach ensures the pipeline is accessible to all users.

Before getting started, we highly recommend reading through the [usage](https://openomics.github.io/mpox-seek/usage/run/) section of each available sub command.

For more information about issues or trouble-shooting a problem, please checkout our [FAQ](https://openomics.github.io/mpox-seek/faq/questions/) prior to [opening an issue on Github](https://github.com/OpenOmics/mpox-seek/issues).

## Dependencies
**Requires:** `singularity>=3.5`  `snakemake<8.0`  `conda/mamba (optional)` 

[Snakemake](https://snakemake.readthedocs.io/en/stable/getting_started/installation.html) must be installed on the target system. Snakemake is a workflow manager that orchestrates each step of the pipeline. The second dependency, i.e [singularity](https://singularity.lbl.gov/all-releases) OR [conda/mamba](https://github.com/conda-forge/miniforge#mambaforge), handles the dowloading/installation of any remaining software dependencies. By default, the pipeline will utilize singularity to guarantee the highest level of reproducibility; however, the `--use-conda` option of the [run](https://openomics.github.io/mpox-seek/usage/run/) sub command can be provided to  use conda/mamba instead of singularity. If possible, we recommend using singularity over conda for reproducibility; however, it is worth noting that singularity and conda produce identical results for this pipeline. 

If you are running the pipeline on Windows, please use the [Windows Subsystem for Linux (WSL)](https://learn.microsoft.com/en-us/windows/wsl/install). Singularity can be installed on WSL following these [instructions](https://www.blopig.com/blog/2021/09/using-singularity-on-windows-with-wsl2/).

## Installation
Please clone this repository to your local filesystem using the following command:
```bash
# Clone Repository from Github
git clone https://github.com/OpenOmics/mpox-seek.git
# Change your working directory
cd mpox-seek/
# Add dependencies to $PATH
# Biowulf users should run
module load snakemake singularity
# Get usage information
./mpox-seek -h
```

For more detailed installation instructions, please see our [setup page](https://openomics.github.io/mpox-seek/setup/).

## Contribute 
This site is a living document, created for and by members like you. mpox-seek is maintained by the members of OpenOmics and is improved by continous feedback! We encourage you to contribute new content and make improvements to existing content via pull request to our [GitHub repository](https://github.com/OpenOmics/mpox-seek).

## References
<sup>**1.**  Kurtzer GM, Sochat V, Bauer MW (2017). Singularity: Scientific containers for mobility of compute. PLoS ONE 12(5): e0177459.</sup>  
<sup>**2.**  Koster, J. and S. Rahmann (2018). "Snakemake-a scalable bioinformatics workflow engine." Bioinformatics 34(20): 3600.</sup>  
