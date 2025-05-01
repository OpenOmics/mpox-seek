# Data processing rules to build a phylogentic tree

# Slower of the two tree building methods: raxml-ng, fasttree.
# Raxml-ng builds a tree using maximum-likelihood (ML) optimality
# criterion which will result in a more accurate tree; however,
# it is orders of magntitude slower than fasttree. For PCR 
# amplicon data, this is the recommended tool/method to use.
if tree_tool == 'raxml-ng':
    rule tree:
        """
        Data-processing step to build a phylogentic tree of the multiple sequence 
        alignment (MSA) results using raxml-ng. This phylogentic tree can be viewed
        and explored interactively with tools like figtree, ete, taxonium, java 
        treeviewer, iTOL, etc. The tools are open-source and free to use, and many
        of them can be downloaded as desktop applications (run offline).
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
            rname  = 'tree_slow',
            prefix = join(workpath, "project", batch_id, "mpox_phylogeny"),
            bootrapping_options = lambda _: "--all --bs-metric fbp,tbe" if bootstrap_trees else ""
        conda: depending(conda_yaml_or_named_env, use_conda)
        container: depending(config['images']['mpox-seek'], use_singularity)
        threads: max(int(allocated("threads", "tree", cluster))/2, 2)
        shell: 
            """
            # Build a phylogenetic tree of containing 
            # the reference genome and all samples
            # using RAxML-NG maximum-likelihood
            # optimality criterion
            raxml-ng \\
                --redo \\
                --threads {threads} \\
                --msa {input.msa} \\
                --model GTR+G \\
                --msa-format FASTA \\
                --prefix {params.prefix} \\
                --seed 42 {params.bootrapping_options}
            """
else:
    # Faster of the two tree building methods: raxml-ng, fasttree.
    # Fasttree builds a tree using variant of a neighbor-joining
    # which is orders of magnitude faster than raxml-ng; however,
    # the resulting topology may not be as accurate as raxml-ng.
    # For WGS, this is the recommended tree building tool as it
    # can be run on a laptop in a reasonable amount of time.
    # Also, benchmarking has also shown that bootstrapping with
    # complete viral genomes and an additional strains file can
    # be completed in a reasonable amount of time with fasttree
    # whereas with raxml-ng, it would take days or much longer
    # (closer to a week) to perform.
    rule tree:
        """
        Data-processing step to build a phylogentic tree of the multiple sequence 
        alignment (MSA) results using fastree. This phylogentic tree can be viewed
        and explored interactively with tools like figtree, ete, taxonium, java 
        treeviewer, iTOL, etc. The tools are open-source and free to use, and many
        of them can be downloaded as desktop applications (run offline).
        @Input:
            Multiple sequence alignment (MSA) FASTA file from mafft.
        @Output:
            Phylogenetic tree (Newick format).
        """
        input:
            msa = join(workpath, "project", batch_id, "msa.fa"),
        output:
            nw  = join(workpath, "project", batch_id, "mpox_phylogeny.fasttree.tree"),
        params:
            rname  = 'tree_fast',
            prefix = join(workpath, "project", batch_id, "mpox_phylogeny"),
            bootrapping_options = lambda _: "-boot 1000" if bootstrap_trees else "-nosupport"
        conda: depending(conda_yaml_or_named_env, use_conda)
        container: depending(config['images']['mpox-seek'], use_singularity)
        threads: max(int(allocated("threads", "tree", cluster))/2, 2)
        shell: 
            """
            # Build a phylogenetic tree of containing 
            # the reference genome and all samples
            # using fasttree neighbor-joining method
            FastTree {params.bootrapping_options} \\
                -seed 42 \\
                -nt {input.msa} \\
            > {output.nw}
            """