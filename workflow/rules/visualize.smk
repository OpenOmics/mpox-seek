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
        rname  = 'bigwig',
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


# Data processing rules to visualize
# coverage along the genome
rule plot_coverage:
    """
    Data visualization step to plot the coverage of the reads along the genome
    for each sample. The raw and normalized bigwig files will be plotted for each
    sample. The normalized bigwig allows for comparison of coverage across samples,
    while the raw bigwig file can be used to visualize the raw read coverage of each
    sample to view the observed sequencing depth along the genome.
    @Input:
        CPM normalized bigwig file
        Raw coverage bigwig file
    @Output:
        Coverage PNG plot
    """
    input:
        raw_bw = join(workpath, "{name}", "bams", "{name}.raw_coverage.bw"),
    output:
        ini = join(workpath, "{name}", "plots", "{name}.coverage_plot.ini"),
        pdf = join(workpath, "{name}", "plots", "{name}.coverage_plot.pdf"),
        ini_log2 = join(workpath, "{name}", "plots", "{name}.coverage_plot_log2.ini"),
        pdf_log2 = join(workpath, "{name}", "plots", "{name}.coverage_plot_log2.pdf"),
    params:
        rname  = 'plotcoverage',
        ref_fa  = ref_fa,
    conda: depending(conda_yaml_or_named_env, use_conda)
    container: depending(config['images']['mpox-seek'], use_singularity)
    shell: 
        """
        # Create a config/ini file for 
        # DeepTools pyGenomeTracks:
        # https://pygenometracks.readthedocs.io/en/latest/index.html
        make_tracks_file \\
            --trackFiles {input.raw_bw} \\
            -o {output.ini}

        # Update config file to increase 
        # height and number of bins and 
        # remove suffix from track name
        # Raw coverage plot config
        sed -i 's/\.raw_coverage$//g' \\
            {output.ini}
        sed -i 's/height = 2/height = 4/g' \\
            {output.ini}
        sed -i 's/number_of_bins = 700/number_of_bins = 1000/g' \\
            {output.ini}
        # log2 coverage plot config
        sed '$i\\transform = log' \\
            {output.ini} \\
        > {output.ini_log2}
        # Adding a small pseudocount
        # to avoid taking the log(0)
        sed -i '$i\\log_pseudocount = 1' \\
            {output.ini_log2}

        # Plot coverage along the genome,
        # pyGenomeTracks requires a region
        # is provided, so we will use the
        # full length of the reference genome
        region=$(samtools faidx {params.ref_fa} -o /dev/stdout | head -1 | awk -F '\\t' '{{print $1":1-"$2}}')
        # Raw coverage plot
        pyGenomeTracks \\
            --tracks {output.ini} \\
            -o {output.pdf} \\
            --region "$region"
        # log2 coverage plot
        pyGenomeTracks \\
            --tracks {output.ini_log2} \\
            -o {output.pdf_log2} \\
            --region "$region"
        """