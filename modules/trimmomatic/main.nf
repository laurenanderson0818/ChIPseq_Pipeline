#!/usr/bin/env nextflow

process TRIM {
    label 'process_low'
    container 'ghcr.io/bf528/trimmomatic:latest'
    publishDir params.outdir, mode: 'copy'
    
    input:
    tuple val(sample_id), path(reads)

    output:
    tuple val(sample_id), path("${sample_id}.trimmed.fastq.gz"), emit: trimmed_reads
    tuple val(sample_id), path("${sample_id}.log"), emit: log

    script:
    """
    trimmomatic SE -phred33 \
        -threads $task.cpus \
        $reads \
        ${sample_id}.trimmed.fastq.gz \
        ILLUMINACLIP:${params.adapter_fa}:2:30:10 \
        LEADING:3 TRAILING:3 \
        2>${sample_id}.log
    """

    stub:
    """
    touch ${sample_id}_stub_trim.log
    touch ${sample_id}_stub_trimmed.fastq.gz
    """
}