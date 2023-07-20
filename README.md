![Language: Nextflow](https://img.shields.io/badge/Language-Nextflow-green.svg)
![run with singularity](https://img.shields.io/badge/run%20with-singularity-1d355c.svg?labelColor=000000)

# nf-bakta

A Nextflow pipeline for the annotation of bacterial genomes or MAGs running Bakta.

## Introduction

[Bakta](https://github.com/oschwengers/bakta) is a rapid and standardized tool for annotating bacterial genomes or MAGs obtained from metagenomic samples. It generates as output a set of standard bioinformatics files for further analysis (e.g. ```tsv```, ```gff3```, ```gbff```, ```fna``` among other format).

## Requirements

Running Bakta requires the download and curation of mandatory [databases](https://doi.org/10.5281/zenodo.4247252) to use them internally (latest v5.0 are full: 60GB and light: 3GB). Both databases comprise sequences and models from UniProt, NCBI RefSeq, AMRFinder and Pfam universe, being the full type more comprehensive in taxonomic annotation.

## Pipeline usage/parameters

The input for this pipeline is a set of FASTA files containing the genomic sequences in a formatted ```csv``` file (see [input examples](https://github.com/digenoma-lab/nf-bakta/tree/main/input)).

```
Usage:
  --input  directory of genomes/MAGs files (fasta format, i.e .fna)
           [default: null]

Optional arguments:
  --outdir results directory
           [default: results]
  --db     database type {path-to/db-full|db-light}
           [default: db-light]
```

## Nextflow execution

Examples ([DiGenomaLab](https://digenoma-lab.cl/facilities/cluster/) environment):

1. Run the workflow using a ```small dataset``` in the local node (```singularity```).
```
nextflow run main.nf -c bakta.config --input input.mini.csv -profile singularity
```

2. Run in ```background mode``` with the ```full dataset``` of samples, using the ```full``` database in distributed nodes (```kutral``` cluster). Consider the ```resume``` option for caching the tasks in case of any error.
```
nextflow run main.nf -c bakta.config -bg --input input.csv --db db/db-full -profile kutral {-resume}
```

For configuration details, please check/modify the ```bakta.conf``` file.

## Software versions

- Bakta: 1.8.1
- Nextflow: 23.04.2

