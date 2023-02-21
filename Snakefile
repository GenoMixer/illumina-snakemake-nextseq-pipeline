# libraries
import os
import glob
import numpy
import pandas as pd
from pathlib import Path
from snakemake.remote.S3 import RemoteProvider as S3RemoteProvider

# working dir
WORK  = os.getcwd()
head, tail = os.path.split(WORK)
RUN = tail.split("_")[0]

# remote provider (optional)
#S3 = S3RemoteProvider()
#BUCKET = "s3://lvms-trial-xxx-varfeed/upload/"

# samples
samples=pd.read_csv("SampleSheet.csv",skiprows=16).set_index("Sample_ID")
print(samples)

# variables
READ=["1", "2"]

# functions
def get_fq1(wildcards):
        return sorted(glob.glob("Alignment_1/*/Fastq/" + wildcards.sample + "_*_L*_R1_001.fastq.gz"))

def get_fq2(wildcards):
        return sorted(glob.glob("Alignment_1/*/Fastq/" + wildcards.sample + "_*_L*_R2_001.fastq.gz"))

rule all:
    input:
         expand("unaligned/{sample}_1.fq.gz", sample=samples.index),
         expand("unaligned/{sample}_2.fq.gz", sample=samples.index),
         expand("unaligned/md5sum.txt", sample=samples.index),
         expand("unaligned/multiqc_report.html", sample=samples.index, read=READ),
#         S3.remote(os.path.join(BUCKET,RUN))

rule fq_1:
    input: get_fq1
    group: "merge"
    output: touch("unaligned/{sample}_1.fq.gz")
    shell: "zcat {input} | bgzip > {output}"

rule fq_2:
    input: get_fq2
    group: "merge"
    output: touch("unaligned/{sample}_2.fq.gz")
    shell: "zcat {input} | bgzip > {output}"

rule md5_1:
    input: rules.fq_1.output
    group: "md5"
    output: temp("unaligned/{sample}_1.md5")
    shell: "md5sum {input} > {output}"

rule md5_2:
   input: rules.fq_2.output
   group: "md5"
   output: temp("unaligned/{sample}_2.md5")
   shell: "md5sum {input} > {output}"

rule md5:
    input: expand("unaligned/{sample}_{read}.md5", sample=samples.index, read=READ)
    group: "md5"
    output: "unaligned/md5sum.txt"
    shell: "cat {input} > {output}"

rule fastqc:
    input: expand("unaligned/{sample}_{read}.fq.gz", sample=samples.index, read=READ)
    group: "qc"
    output: 
        temp("unaligned/{sample}_{read}_fastqc.zip"),
        temp("unaligned/{sample}_{read}_fastqc.html")
    shell: "fastqc {input} {output}"

rule multiqc:
     input: 
        expand("unaligned/{sample}_{read}_fastqc.html", sample=samples.index, read=READ),
        expand("unaligned/{sample}_{read}_fastqc.zip", sample=samples.index, read=READ)
     group: "qc"
     output: "unaligned/multiqc_report.html"
     shell: "multiqc -f -o unaligned {input} --no-data-dir"

#rule upload:
#     input: "unaligned"
#     group: "transfer"
#     output: S3.remote(os.path.join(BUCKET,RUN))
#     shell: "aws s3 sync {input} {output} --no-progress --endpoint-url http://s3.eu-west-1.amazonaws.com --region eu-west-1"


