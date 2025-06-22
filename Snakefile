import pandas as pd
import numpy as np
import os


indexLoc="C2"
files=list()

with open('samples.txt') as f:
	mylist = f.read().splitlines()
	for element in mylist:
		if element.endswith('.fastq'):
			files.append(element[:-6])
          
rule all:
        input:  
                expand("output/unaligned_{filename}.sam",filename=files),
                expand("output/counts/{filename}.counts.txt",filename=files),
                expand("trimmed/TRIMMED_{filename}.fastq",filename=files)

rule counts:
	input:
		samFile="output/aligned_{filename}.sam"
	output:
		countsFile="output/counts/{filename}.counts.txt"
	shell:
		"cut -f 3 {input.samFile} | sort | uniq -c > {output.countsFile}"

rule bowtie:
        input:  
                read="trimmed/TRIMMED_{filename}.fastq"
        output: 
                unaligned="output/unaligned_{filename}.sam",
                aligned="output/aligned_{filename}.sam",
		log="output/Log_{filename}.log"
        params: 
                index=indexLoc
	shell:  
                '''
                export BOWTIE2_INDEXES=/gpfs/data/feskelab/TonyTao/Documents/Projects/colitisC2Screen/libraryRef
                bowtie2 --local --score-min G,3,7  -x {params.index} -U {input.read} -S {output.aligned} --un {output.unaligned} 2> {output.log}
                '''

rule cutadapt:
	input:
		read="samples/{filename}.fastq"
	output:
		trimmed="trimmed/TRIMMED_{filename}.fastq"
	shell:
		"cutadapt -g GAAAAGCCTTGTTTG {input.read} -e 0.2 | cutadapt -a GTTTTAGCGCTAGGATACTA -e 0.2 -> {output.trimmed}"
                


