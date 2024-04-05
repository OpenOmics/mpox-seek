# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.1.0-beta] - 2024-03-29
### Start
  - Created scaffold from [nanite](https://github.com/OpenOmics/nanite) for building the pipeline

## [0.1.0] - 2024-04-05
### First public release
  - Rapidly builds a phylogentic tree for a set of targeted ONT monkeypox samples data using porechop, minimap2, viral_consensus, mafft, and raxml-ng. Additional monkeypox strains can be added to the tree, via the `--additional-strains` option. The `--batch-id` option can be provided to ensure unique output files are not over-written between runs of the pipeline. When this option is provided, a sub-directory is created in the project folder for writing project-level output files, i.e `{output_directory}/project/{batch_id}`.
