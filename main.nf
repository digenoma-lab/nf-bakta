#!/usr/bin/env nextflow

nextflow.enable.dsl = 2

// Usage
def help_msg() {
    help = """[nf-bakta]: Annotate bacterial genomes or MAGs running Bakta
    		|
    		|Usage:
            |  --input  directory of genomes/MAGs files (fasta format, i.e .fna)
            |           [default: ${params.input}]
            |
            |Optional arguments:
            |  --outdir results directory
            |           [default: ${params.outdir}]
            |  --db     database type {path-to/db-full|db-light}
            |           [default: db-light]
            |                
            """.stripMargin()
    println(help)
    exit(0)
}

// https://github.com/oschwengers/bakta
// https://github.com/nf-core/modules/blob/master/modules/nf-core/bakta/bakta/main.nf
process RUNBAKTA {
	// Each sample with a custom label (i.e: S15_350-bakta}
	tag "${sample}-bakta"
	publishDir "${params.outdir}/bakta/${sample}/${mags}", mode: "copy"
	
	conda (params.enable_conda ? "bioconda::bakta=1.7.0" : null)
	if (workflow.containerEngine == 'singularity' && !params.singularity_container) {
		container "https://depot.galaxyproject.org/singularity/bakta:1.7.0--pyhdfd78af_1"
	}
	else {
		container "quay.io/biocontainers/bakta:1.7.0--pyhdfd78af_1"
	}
	
	input:
	tuple val(sample), val(mags), file(fasta)
	path db
	
	output:
	tuple val(sample), path("${mags}/${mags}.embl"), emit: embl
	tuple val(sample), path("${mags}/${mags}.faa") , emit: faa
	tuple val(sample), path("${mags}/${mags}.ffn") , emit: ffn
	tuple val(sample), path("${mags}/${mags}.fna") , emit: fna
	tuple val(sample), path("${mags}/${mags}.gbff"), emit: gbff
	tuple val(sample), path("${mags}/${mags}.gff3"), emit: gff
	tuple val(sample), path("${mags}/${mags}.json"), emit: json
	tuple val(sample), path("${mags}/${mags}.tsv") , emit: tsv
	tuple val(sample), path("${mags}/${mags}.txt") , emit: txt
	tuple val(sample), path("${mags}/${mags}.png") , emit: png
	tuple val(sample), path("${mags}/${mags}.svg") , emit: svg
	tuple val(sample), path("${mags}/${mags}.log") , emit: log
	
	script:
	if (params.debug == true) {
		"""
		echo bakta --db ${db} --output ${mags} --skip-cds --skip-sorf --prefix ${mags} --threads ${task.cpus} ${fasta}
		
		touch ${mags}.embl
		touch ${mags}.faa
		touch ${mags}.ffn
		touch ${mags}.fna
		touch ${mags}.gbff
		touch ${mags}.gff3
		touch ${mags}.json
		touch ${mags}.tsv
		touch ${mags}.txt
		touch ${mags}.png
		touch ${mags}.svg
		touch ${mags}.log
		"""
	}
	else {
		"""
		bakta --db ${db} --output ${mags} --skip-cds --skip-sorf --prefix ${mags} --threads ${task.cpus} ${fasta}
		"""
	}
}

workflow {
	if (params.help || params.input == null) {
		help_msg()
	}
	else {
		// Read input.csv file
		mags = Channel
				.fromPath(params.input)
				.splitCsv(header: true)
				.map { row -> tuple(row.sample, row.mag, file(row.fna)) }
				//.view()
		
		RUNBAKTA(mags, file(params.db))
	}
}
// nextflow run main.nf -c bakta.config --input input.csv -profile singularity
// nextflow -bg run main.nf -c bakta.config --input input.mini.csv --db db/db -profile kutral -resume
