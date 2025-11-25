#!/usr/bin/env nextflow

process FIND_MOTIFS_GENOME {
    label 'process_single'
    container 'ghcr.io/bf528/homer_samtools:latest'
    publishDir params.outdir, mode: 'copy'

    input:
    tuple val(sample_id), path(filtered_peaks)
    path genome

    output:
    tuple val(sample_id), path("motifs"), emit: motifs

    script:
    """
    findMotifsGenome.pl ${filtered_peaks} ${genome} motifs -size given
    """

    stub:
    """
    mkdir motifs
    """
}