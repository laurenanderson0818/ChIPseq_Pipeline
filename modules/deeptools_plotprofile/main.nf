#!/usr/bin/env nextflow

process PLOTPROFILE {
    label 'process_medium'
    container 'ghcr.io/bf528/deeptools:latest'
    publishDir params.outdir, mode: 'copy'

    input:
    tuple val(sample_id), path(matrix)

    output:
    path("${sample_id}.signal_coverage.png"), emit: profile_plot

    script:
    """
    plotProfile -m ${matrix} -o ${sample_id}.signal_coverage.png
    """

    stub:
    """
    touch ${sample_id}_signal_coverage.png
    """
}