# NextSeq-RawData-Merge
Workflow for merging multi-lane sample-wise raw data from the Illumina NextSeq 550 using Snakemake. In addition, basic QC is applied and md5 checksums are generated.

## Requirement
- Unix (tested on Debian)
- Snakemake
- Python 3.5+
- FastQC and MultiQC available via conda 

## Directory Structure
When a NextSeq 550 sequencing run is completed the FASTQ files are located in "<run folder>\Alignment_1\<subfolder>\Fastq". For each sample the sequenceer generates overall 8 fastq files for each lane and read pair in case of paired end data ("*_L00[1-4]_R[1,2]_001.fastq.gz"). 

221127_NB442557_0103_AH4v22BGXN  \
└──SampleSheet.csv  \
└── Alignment_1    \
&nbsp;&nbsp; └── 20221215_184340   \
&nbsp;&nbsp;&nbsp;&nbsp; └── Fastq 
        
## Usage

1. Clone the repository:

    ```bash
    git clone https://github.com/GenoMixer/NextSeq-RawData-Merge.git
    ```

2. Activate the snakemake environemnt with FastQC and MultiQC:

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
