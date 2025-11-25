#!/usr/bin/env nextflow

process BEDTOOLS_REMOVE {
    label 'process_single'
    container 'ghcr.io/bf528/bedtools:latest'
    publishDir params.outdir, mode: 'copy'

    input:
    tuple val(sample_id), path(repr_peaks)
    path blacklist

    output:
    tuple val(sample_id), path("repr_peaks_filtered.bed")

    script:
    """
    bedtools subtract -a ${repr_peaks} -b ${blacklist} > repr_peaks_filtered.bed
    """

    stub:
    """
    touch repr_peaks_filtered.bed
    """
}