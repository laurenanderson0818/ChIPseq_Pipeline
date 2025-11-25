#!/usr/bin/env nextflow

process BEDTOOLS_INTERSECT {
    label 'process_low'
    container 'ghcr.io/bf528/bedtools:latest'
    publishDir params.outdir, mode: 'copy'

    input:
    tuple val(sample_id), path(bed_files)

    output:
    path("repr_peaks.bed")

    script:
    """
    bedtools intersect -a ${bed_files[0]} -b ${bed_files[1]} -f 0.50 -r > repr_peaks.bed
    """

    stub:
    """
    touch repr_peaks.bed
    """
}