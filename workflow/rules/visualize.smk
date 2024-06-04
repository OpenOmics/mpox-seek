# Data processing rules to convert SAM to BigWig
# for visualization of coverage along the genome
rule bigwig:
    """
    Data-processing step to convert the align reads against NCBI MonkeyPox reference 
    sequence ("NC_003310.1"): https://www.ncbi.nlm.nih.gov/nuccore/NC_003310.1 into 
    a raw/normalized bigwig files for visualization. CPM normalization is peformed
    to take into account the total number of reads in the experiment. The bin size 
    will be set to 1bp to allow for high resolution visualization. The raw and cpm
    normalized bigwig files will be plotted for each sample. The normalized bigwig
    allows for comparison of coverage across samples, while the raw bigwig file can
    be used to visualize the raw read coverage of each sample to view the observed 
    sequencing depth along the genome.
    @Input:
        SAM file (scatter)
    @Output:
        CPM normlized bigwig file
    """
    input:
        bam = join(workpath, "{name}", "bams", "{name}.bam"),
    output:
        cpm_bw = join(workpath, "{name}", "bams", "{name}.cpm_normalized.bw"),
        raw_bw = join(workpath, "{name}", "bams", "{name}.raw_coverage.bw"),
    params:
        rname  = 'bamcoverage',
    conda: depending(conda_yaml_or_named_env, use_conda)
    container: depending(config['images']['mpox-seek'], use_singularity)
    shell: 
        """
        # Convert SAM to normalized bigwig file
        # using DeepTools bamCoverage:
        # https://deeptools.readthedocs.io/en/develop/content/tools/bamCoverage.html
        bamCoverage \\
            -b {input.bam} \\
            -o {output.cpm_bw} \\
            -of bigwig \\
            -bs 1 \\
            -p 1 \\
            --normalizeUsing CPM
        
        # Convert SAM to un-normalized bigwig file
        # using DeepTools bamCoverage
        bamCoverage \\
            -b {input.bam} \\
            -o {output.raw_bw} \\
            -of bigwig \\
            -bs 1 \\
            -p 1
        """
