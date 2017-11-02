#$ -S /bin/sh
#!/bin/bash

module load modules modules-init modules-gs
module load python/2.7.2

REFERENCE="/path/to/human_g1k_v37.fasta"

for FAM in `cat family.ids.txt | tr '\n' ' '`;
	do
	mkdir -p /path/to/"$FAM"_platypus/
	rsync -a "$REFERENCE"* /path/to/"$FAM"_platypus/
	cd /path/to/platypus/finished_families/
	python /path/to/Platypus_0.7.8/Platypus.py callVariants -o "$FAM".platypus.vcf --refFile /path/to/"$FAM"_platypus/human_g1k_v37.fasta --bamFiles `echo /path/to/family_bams/"$FAM".*.bam | tr ' ' ','` --minReads 10 --nCPU 50 --genIndels 1 --minMapQual 20 --minBaseQual 20 --filterDuplicates 1 --genSNPs 1 --maxReads 10000000 --logFileName "$FAM".log.txt
done
