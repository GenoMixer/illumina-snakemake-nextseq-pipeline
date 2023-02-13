# NextSeq-RawData-Merge
Workflow for merging multi-lane sample-wise raw data from the Illumina NextSeq 550 using Snakemake. In addition, basic QC is applied and md5 checksums are generated.

## Requirement

- Unix (tested on Debian)
- Snakemake
- Python 3.5+
- FastQC and MultiQC available via conda 

## Directory Structure
221127_NB442557_0103_AH4v22BGXN  \
└──SampleSheet.csv  \
└── Alignment_1    \
└── 20221215_184340   \
└── Fastq 
        
## Usage

1. Clone the repository:

    ```bash
    git clone https://github.com/GenoMixer/NextSeq-RawData-Merge.git
    ```

2. Create a directory e.g. "input" to save the raw fastq files:

    ```bash
    mkdir input
    ```

3. Generate a raw data sheet with the corresponding fastq files in a format provided in the "files.tsv"

4. Generate a sample sheet with the corresponding phenotypic data in a format provided in the "samples.tsv"


5. Create symlinks to the reference data: 
    
    ```bash
    ln -s /ceph01/projects/bioinformatics_resources/Genomes/Human/GATK/b37/* library/
    ```

6. Edit the config.yml by setting the corresponding "Flowcell_ID"


7. Start the session in a screen:

    ```bash
    screen -S Flowcell_ID
    ```

8. Activate the snakemake environemnt:

    ```bash
    conda activate snakemake
    ```

9. Start a dry run (-n) and estimate the numbers of jobs provided by snakemake:

    ```bash
    snakemake --use-conda --profile slurm -k --rerun-incomplete --cluster-config cluster.yml --configfile config.yml -n
    ```

10. Start real execution with estimated numbers of jobs that can be run in parallel (-j XXX):

    ```bash
    snakemake --use-conda --profile slurm -j XXX -k --rerun-incomplete --cluster-config cluster.yml --configfile config.yml
    ```
