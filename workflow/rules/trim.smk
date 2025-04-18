# Helper functions
def get_barcoded_fastqs(wildcards):
    """
    Returns a list of per-sample multiplexed barcoded FastQ files.
    """
    barcodes = samples2barcodes[wildcards.name]
    # Convert strings to integers,
    # prior to sorting on keys,
    # JSON cannot have int keys.
    # {'0': 'WT_S1_0.fastq.gz', '1': 'WT_S1_1.fastq.gz'} 
    # { 0:  'WT_S1_0.fastq.gz',  1: 'WT_S1_1.fastq.gz'}
    barcodes = {int(k):v for k,v in barcodes.items()}
    if barcodes:
        # Merge multiple barcoded FastQ files,
        # Sort files based on barcode int to
        # ensure output is deterministic
        sorted_keys = sorted(barcodes.keys())              # 0, 1, ...
        sorted_values = [barcodes[k] for k in sorted_keys] # WT_S1_0.fastq.gz, WT_S1_1.fastq.gz
        return [join(workpath, f) for f in sorted_values]
    else:
        # Already merged, return input file
        return ["{0}.fastq.gz".format(join(workpath, wildcards.name))]


# Data processing rules
rule setup:
    """
    Initialization step to either demultiplex samples with multiple
    barcodes, or create symlinks to already merged inputs. Th shell 
    command is dynamically resolved depened on whether a given sample
    has a set of barcode files (meaning it needs concatenation) or if
    the sample is already merged (no barcode files, create symlink). 
    @Input:
        FastQ file (gather-per-sample-multiple-barcodes)
    @Output:
        Merged/symlinked FastQ files
    """
    input:
        fq=get_barcoded_fastqs,
    output:
        fq=join(workpath, "{name}", "fastqs", "{name}.fastq.gz"),
    params:
        rname ='merge',
         # Building to merge multiple files or 
         # create a symlink if already merged
        prefix = lambda w: "cat" 
            if samples2barcodes[w.name] 
            else "ln -sf",
        suffix = lambda w: ">" 
            if samples2barcodes[w.name] 
            else "",
    conda: depending(conda_yaml_or_named_env, use_conda)
    container: depending(config['images']['mpox-seek'], use_singularity)
    threads: int(allocated("threads", "setup", cluster))
    shell: 
        """
        {params.prefix} {input.fq} {params.suffix} {output.fq}
        """


rule nanofilt:
    """
    Depreciated data-processing step to perform base quality filtering with Nanofilt. 
    @Input:
        Setup FastQ file (scatter)
    @Output:
        Quality filtered FastQ file
    """
    input:
        fq  = join(workpath, "{name}", "fastqs", "{name}.fastq.gz"),
    output:
        flt = join(workpath, "{name}", "fastqs", "{name}.filtered.fastq.gz"),
    params:
        rname='nanofilt',
        qual_filt=8,
    conda: depending(conda_yaml_or_named_env, use_conda)
    container: depending(config['images']['mpox-seek'], use_singularity)
    threads: int(allocated("threads", "nanofilt", cluster))
    shell: 
        """
        # Nanofilt requires uncompressed input
        gunzip -c {input.fq} \\
            | NanoFilt -q {params.qual_filt} \\
            | gzip \\
        > {output.flt}
        """


rule zcat:
    """
    Data-processing step decompress a gzipp-ed strains file.
    @Input:
        Compressed genomic fasta file of additional monkeypox strains (singleton)
    @Output:
        Uncompressed genomic fasta file of additional monkeypox strains
    """
    input:
        fa = strains_fasta,
    output:
        fa = join(workpath, "project", "additional_strains.fa"),
    params:
        rname='zcat',
    conda: depending(conda_yaml_or_named_env, use_conda)
    container: depending(config['images']['mpox-seek'], use_singularity)
    threads: int(allocated("threads", "zcat", cluster))
    shell: 
        """
        # Uncompress monkeypox strains fasta
        gunzip -c {input.fa} \\
            > {output.fa}
        """


rule porechop:
    """
    Data-processing step to perform adapter trimming with porechop. 
    @Input:
        Setup FastQ file (scatter)
    @Output:
        Trimmed FastQ file
    """
    input:
        fq = join(workpath, "{name}", "fastqs", "{name}.fastq.gz"),
    output:
        fq = join(workpath, "{name}", "fastqs", "{name}.trimmed.fastq.gz"),
    params:
        rname='porechop',
    conda: depending(conda_yaml_or_named_env, use_conda)
    container: depending(config['images']['mpox-seek'], use_singularity)
    threads: int(allocated("threads", "porechop", cluster))
    shell: 
        """
        # Trim adapter sequences with porechop
        porechop \\
            -i {input.fq} \\
            -o {output.fq} \\
            --format fastq.gz \\
            --verbosity 1 \\
            --threads {threads}
        """