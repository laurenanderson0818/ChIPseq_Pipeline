#!/usr/bin/env nextflow

process TAGDIR {
    label 'process_single'
    container 'ghcr.io/bf528/homer_samtools:latest'
    publishDir params.outdir, mode: 'copy'

    input:
    tuple val(sample_id), path(bam)

    output:
    tuple val (sample_id), path("${sample_id}.tags"), emit: tagdir

    script:
    """
    makeTagDirectory ${sample_id}.tags ${bam}
    """

    stub:
    """
    mkdir ${sample_id}_tags
    """
}