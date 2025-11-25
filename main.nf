// Include your modules here
include {FASTQC} from './modules/fastqc'
include {TRIM} from './modules/trimmomatic'
include {BOWTIE2_BUILD} from './modules/bowtie2_build'
include {BOWTIE2_ALIGN} from './modules/bowtie2_align'
include {SAMTOOLS_SORT} from './modules/samtools_sort'
include {SAMTOOLS_IDX} from './modules/samtools_idx'
include {BAMCOVERAGE} from './modules/deeptools_bamcoverage'
include {SAMTOOLS_FLAGSTAT} from './modules/samtools_flagstat'
include {MULTIQC} from './modules/multiqc'
include {COMPUTEMATRIX} from './modules/deeptools_computematrix'
include {PLOTPROFILE} from './modules/deeptools_plotprofile'
include {MULTIBWSUMMARY} from './modules/deeptools_multibwsummary'
include {PLOTCORRELATION} from './modules/deeptools_plotcorrelation'
include {TAGDIR} from './modules/homer_maketagdir'
include {FINDPEAKS} from './modules/homer_findpeaks'
include {POS2BED} from './modules/homer_pos2bed'
include {BEDTOOLS_INTERSECT} from './modules/bedtools_intersect'
include {BEDTOOLS_REMOVE} from './modules/bedtools_remove'
include {ANNOTATE} from './modules/homer_annotatepeaks'
include {FIND_MOTIFS_GENOME} from './modules/homer_findmotifsgenome'


workflow {
    
    Channel.fromPath(params.samplesheet)
    | splitCsv( header: true )
    | map{ row -> tuple(row.name, file(row.path)) }
    | set { read_ch }

    FASTQC(read_ch)
    TRIM(read_ch)

    BOWTIE2_BUILD(params.genome)
    BOWTIE2_ALIGN(TRIM.out.trimmed_reads, BOWTIE2_BUILD.out.index, BOWTIE2_BUILD.out.name)
    
    TAGDIR(BOWTIE2_ALIGN.out.bam)

    TAGDIR.out.tagdir
    | map { name, path -> tuple(name.split('_')[1], [(path.baseName.split('_')[0]): path]) }
    | groupTuple(by: 0)
    | map { rep, maps -> tuple(rep, maps[0] + maps[1]) }
    | map { rep, samples -> tuple(rep, samples.IP, samples.INPUT) }
    | set { peakcalling_ch }

    FINDPEAKS(peakcalling_ch)

    SAMTOOLS_FLAGSTAT(BOWTIE2_ALIGN.out.bam)

    TRIM.out.log.map{ it[1] }.concat(FASTQC.out.zip.map{ it[1] }, SAMTOOLS_FLAGSTAT.out.flagstat.map{ it[1] }).collect()
    | set { multiqc_ch }
    MULTIQC(multiqc_ch)

    SAMTOOLS_SORT(BOWTIE2_ALIGN.out.bam)
    SAMTOOLS_IDX(SAMTOOLS_SORT.out.sorted)
    
    BAMCOVERAGE(SAMTOOLS_IDX.out)

    bigwig_files_ch = BAMCOVERAGE.out.map { it[1] }.collect()
    sample_labels_ch = BAMCOVERAGE.out.map { it[0] }.collect()

    MULTIBWSUMMARY(bigwig_files_ch)
    PLOTCORRELATION(MULTIBWSUMMARY.out.npz, sample_labels_ch, params.corrtype)
    
    POS2BED(FINDPEAKS.out.peaks)

    bed_files = POS2BED.out.peaks_bed
        .collect()
        .map { files -> tuple("combined", files) }
    
    BEDTOOLS_INTERSECT(bed_files)

    repr_peaks = BEDTOOLS_INTERSECT.out
        .map { bed -> tuple("combined", bed) }
    
    BEDTOOLS_REMOVE(repr_peaks, params.blacklist)

    ANNOTATE(BEDTOOLS_REMOVE.out, params.gtf, params.genome)

    FIND_MOTIFS_GENOME(BEDTOOLS_REMOVE.out, params.genome)

    ip_bigwigs = BAMCOVERAGE.out
        .filter { sample_id, bw -> sample_id.startsWith('IP_') }

    COMPUTEMATRIX(ip_bigwigs, params.ucsc_genes, params.window)

    PLOTPROFILE(COMPUTEMATRIX.out.matrix)

}