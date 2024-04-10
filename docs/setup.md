## Dependencies

!!! note inline end "Requirements"
    **Using Singularity**: `singularity>=3.5`  `snakemake<8.0`  

    **Using Conda or Mamba**: `conda/mamba`  `snakemake<8.0`  

[Snakemake](https://snakemake.readthedocs.io/en/stable/getting_started/installation.html) must be installed on the target system. Snakemake is a workflow manager that orchestrates each step of the pipeline. The second dependency, i.e [singularity](https://singularity.lbl.gov/all-releases) OR [conda/mamba](https://github.com/conda-forge/miniforge#mambaforge), handles the dowloading/installation of any remaining software dependencies. 

By default, the pipeline will utilize singularity; however, the `--use-conda` option of the [run](usage/run.md) sub command can be provided to  use conda/mamba instead of singularity. If possible, we recommend using singularity over conda for reproducibility; however, it is worth noting that singularity and conda produce identical results for this pipeline. 

If you are running the pipeline on Windows, please use the [Windows Subsystem for Linux (WSL)](https://learn.microsoft.com/en-us/windows/wsl/install). Singularity can be installed on WSL following these [instructions](https://www.blopig.com/blog/2021/09/using-singularity-on-windows-with-wsl2/). With that being said, we recommend using conda/mamba over singularity. It is easier to setup and install via using WSL on Windows. Please see the instructions below to install conda/mamba on your system.

You can check to see if mpox-seek's software requirements are met by running:
```bash
# Check if dependencies 
# are already installed 
which snakemake || echo 'Error: snakemake is not install.'
which singularity \
  || which conda \
  || which mamba \
  || echo 'Error: singularity or conda or mamba are not installed.'

# Install conda/mamba if missing.
# Create directory to install 
# everything in $HOME/pipelines.
mkdir -p "${HOME:-~}/pipelines/conda"
cd "${HOME:-~}/pipelines/conda"
# Download the installer for
# miniforge and install conda.
curl -L -O "https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-$(uname)-$(uname -m).sh"
# Installs conda, a prompt will
# appear, hit ENTER, type yes a 
# few times, and then enter no 
# when it asks to initialize 
# your shell/startup
bash "Miniforge3-$(uname)-$(uname -m).sh" -f -p $PWD

# Start up the conda environment,
# if conda/mamba are not installed
# follow the instructions above.
source "${HOME:-~}/pipelines/conda/etc/profile.d/conda.sh" || echo 'Error: conda/mamba is not installed!'
# Install snakemake if missing.
# Create environment with snakemake/7.32.3
mamba create -y -c conda-forge -c bioconda -n snakemake snakemake=7.32.3
```


## Installation

Please ensure the software dependencies listed above are satisfied before getting started with this section. Also, please ensure each of the software dependencies listed above are in your `$PATH`. You can re-run the same command above to ensure each of the required dependencies are in your `$PATH`.

You can install mpox-seek locally with the following command:
```bash
# Clone mpox-seek from Github
mkdir -p "${HOME:-~}/pipelines/mpox-seek"
git clone https://github.com/OpenOmics/mpox-seek.git "${HOME:-~}/pipelines/mpox-seek"
# Change your working directory
cd mpox-seek/
# Get usage information
./mpox-seek -h
# Create an conda enviroment for mpox-seek
mamba env create -y --name mpox-seek --file=workflow/envs/mpox.yaml
```

## Offline mode

The `mpox-seek` pipeline can be run in an offline mode where external requests are not made at runtime. This will cache and download and remote resources or software containers (if using singlarity). Please note that if you are running the pipeline on Biowulf, you do NOT need to run these next steps. These instructions are for users running the pipeline outside of Biowulf cluster, i.e. on another cluster or locally on a laptop.

#### Download resource bundle

???+ note

    This pipeline does not have any reference files that need to be downloaded
    prior to running. As so, everything on this page can be safely ignored! We
    have bundled all the reference files for the pipeline within our Github
    repository. All the reference files are located within the [resources folder](https://github.com/OpenOmics/mpox-seek/tree/main/resources).

Please feel free to skip over this section. There are no reference files that need to be downloaded prior to running the pipeline. All reference files are bundled with the pipeline.

To download the pipeline's resource bundle, please run the following command:
```bash
# Dry-run download of the resource bundle,
# this will show you what will be downloaded.
./mpox-seek install --ref-path /data/$USER/refs \
             --force --threads 4 --dry-run

# Download the resource bundle, currently 
# all resources are bundled with the pipeline
# so there is nothing to download!
./mpox-seek install --ref-path /data/$USER/refs \
           --force --threads 4
```

Please remember the path provided to the `--ref-path` option above. During the download process, a new child directory called `mpox-seek` will be created. The path to this directory should be provided to the `--resource-bundle` option of the [run sub command](usage/run.md). For more information, please see the documentation for the [install sub command](usage/install.md).

#### Cache software containers

This next step is only applicable for singularity users. If you are using conda/mamba instead of singularity, you can skip over this section. To cache remote software containers, please run the following command:
```bash
# Dry run to see what will
# be pulled from DockerHub
./mpox-seek cache --sif-cache /data/$USER/cache --dry-run
# Cache software containers
./mpox-seek cache --sif-cache /data/$USER/cache
```

Please remember the path provided to the `--sif-cache` option above, you will need to provide this path to the `--sif-cache` option of the [run sub command](usage/run.md). For more information, please see the documentation for the [cache sub command](usage/install.md). 

#### Cache conda environment

This next step is only applicable to conda/mamba users. If you are using singularity instead of conda/mamba, you can skip over this section. By default, when the `--use-conda` option is provided, a conda environment will be built on the fly. Building a conda environment can be slow, and it also makes exeternal requests so you will need internet access. With that being said, it may make sense to create/cache the conda environment once and re-use it. To cache/create mpox-seek's conda environment, please run the following command:  
```bash
# Create a conda/mamba env
# called mpox-seek, you only 
# need to run this once 
# on your computer/cluster
mamba env create -f workflow/envs/mpox.yaml
```

Running the command above will create a named conda/mamba environment called `mpox-seek`. Now you can provide `--conda-env-name mpox-seek` to the [run sub command](usage/run.md). This will ensure conda/mamba is run in an offline-like mode where no external requests are made at runtime. It will use the local, named conda environment instead of building a new environment on the fly.

## TLDR

Here is everything you need to get quickly get started. This set of instructions assumes you have snakemake and (singularity or conda) already [installed on your target system](#dependencies), and that both are in your `$PATH`. 

Following the example below, please replace `--input .tests/*.gz` with your input ONT FastQ files. If you are running the pipeline on Windows, please use the Windows Subsystem for Linux (WSL).

!!! note "Quick Start"
    === "Other system + singularity offline mode"
        These instructions are for users/admins setting up the pipeline to run ouside of Biowulf in an offline mode. The pipeline can be run in an offline mode for users that do not have internet access with singularity. This mode is useful for researchers running the pipeline _in the field_ on a local laptop running linux. 
        
        In this example, we will cache/download remote resources in our `$HOME` directory, but please feel free to point to any other location on you computer or target system. You will need about 4 GB of free diskspace for the download.
        ```bash
        # Clone mpox-seek from Github
        git clone https://github.com/OpenOmics/mpox-seek.git
        # Change your working directory
        cd mpox-seek/
        # Get usage information
        ./mpox-seek -h
        # Cache software containers
        ./mpox-seek cache --sif-cache $HOME/SIFs
        # Dry run mpox-seek pipeline
        ./mpox-seek run --input .tests/*.gz --output tmp_01/ \
                   --sif-cache $HOME/SIFs --mode local \
                   --dry-run
        # Run mpox-seek pipeline
        # in offline-mode
        ./mpox-seek run --input .tests/*.gz --output tmp_01/ \
                   --sif-cache $HOME/SIFs --mode local
        ```

    === "Other system + conda offline mode"
        These instructions are for users/admins setting up the pipeline outside of Biowulf. The pipeline can be run in an offline mode for users that do not have internet access with conda/mamba. This mode is useful for researchers running the pipeline _in the field_ on a local laptop running linux, macOS, or [Windows Subsystem for Linux (WSL)](https://learn.microsoft.com/en-us/windows/wsl/install). 
        
        In this example, we will download the resource bundle in our `$HOME` directory, but please feel free to point to any other location on you computer or target system. You will need about 4 GB of free diskspace for the download.
        ```bash
        # Clone mpox-seek from Github
        git clone https://github.com/OpenOmics/mpox-seek.git
        # Change your working directory
        cd mpox-seek/
        # Get usage information
        ./mpox-seek -h
        # Add conda/mamba to $PATH 
        which conda \
            || source "${HOME:-~}/pipelines/conda/etc/profile.d/conda.sh" \
            || echo 'Error: conda/mamba is not installed.'
        # Cache conda environment,
        # creates a local conda env 
        # called mpox-seek
        mamba env create -f workflow/envs/mpox.yaml
        # Activate snakemake conda environment
        conda activate snakemake
        # Dry run mpox-seek pipeline to 
        # see what steps/jobs will run 
        ./mpox-seek run --input .tests/*.gz --output tmp_01/ \
                   --mode local --use-conda --conda-env-name mpox-seek \
                   --additional-strains resources/mpox_additional_strains.fa.gz \
                   --batch-id 2024-04-08 --bootstrap-trees --dry-run
        # Run mpox-seek pipeline with conda/mamba in
        # offline-mode, no external requests are made,
        # all software dependencies are cached locally
        ./mpox-seek run --input .tests/*.gz --output tmp_01/ \
                   --mode local --use-conda --conda-env-name mpox-seek \
                   --additional-strains resources/mpox_additional_strains.fa.gz \
                   --batch-id 2024-04-08 --bootstrap-trees
        ```

    === "Biowulf"
        If you are running the pipeline on Biowulf, do NOT need to download the resource bundle. These reference files already exist on Biowulf, and the pipeline is setup to automatically use them as needed. Also, we have already cached all of the pipeline's software containers here: `/data/OpenOmics/SIFs/`. If you are on Biowulf, you can `module load` the required dependencies. 
        
        Whenever the pipeline is provided with the `--sif-cache` option, it is run in an offline mode. We always recommend providing `--sif-cache /data/OpenOmics/SIFs/` when running the pipeline on Biowulf. This avoids issues related to DockerHub request limits if multiple users are concurrently run the pipeline on the cluster.
        ```bash
        # Grab an interactive node,
        # do not run on head node!
        srun -N 1 -n 1 --time=1:00:00 --mem=8gb  --cpus-per-task=2 --pty bash
        module purge
        module load singularity snakemake
        # Clone mpox-seek from Github
        git clone https://github.com/OpenOmics/mpox-seek.git
        # Change your working directory
        cd mpox-seek/
        # Get usage information
        ./mpox-seek -h
        # Dry run mpox-seek pipeline
        ./mpox-seek run --input .tests/*.gz --output tmp_01/ \
                   --sif-cache /data/OpenOmics/SIFs/ \
                   --mode slurm \
                   --dry-run
        # Run mpox-seek pipeline
        # on Biowulf cluster
        ./mpox-seek run --input .tests/*.gz --output tmp_01/ \
                   --sif-cache /data/OpenOmics/SIFs/ \
                   --mode slurm
        ```

