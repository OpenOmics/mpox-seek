# Data processing rules to build a phylogentic tree
rule tree:
    """
    Data-processing step to build a phylogentic tree of the multiple sequence 
    alignment (MSA) results using raxml-ng. This phylogentic tree can be viewed
    and explored interactively with tools like figtree, ete, taxonium, java 
    treeviewer, etc. The tools are open-source and free to use, and many of 
    them can be downloaded as desktop applications (run offline).
    @Input:
        Multiple sequence alignment (MSA) FASTA file from mafft.
    @Output:
        Phylogenetic tree (Newick format).
    """
    input:
        msa = join(workpath, "project", batch_id, "msa.fa"),
    output:
        nw  = join(workpath, "project", batch_id, "mpox_phylogeny.raxml.bestTree"),
    params:
        rname  = 'tree',
        prefix = join(workpath, "project", batch_id, "mpox_phylogeny"),
    conda: depending(conda_yaml_or_named_env, use_conda)
    container: depending(config['images']['mpox-seek'], use_singularity)
    shell: 
        """
        # Build a phylogenetic tree of containing 
        # the reference genome and all samples
        raxml-ng \\
            --redo \\
            --threads 2 \\
            --msa {input.msa} \\
            --model GTR+G \\
            --msa-format FASTA \\
            --prefix {params.prefix} \\
            --seed 42
        """