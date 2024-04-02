# Data processing rules to map, collapse, and perform msa
rule minimap2:
    """
    Data-processing step to align reads against NCBI MonkeyPox reference 
    sequence ("NC_003310.1"): https://www.ncbi.nlm.nih.gov/nuccore/NC_003310.1
    @Input:
        Trimmed FastQ file (scatter)
    @Output:
        SAM file
    """
    input:
        fq   = join(workpath, "{name}", "fastqs", "{name}.trimmed.fastq.gz"),
    output:
        sam  = join(workpath, "{name}", "bams", "{name}.sam"),
    params:
        rname  = 'minimap2',
        ref_fa  = config['references']['mpox_ref_genome'],
    conda: depending(conda_yaml_or_named_env, use_conda)
    container: depending(config['images']['mpox-seek'], use_singularity)
    shell: 
        """
        # Align against NCBRI monkeypox genome:
        # https://www.ncbi.nlm.nih.gov/nuccore/NC_003310.1
        minimap2 \\
            -ax map-ont \\
            --secondary=no \\
            --sam-hit-only \\
            {params.ref_fa} \\
            {input.fq} \\
        > {output.sam}
        """


rule consensus:
    """
    Data-processing step to collapse aligned reads into a consensus 
    sequence using viral_consensus. 
    @Input:
        SAM file (scatter)
    @Output:
        Consensus FASTA file,
        Consensus FASTA file with samples names for sequence identifers
    """
    input:
        sam = join(workpath, "{name}", "bams", "{name}.sam"),
    output:
        fa    = join(workpath, "{name}", "consensus", "{name}_consensus.fa"),
        fixed = join(workpath, "{name}", "consensus", "{name}_consensus_seqid.fa"),
    params:
        rname  = 'consensus',
        ref_fa  = config['references']['mpox_ref_genome'],
    conda: depending(conda_yaml_or_named_env, use_conda)
    container: depending(config['images']['mpox-seek'], use_singularity)
    shell: 
        """
        # Create a consensus sequence of aligned reads
        viral_consensus \\
            -i {input.sam} \\
            -r {params.ref_fa} \\
            -o {output.fa}
        
        # Rename the sequence identifers in the FASTA 
        # file to contain only the sample name, by
        # default viral_consensus contains the info
        # related to the command that was run.
        awk '{{split($0,a," "); n=split(a[4],b,"/"); gsub(/\\.sam$/,"",b[n]); if(a[2]) print ">"b[n]; else print; }}' \\
            {output.fa} \\
            > {output.fixed}
        """


rule concat:
    """
    Data-processing step to create an input FASTA file for mafft. This
    fasta file should contain the reference genome and the consensus
    sequence all samples.
    @Input:
        Consensus FASTA file with samples names for sequence identifers (gather)
    @Output:
        FASTA file containing the ref and the consensus sequences of all samples
    """
    input:
        fas = expand(join(workpath, "{name}", "consensus", "{name}_consensus_seqid.fa"), name=samples),
    output:
        fa  = join(workpath, "project", "consensus.fa"),
    params:
        rname  = 'premafft',
        ref_fa  = config['references']['mpox_ref_genome'],
    conda: depending(conda_yaml_or_named_env, use_conda)
    container: depending(config['images']['mpox-seek'], use_singularity)
    shell: 
        """
        # Create FASTA file with the reference genome
        # and the consensus sequence of each sample
        cat {params.ref_fa} \\
            {input.fas} \\
            > {output.fa}
        """


rule mafft:
    """
    Data-processing step to run multiple sequence alignment (MSA) of the
    reference genome and the consensus sequence of each sample.
    @Input:
        FASTA file containing the ref and the consensus sequences of all samples (indirect-gather, singleton)
    @Output:
        Multiple sequence alignment (MSA) FASTA file from mafft.
    """
    input:
        fa  = join(workpath, "project", "consensus.fa"),
    output:
        msa = join(workpath, "project", "msa.fa"),
    params:
        rname  = 'msa',
        ref_fa  = config['references']['mpox_ref_genome'],
    conda: depending(conda_yaml_or_named_env, use_conda)
    container: depending(config['images']['mpox-seek'], use_singularity)
    shell: 
        """
        # Run multiple sequence alignment (MSA) of the 
        # reference genome and each samples consensus 
        # sequence using mafft
        mafft --auto --thread 2 {input.fa} > {output.msa}
        """