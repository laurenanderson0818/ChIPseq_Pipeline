#!/usr/bin/env nextflow

process PLOTCORRELATION {
    label 'process_medium'
    container 'ghcr.io/bf528/deeptools:latest'
    publishDir params.outdir, mode: 'copy'

    input:
    path matrix
    val sample_labels
    val corrtype

    output:
    path("correlation_plot.png"), emit: correlation_plot

    script:
    """
    plotCorrelation -in ${matrix} -c ${corrtype} -p heatmap -o correlation_plot.png --skipZeros --plotNumbers -l ${sample_labels.join(' ')}
    """

    stub:
    """
    touch correlation_plot.png
    """
}