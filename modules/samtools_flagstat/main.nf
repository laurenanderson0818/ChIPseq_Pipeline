#!/usr/bin/env nextflow

process SAMTOOLS_FLAGSTAT {
    label 'process_low'
    container 'ghcr.io/bf528/samtools:latest'
    publishDir params.outdir, mode: 'copy'

    input:
    tuple val(sample_id), path(bam)

    output:
    tuple val(sample_id), path("*.flagstat.txt"), emit: flagstat

    script:
    """
    samtools flagstat $bam > ${sample_id}.flagstat.txt
    """

    stub:
    """
    touch ${sample_id}_flagstat.txt
    """
}