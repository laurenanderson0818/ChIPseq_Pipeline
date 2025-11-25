#!/usr/bin/env nextflow

process FINDPEAKS {
    label 'process_single'
    container 'ghcr.io/bf528/homer_samtools:latest'
    publishDir params.outdir, mode: 'copy'

    input:
    tuple val(rep), path(ip_tagdir), path(control_tagdir)

    output:
    tuple val(rep), path("${rep}.peaks.txt"), emit: peaks

    script:
    """
    findPeaks ${ip_tagdir} -style factor -i ${control_tagdir} -o ${rep}.peaks.txt
    """

    stub:
    """
    touch ${rep}.peaks.txt
    """
}