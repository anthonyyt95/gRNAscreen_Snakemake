# MAGeCK Preprocessing Pipeline

A Snakemake workflow to trim adapters, align reads, and count guides for MAGeCK.

## Requirements
- Snakemake ≥5.0  
- Bowtie2  
- Cutadapt  
- Python 3  

## Structure
.  
├── Snakefile  
├── samples.txt  
├── samples/.fastq  
├── trimmed/TRIMMED_.fastq  
└── output/  
├── aligned_.sam  
├── unaligned_.sam  
├── Log_.log  
└── counts/.counts.txt  


## Configuration
Edit `indexLoc = "C2"` in the Snakefile and set `BOWTIE2_INDEXES` to your Bowtie2 index directory.

## Usage
```bash

#!/bin/bash
#SBATCH -p cpu_medium
#SBATCH -n 2
#SBATCH --mem-per-cpu=32G
#SBATCH --time=10:00:00
#SBATCH --output=job.out
#SBATCH --error=job.err

srun snakemake
```

## Rules
cutadapt → samples/*.fastq → trimmed/TRIMMED_*.fastq  

bowtie → trimmed/TRIMMED_*.fastq → aligned_*.sam + unaligned_*.sam + Log_*.  log

counts → aligned_*.sam → counts/*.counts.txt  

## Output
Adapter‐trimmed FASTQ (trimmed/)  

Aligned & unaligned SAMs (output/)  

Per‐guide counts (output/counts/)  
