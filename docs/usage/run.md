# <code>mpox-seek <b>run</b></code>

## 1. About 
The `mpox-seek` executable is composed of several inter-related sub commands. Please see `mpox-seek -h` for all available options.

This part of the documentation describes options and concepts for <code>mpox-seek <b>run</b></code> sub command in more detail. With minimal configuration, the **`run`** sub command enables you to start running mpox-seek pipeline. 

Setting up the mpox-seek pipeline is fast and easy! In its most basic form, <code>mpox-seek <b>run</b></code> only has *two required inputs*.

## 2. Synopsis
```text
$ mpox-seek run [--help] \
      [--dry-run] [--job-name JOB_NAME] [--mode {slurm,local}] \
      [--sif-cache SIF_CACHE] [--singularity-cache SINGULARITY_CACHE] \
      [--silent] [--threads THREADS] [--tmp-dir TMP_DIR] \
      [--resource-bundle RESOURCE_BUNDLE] [--use-conda] \
      [--conda-env-name CONDA_ENV_NAME] \
      [--additional-strains ADDITIONAL_STRAINS] \
      [--batch-id BATCH_ID] \
      [--bootstrap-trees] \
      [--msa-tool {mafft,viralmsa}] \
      [--plot-coverage] \
      [--tree-tool {raxml-ng,fasttree}] \
      [--whole-genome-sequencing] \
      --input INPUT [INPUT ...] \
      --output OUTPUT
```

The synopsis for each command shows its arguments and their usage. Optional arguments are shown in square brackets.

A user **must** provide a list of FastQ (globbing is supported) to analyze via `--input` argument and an output directory to store results via `--output` argument.

Use you can always use the `-h` option for information on a specific command. 

### 2.1 Required arguments

Each of the following arguments are required. Failure to provide a required argument will result in a non-zero exit-code.

  `--input INPUT [INPUT ...]`  
> **Input Oxford Nanopore FastQ files(s).**  
> *type: file(s)*  
> 
> One or more FastQ files can be provided. From the command-line, each input file should seperated by a space. Globbing is supported! This makes selecting FastQ files easy. Input FastQ files should always be gzipp-ed. If a sample has multiple fastq files for different barcodes, the pipeline expects each barcoded FastQ file endwith the following extension: `_N.fastq.gz`, where `N` is a number. Internally, the pipeline will concatenate each of these FastQ files prior to processing the data. Here is an example of an input sample with multiple barcode sequences: `S1_0.fastq.gz`, `S1_1.fastq.gz`, `S1_2.fastq.gz`, `S1_3.fastq.gz`. Given this barcoded sample, the pipeline will create the following concatenated FastQ file: `S1.fastq.gz`. 
> 
> ***Example:*** `--input .tests/*.fastq.gz`

---  
  `--output OUTPUT`
> **Path to an output directory.**   
> *type: path*
>   
> This location is where the pipeline will create all of its output files, also known as the pipeline's working directory. If the provided output directory does not exist, it will be created automatically.
> 
> ***Example:*** `--output /data/$USER/mpox-seek_out`

### 2.2 Analysis options

Each of the following arguments are optional, and do not need to be provided. 

  `--additional-strains ADDITIONAL_STRAINS`  
> **Genomic fasta file of additional monekypox strains to add to the phylogenetic tree.**  
> *type: FASTA file*  
> *default: none*  
> 
> This is a genomic fasta file of additional monekypox strains to add to the phylogenetic tree. By default, a phylogenetic tree is build with your input samples and the [reference genome](https://github.com/OpenOmics/mpox-seek/blob/main/resources/mpox_NC_003310_1_pcr_sequence.fa), see "mpox_pcr_sequence" in "[config/genome.json](https://github.com/OpenOmics/mpox-seek/blob/main/config/genome.json)" for the path to this file. When this option is provided a phylogenetic tree containing your input samples, the reference genome, and any additional monkeypox strain the provided file are built. We have provided a genomic fasta file of additional strains with mpox-seek. Please see "[resources/mpox_additional_strains.fa.gz](https://github.com/OpenOmics/mpox-seek/blob/main/resources/)" for more information. This file can be provided directly to this option. We highly recommended using this option with the `--batch-id` option below to avoid any files from being overwritten between runs of the pipeline.  
> 
> ***Example:*** `resources/mpox_additional_strains.fa.gz`

---
  `--batch-id BATCH_ID`  
> **Unique identifer to associate with a batch of samples.**  
> *type: string*  
> *default: none*  
> 
> This option can be provided to ensure that project-level output files are not over-written between runs of the pipeline. As so, it is good to always provide this option. By default, project-level files in the "project" will get over-written between pipeline runs if this option is not provided. Any identifer provided to this option will be used to create a sub-directory in the project folder. This ensures project-level files (which are unique) will  not get over-written as new data/samples are processed. A unique batch id should be provided between runs. This batch id should be composed of alphanumeric characters and it should not contain a white space or tab characters. Here is a list of valid or acceptable characters: `aA-Zz`, `0-9`, `-`, `_`. 
> 
> ***Example:*** `--batch-id "2024-04-01"`

---
  `--bootstrap-trees`  
> **Computes branch support by bootstraping data.**  
> *type: boolean flag*  
> *default: false*  
> 
> This option will empirically compute the support for each branch by bootstrapping the data. If this flag is provided, [`raxml-ng`](https://github.com/amkozlov/raxml-ng/wiki/Tutorial#bootstrapping) is run in an all-in-one (ML search + bootstrapping) mode via its `--all` option. Branch supports, calculated by bootstrapping, will be added to the best scoring tree. By default, the pipeline will not created a tree with transferred bootstrapped supports.
> 
> ***Example:*** `--bootstrap-trees`

---
  `--msa-tool {mafft,viralmsa}`  
> **Select a tool for multiple sequence alignment.**  
> *type: string*  
> *default: mafft*  
>  
>  Set this option to perform multiple sequence alignment (MSA) using one of the provided tools. This option allows a user to select an alternative tool or method for performing MSA. By default, the pipeline will use *mafft*; however, for whole-genome sequencing data *viralmsa* is recommended. Currently, there are two different tools/options available: *mafft* or *viralmsa*. Here is an overview of each tool.  
> 
> ***mafft***  
> Performs global multiple sequence alignment. This is the slower of the two options; however, it produces the best results. This is the default msa tool if this option is not provided. If you have PCR amplicon data, this is the recommended option for performing MSA.
>  
> ***viralmsa***   
> Performs reference guided multiple sequence alignment. This is the faster of the two options; however, it produces rooted output relative to the provided reference genome. If you are running the pipeline with complete viral sequences and the whole genome sequencing option (i.e `--whole-genome-sequencing`), we recommened using viralmsa over mafft. Viralmsa will be orders of magnitiude faster than mafft, and it can scale to hundreds or thousands of samples/additional strains.
>
> ***Example:*** `--msa-tool mafft`

---
  `--plot-coverage`  
> **Plots coverage of each sample.**  
> *type: boolean flag*  
> *default: false*  
>  
>  This option will plot coverage along the reference genome. If this flag is provided, per-sample plots of raw coverage will be created. This plot can be useful for identifying samples or regions of the reference genome with low coverage. By default, the pipeline will not create any coverage plots.  
>  
> ***Example:*** `--plot-coverage`  

---
  `--tree-tool {raxml-ng,fasttree}`  
> **Select a tool for building a phylogentic tree.**  
> *type: string*  
> *default: raxml-ng*  
>  
>  Set this option to build a phylogentic tree using one of the provided tools. This option allows a user to build a phylogentic tree using the selected tool. This option allows a user to select an alternative tool or method for building a phylogentic tree. Currently, there are two different tools/options available: *raxmlng*, *fasttree*. Here is a short description of each available tool.
> 
> ***raxml-ng***  
> Builds a tree using maximum-likelihood (ML) optimality criterion. This is the slower of the two options; however, it produces the best results. This is the default tree building tool if this option is not provided. If you have PCR amplicon data, this is the recommended option for building a phylogentic tree.
>  
> ***fasttree***    
> Builds a tree using fasttree's variant of a neighbor-joining. This is the faster of the two options; however, it may not produce the most optimal topology. If you are running the pipeline with complete viral sequences and the whole genome sequencing option (i.e `--whole-genome -sequencing`), we recommened using *fasttree* over *raxml-ng*. Fasttree will be orders of magnitiude faster than raxml-ng, and it can scale to hundreds or thousands of samples/ additional strains. Benchmarking has also shown that bootstrapping with complete viral genomes and an additional strains file can be completed with fasttree whereas with raxml-ng, it would take days or longer to perform.
>
> ***Example:*** `--tree-tool raxml-ng`

---
  `--whole-genome-sequencing`  
> **Runs the pipeline in WGS mode.**  
> *type: boolean flag*  
> *default: false*  
>  
>  This flag is used to indicate that the input FastQ files are whole genome sequences. By default, the pipeline will assume that the input FastQ files are amplicon sequences. This option is only required if the input FastQ files contain whole genome sequences. If provided, the pipeline will align reads against the entire monkeypox genome. It is also worh noting that if this option is provided, *we highly recommend also providing the following options*: `--msa-tool viralmsa` and `--tree-tool fasttree` due to the size of the input data. The `viralmsa` and `fasttree` are better optimized for large datasets, such as whole genome sequences.
>  
> ***Example:*** `--whole-genome-sequencing`

### 2.3 Orchestration options

Each of the following arguments are optional, and do not need to be provided. 

  `--dry-run`            
> **Dry run the pipeline.**  
> *type: boolean flag*
> 
> Displays what steps in the pipeline remain or will be run. Does not execute anything!
>
> ***Example:*** `--dry-run`

---  
  `--silent`            
> **Silence standard output.**  
> *type: boolean flag*
> 
> Reduces the amount of information directed to standard output when submitting master job to the job scheduler. Only the job id of the master job is returned.
>
> ***Example:*** `--silent`

---  
  `--mode {local,slurm}`  
> **Execution Method.**  
> *type: string*  
> *default: local*  
> 
> Execution Method. Defines the mode or method of execution. Vaild mode options include: slurm or local. 
>
> ***local***  
> Local executions will run serially on compute instance, laptop, or desktop computer. This is useful for testing, debugging, or when a users does not have access to a high performance computing environment. If this option is not provided, it will default to a this mode of execution. This is the correct mode of execution if you are running the pipeline on a laptop or a local desktop computer. 
>  
> ***slurm***    
> The slurm execution method will submit jobs to the [SLURM workload manager](https://slurm.schedmd.com/). This method will submit jobs to a SLURM HPC cluster using sbatch. It is recommended running the pipeline in this mode as it will be significantly faster; however, this mode of execution can only be provided if the pipeline is being run from a SLURM HPC cluster. By default, the pipeline runs in a local mode of execution. If you are running this pipeline on a laptop or desktop compute, please use the local mode of execution.
>
> ***Example:*** `--mode local`

---  
  `--job-name JOB_NAME`  
> **Set the name of the pipeline's master job.**  
> *type: string*  
> *default: pl:mpox-seek*  
> 
> When submitting the pipeline to a job scheduler, like SLURM, this option always you to set the name of the pipeline's master job. By default, the name of the pipeline's master job is set to "pl:mpox-seek".
> 
> ***Example:*** `--job-name pl_id-42`

---  
  `--singularity-cache SINGULARITY_CACHE`  
> **Overrides the $SINGULARITY_CACHEDIR environment variable.**  
> *type: path*  
> *default: `--output OUTPUT/.singularity`*  
>
> Singularity will cache image layers pulled from remote registries. This ultimately speeds up the process of pull an image from DockerHub if an image layer already exists in the singularity cache directory. By default, the cache is set to the value provided to the `--output` argument. Please note that this cache cannot be shared across users. Singularity strictly enforces you own the cache directory and will return a non-zero exit code if you do not own the cache directory! See the `--sif-cache` option to create a shareable resource. 
> 
> ***Example:*** `--singularity-cache /data/$USER/.singularity`

---  
  `--sif-cache SIF_CACHE`
> **Path where a local cache of SIFs are stored.**  
> *type: path*  
>
> Uses a local cache of SIFs on the filesystem. This SIF cache can be shared across users if permissions are set correctly. If a SIF does not exist in the SIF cache, the image will be pulled from Dockerhub and a warning message will be displayed. The `mpox-seek cache` subcommand can be used to create a local SIF cache. Please see `mpox-seek cache` for more information. This command is extremely useful for avoiding DockerHub pull rate limits. It also remove any potential errors that could occur due to network issues or DockerHub being temporarily unavailable. We recommend running mpox-seek with this option when ever possible.
> 
> ***Example:*** `-sif-cache /data/$USER/SIFs`

---  
  `--threads THREADS`   
> **Max number of threads for each process.**  
> *type: int*  
> *default: 2*  
> 
> Max number of threads for each process. This option is more applicable when running the pipeline with `--mode local`.  It is recommended setting this vaule to the maximum number of CPUs available on the host machine.
> 
> ***Example:*** `--threads 12`

---  
  `--tmp-dir TMP_DIR`   
> **Max number of threads for each process.**  
> *type: path*  
> *default: `/lscratch/$SLURM_JOBID`*  
> 
> Path on the file system for writing temporary output files. By default, the temporary directory is set to '/lscratch/$SLURM_JOBID' for backwards compatibility with the NIH's Biowulf cluster; however, if you are running the pipeline on another cluster, this option will need to be specified. Ideally, this path should point to a dedicated location on the filesystem for writing tmp files. On many systems, this location is set to somewhere in /scratch. If you need to inject a variable into this string that should NOT be expanded, please quote this options value in single quotes.
> 
> ***Example:*** `--tmp-dir /scratch/$USER/`

---  
  `--resource-bundle RESOURCE_BUNDLE`
> **Path to a resource bundle downloaded with the install sub command.**  
> *type: path*  
>
> At the current moment, the pipeline does not need any external resources/reference files to be downloaded prior to running. All the pipeline's reference files have been bundled within the github repository. They can be found within the [resources folder](https://github.com/OpenOmics/mpox-seek/tree/main/resources). As so, this option should not be provided at run time.
> 
> ***Example:*** `--resource-bundle /data/$USER/refs/mpox-seek`

---  
  `--use-conda`   
> **Use Conda/mamba instead of Singularity.**  
> *type: boolean flag*  
> 
> Use Conda/Mamba instead of Singularity. By default, the pipeline uses singularity for handling required software dependencies. This option overrides that behavior, and it will use Conda/mamba instead of Singularity. The use of Singuarity and Conda are mutually exclusive. Please note that conda and mamba must be in your $PATH prior to running the pipeline. This option will build a conda environment on the fly prior to the pipeline's execution. As so, this step requires internet access. To run mpox-seek in an offline mode with conda, please see the `--conda-env-name` option below. 
> 
> ***Example:*** `--use-conda`

---  
  `--conda-env-name CONDA_ENV_NAME`   
> **Use an existing conda environment.**  
> *type: str*
> 
> Use an existing conda environment. This option allows mpox-seek to run with conda in an offline mode. If you are using conda without this option, the pipeline will build a conda environment on the fly prior to the its execution. Building a conda environment can sometimes be slow, as it downloads dependencies from the internet, so it may make sense to build it once and re-use it. This will also allow you to use conda/mamba in an offline mode. If you  have already built a named conda environment with the supplied yaml file, then you can directly use it with this option. Please provide the name of the conda environment that was specifically built for the mpox-seek pipeline. 
>
> To create a reusable conda/mamba environment with the name `mpox-seek`, please run the following mamba command: 
> ```bash
> # Creates a reusable conda
> # environment called mpox-seek
> mamba env create -f workflow/envs/mpox.yaml
> ```

> ***Example:*** `--conda-env-name mpox-seek`

### 2.4 Miscellaneous options  
Each of the following arguments are optional, and do not need to be provided. 

  `-h, --help`            
> **Display Help.**  
> *type: boolean flag*
> 
> Shows command's synopsis, help message, and an example command
> 
> ***Example:*** `--help`

## 3. Example

The example below shows how run the pipeline locally using conda/mamba. If you have already created a _mpox-seek_ conda environment, please use feel free to also add the following option: `--conda-env-name mpox-seek`. To create a re-usable, named conda environment for the pipeline, please run the following command: `mamba env create -f workflow/envs/mpox.yaml`. For detailed setup instructions, please see our [setup page](setup.md).

### 3.1 Targeted, PCR amplicon sequencing data

```bash 
  # Step 1.) Activate your conda environment,
  # assumes its installed in home directory.
  # May need to change this depending on
  # where you installed conda/mamba.
  . ${HOME}/conda/etc/profile.d/conda.sh
  conda activate snakemake

  # Step 2A.) Dry-run the pipeline, this
  # will show what steps will run.
  ./mpox-seek run --input .tests/*.fastq.gz \
            --output pcr_mpox-seek_output \
            --additional-strains resources/mpox_additional_strains.fa.gz \
            --batch-id "$(date '+%Y-%m-%d-%H-%M')" \
            --bootstrap-trees \
            --mode local \
            --use-conda \
            --dry-run

  # Step 2B.) Run the mpox-seek pipeline,
  # Create a tree with additional 
  # strains of interest and adds a
  # unique batch identifer to project-
  # level files to ensure no over
  # writting of files occurs, format:
  # YYYY-MM-DD-HH-MM. Support for each
  # branch is calculated via bootstrapping.
  # The pipeline will default to using
  # the mafft and raxml-ng tools for
  # multiple sequence alignment and
  # phylogenetic tree construction.
  # Mafft and raxml-ng are recommended
  # for amplicon data.
  ./mpox-seek run --input .tests/*.fastq.gz \
            --output pcr_mpox-seek_output \
            --additional-strains resources/mpox_additional_strains.fa.gz \
            --batch-id "$(date '+%Y-%m-%d-%H-%M')" \
            --bootstrap-trees \
            --use-conda \
            --mode local
```

### 3.1 Complete, whole-genome sequencing data

Mpox-seek is designed to work with both amplicon and whole-genome sequencing data. If you have complete viral sequences, please run the pipeline with the following options below. 

**Please note:** An additional strains file for complete viral sequences has not been bundled with the pipeline; however, you can create your own file with the same format as the one provided with the pipeline.

```bash 
  # Step 1.) Activate your conda environment,
  # assumes its installed in home directory.
  # May need to change this depending on
  # where you installed conda/mamba.
  . ${HOME}/conda/etc/profile.d/conda.sh
  conda activate snakemake

  # Step 2A.) Dry-run the pipeline, this
  # will show what steps will run.
  ./mpox-seek run --input .tests/*.fastq.gz \
            --output wgs_mpox-seek_output \
            --additional-strains mpox_wgs_additional_strains.fa.gz \
            --batch-id "$(date '+%Y-%m-%d-%H-%M')" \
            --bootstrap-trees \
            --msa-tool viralmsa \
            --tree-tool fasttree \
            --whole-genome-sequencing \
            --mode local \
            --use-conda \
            --dry-run

  # Step 2B.) Run the mpox-seek pipeline,
  # Create a tree with additional 
  # strains of interest and adds a
  # unique batch identifer to project-
  # level files to ensure no over
  # writting of files occurs, format:
  # YYYY-MM-DD-HH-MM. Support for each
  # branch is calculated via bootstrapping.
  # For WGS data, we recommend using
  # the viralmsa and fasttree tools for
  # multiple sequence alignment and
  # phylogenetic tree construction.
  ./mpox-seek run --input .tests/*.fastq.gz \
            --output wgs_mpox-seek_output \
            --additional-strains mpox_wgs_additional_strains.fa.gz \
            --batch-id "$(date '+%Y-%m-%d-%H-%M')" \
            --bootstrap-trees \
            --msa-tool viralmsa \
            --tree-tool fasttree \
            --whole-genome-sequencing \
            --use-conda \
            --mode local
```