#### Project Description
Developed a full bioinformatics pipeline for a real-world dataset, focusing on the principles of reproducibility and portability. The publication completed chromatin immunoprecipitation followed by sequencing (ChIPseq). This project generated an end-to-end pipeline to replicate the experiment and recreated some of their key figures.


#### Introduction
The biological background of this study is studying the transcription factor RUNX1 and its roles in development and cancer. RUNX1 acts as either an oncogene or tumor suppressor and has been implicated in shaping chromatin structure, enhancer-promoter communication, and genome interactions. Breast cancer is characterized by alterations in higher-order chromatin organization, so understanding RUNX1's role in breast cancer is important. This study was performed to understand how RUNX1 affects the structure of the genome in breast cancer cells and how these changes are linked to changes in gene expression. The authors used bioinformatics techniques like RNA-seq, ChIP-seq, and Hi-C in this experiment. RNA-seq was used to identify changes in gene expression following RUNX1 depletion, ChIP-seq was used to map RUNX1 binding sites and identify where this TF interacts with chromatin, and Hi-C was used to measure 3D chromatic structure when RUNX1 was depleted.

Citation: Barutcu AR, Hong D, Lajoie BR, McCord RP, van Wijnen AJ, Lian JB, Stein JL, Dekker J, Imbalzano AN, Stein GS. RUNX1 contributes to higher-order chromatin organization and gene regulation in breast cancer cells. Biochim Biophys Acta. 2016 Nov;1859(11):1389-1397. doi: 10.1016/j.bbagrm.2016.08.003. Epub 2016 Aug 9. PMID: 27514584; PMCID: PMC5071180.


#### Deliverables
1. main.nf (Nextflow workflow)
2. README.md (Introduction)
3. ChIP-seq_Report.ipynb (Methods, Discussion, and Figure Reproduction)