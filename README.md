# Illumina NextSeq Pipeline
Workflow for merging multi-lane fastq files from the Illumina NextSeq 550 using Snakemake. In addition, basic QC and md5 checksums are generated.

## Requirement
- Linux (tested on Debian 9.13)
- Snakemake
- Python 3.5+ 
- FastQC and MultiQC

## General Information
When a NextSeq 550 sequencing run is completed the FASTQ files are located in "<run folder>\Alignment_1\<subfolder>\Fastq". For each sample the sequencer generates fastq files per lane and read orientation. The fastq files are stored initially in this format ("*_S[1-8]_L00[1-4]_R[1-2]_001.fastq.gz"). After merging the fastq files the Illumina-specific sample and lane information will be discarded. The output of the merged fastq files will be stored in a directory called "unaligned" with the corresponding QC and checksums. The resulting directory structure is highlighted here:

```bash
221214_NB442557_0103_AH4v22BGXN
├── SampleSheet.csv
├── Alignment_1
│   └── 20221215_184340
│       └── Fastq
│           ├── sample1_S1_L001_R1_001.fastq.gz
│           ├── sample1_S1_L001_R2_001.fastq.gz
│           ├── sample1_S1_L002_R1_001.fastq.gz
│           ├── sample1_S1_L002_R2_001.fastq.gz
│           ├── sample1_S1_L003_R1_001.fastq.gz
│           ├── sample1_S1_L003_R2_001.fastq.gz
│           ├── sample1_S1_L004_R1_001.fastq.gz
│           └── sample1_S1_L004_R2_001.fastq.gz
├── unaligned
│   ├── sample1_1.fq.gz
│   ├── sample1_2.fq.gz
│   ├── multiqc_report.html
│   └── md5sum.txt
```

## Usage

1. Clone the repository into the runfolder:

    ```bash
    git clone https://github.com/GenoMixer/NextSeq-RawData-Merge.git
    ```

2. Activate the snakemake environment with FastQC and MultiQC:

    ```bash
    conda activate snakemake
    ```

3. Start a dry run (-n) and estimate the numbers of jobs provided by snakemake:

    ```bash
    snakemake -n
    ```

4. Start real execution with estimated numbers of jobs that can be run in parallel (-j XXX):

    ```bash
    snakemake -j XXX 
    ```
