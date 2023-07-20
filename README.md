![Language: Nextflow](https://img.shields.io/badge/Language-Nextflow-green.svg)
![run with singularity](https://img.shields.io/badge/run%20with-singularity-1d355c.svg?labelColor=000000)

# nf-bakta

A Nextflow pipeline for the annotation of bacterial genomes or MAGs running Bakta.

## Introduction

[Bakta](https://github.com/oschwengers/bakta) is a rapid and standardized tool for annotating bacterial genomes or MAGs obtained from metagenomic samples. It generates as output a set of standard bioinformatics files for further analysis (e.g. ```tsv```, ```gff3```, ```gbff```, ```fna``` formats).

## Requirements

Running Bakta requires the download and curation of [databases](https://doi.org/10.5281/zenodo.4247252) comprising UniProt, NCBI RefSeq, AMRFinder, Pfam sequences and models (latest v5.0 DBs are full: 60GB | light: 3GB).

## Pipeline usage/parameters

The input for this pipeline is a set of FASTA files containing the genomic sequences in a formatted ```csv``` file (see [input examples](https://github.com/digenoma-lab/nf-bakta/input)).

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

Examples:

```
nextflow run main.nf -c bakta.config --input input.mini.csv -profile singularity
nextflow run main.nf -c bakta.config -bg --input input.csv --db db/db -profile kutral -resume
```

## Software versions

- Bakta: 1.8.1
- Nextflow: 23.04.2

