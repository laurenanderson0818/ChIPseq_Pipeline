#!/usr/bin/env nextflow

process COMPUTEMATRIX {
    label 'process_medium'
    container 'ghcr.io/bf528/deeptools:latest'
    publishDir params.outdir, mode: 'copy'

    input:
    tuple val(sample_id), path(bw)
    path ucsc_genes
    val window

    output:
    tuple val(sample_id), path("*.matrix.gz"), emit: matrix

    script:
    """
    computeMatrix scale-regions -S ${bw} -R ${ucsc_genes} -b ${window} -a ${window} -o ${sample_id}.matrix.gz
    """

    stub:
    """
    touch ${sample_id}_matrix.gz
    """
}