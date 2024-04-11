<div align="center">

  <h1 style="font-size: 250%">mpox-seek 🔬</h1>

  <b><i>Targeted ONT Pipeline for Monkeypox</i></b><br> 
  <a href="https://doi.org/10.5281/zenodo.10957607">
    <img src="https://zenodo.org/badge/DOI/10.5281/zenodo.10957607.svg" alt="DOI">
  </a>
  <a href="https://github.com/OpenOmics/mpox-seek/releases">
    <img alt="GitHub release" src="https://img.shields.io/github/v/release/OpenOmics/mpox-seek?color=blue&include_prereleases">
  </a>
  <a href="https://hub.docker.com/repository/docker/skchronicles/mpox-seek">
    <img alt="Docker Pulls" src="https://img.shields.io/docker/pulls/skchronicles/mpox-seek">
  </a><br>
  <a href="https://github.com/OpenOmics/mpox-seek/actions/workflows/main.yaml">
    <img alt="tests" src="https://github.com/OpenOmics/mpox-seek/workflows/tests/badge.svg">
  </a>
  <a href="https://github.com/OpenOmics/mpox-seek/actions/workflows/docs.yml">
    <img alt="docs" src="https://github.com/OpenOmics/mpox-seek/workflows/docs/badge.svg">
  </a>
  <a href="https://github.com/OpenOmics/mpox-seek/issues">
    <img alt="GitHub issues" src="https://img.shields.io/github/issues/OpenOmics/mpox-seek?color=brightgreen">
  </a>
  <a href="https://github.com/OpenOmics/mpox-seek/blob/main/LICENSE">
    <img alt="GitHub license" src="https://img.shields.io/github/license/OpenOmics/mpox-seek">
  </a>

  <p>
    mpox-seek is an awesome, portable and fast oxford nanopore pipeline for targeted monkeypox sequencing.
  </p>

</div>  

## Overview
Welcome to mpox-seek's documentation! This guide is the main source of documentation for users that are getting started with the [Monkeypox Nanopore Pipeline](https://github.com/OpenOmics/mpox-seek/). 

The **`./mpox-seek`** pipeline is composed several inter-related sub commands to setup and run the pipeline across different systems. Each of the available sub commands perform different functions: 

<section align="center" markdown="1" style="display: flex; flex-wrap: row wrap; justify-content: space-around;">

!!! inline custom-grid-button ""

    [<code style="font-size: 1em;">mpox-seek <b>run</b></code>](usage/run.md)   
    Run the mpox-seek pipeline with your input files.

!!! inline custom-grid-button ""

    [<code style="font-size: 1em;">mpox-seek <b>unlock</b></code>](usage/unlock.md)  
    Unlocks a previous runs output directory.

</section>

<section align="center" markdown="1" style="display: flex; flex-wrap: row wrap; justify-content: space-around;">


!!! inline custom-grid-button ""

    [<code style="font-size: 1em;">mpox-seek <b>install</b></code>](usage/install.md)  
    Download remote reference files locally.


!!! inline custom-grid-button ""

    [<code style="font-size: 1em;">mpox-seek <b>cache</b></code>](usage/cache.md)  
    Cache remote software containers locally.  

</section>

**mpox-seek** is a streamlined viral metagenomics pipeline to align, collapse, and visualize targeted monekypox samples. It relies on technologies like [Singularity<sup>1</sup>](https://singularity.lbl.gov/) to maintain the highest-level of reproducibility. The pipeline consists of a series of data processing and quality-control steps orchestrated by [Snakemake<sup>2</sup>](https://snakemake.readthedocs.io/en/stable/), a flexible and scalable workflow management system, to submit jobs to a cluster. By default, the pipeline will utilize singularity to guarantee the highest level of reproducibility; however, the `--use-conda` option of the [run](usage/run.md) sub command can be provided to  use conda/mamba instead of singularity. If possible, we recommend using singularity over conda for reproducibility; however, it is worth noting that singularity and conda produce identical results for this pipeline. If you plan on running this pipeline on a laptop or desktop computer, we recommend using conda/mamba over singularity.

The pipeline is compatible with data generated from [Oxford Nanopore sequencing Technologies](https://nanoporetech.com/). As input, it accepts a set of gzipped FastQ files (already basecalled) and can be run locally on a compute instance or on-premise using a cluster. A user can define the method or mode of execution. The pipeline can submit jobs to a cluster using a job scheduler like SLURM (more coming soon!). A hybrid approach ensures the pipeline is accessible to all users.

Before getting started, we highly recommend reading through the [usage](usage/run.md) section of each available sub command.

For more information about issues or trouble-shooting a problem, please checkout our [FAQ](faq/questions.md) prior to [opening an issue on Github](https://github.com/OpenOmics/mpox-seek/issues).

## Contribute 

This site is a living document, created for and by members like you. mpox-seek is maintained by the members of OpenOmics and is improved by continous feedback! We encourage you to contribute new content and make improvements to existing content via pull request to our [GitHub repository :octicons-heart-fill-24:{ .heart }](https://github.com/OpenOmics/mpox-seek).

## Citation

If you use this software, please cite it as below:  

=== "BibTex"

    ```
    @software{Kuhn_OpenOmics_mpox-seek_2024,
      author       = {Skyler Kuhn and Schaughency, Paul},
      title        = {OpenOmics/mpox-seek: v0.1.0},
      month        = apr,
      year         = 2024,
      publisher    = {Zenodo},
      version      = {v0.1.0},
      doi          = {10.5281/zenodo.10957607},
      url          = {https://doi.org/10.5281/zenodo.10957607}
    }
    ```

=== "APA"

    ```
    Skyler Kuhn, & Schaughency, P. (2024). OpenOmics/mpox-seek: v0.1.0 (v0.1.0). Zenodo. https://doi.org/10.5281/zenodo.10957607
    ```

For more citation style options, please visit the pipeline's [Zenodo page](https://doi.org/10.5281/zenodo.10957607).

## References

<sup>**1.**  Kurtzer GM, Sochat V, Bauer MW (2017). Singularity: Scientific containers for mobility of compute. PLoS ONE 12(5): e0177459.</sup>  
<sup>**2.**  Koster, J. and S. Rahmann (2018). "Snakemake-a scalable bioinformatics workflow engine." Bioinformatics 34(20): 3600.</sup>  
