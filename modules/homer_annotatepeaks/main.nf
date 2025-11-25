#!/usr/bin/env nextflow

process ANNOTATE {
    label 'process_single'
    container 'ghcr.io/bf528/homer_samtools:latest'
    publishDir params.outdir, mode: 'copy'

    input:
    tuple val(sample_id), path(peaks_bed)
    path gtf
    path genome

    output:
    tuple val(sample_id), path("annotated_peaks.txt"), emit: annotated

    script:
    """
    annotatePeaks.pl ${peaks_bed} ${genome} -gtf ${gtf} > annotated_peaks.txt
    """

    stub:
    """
    touch annotated_peaks.txt
    """
}