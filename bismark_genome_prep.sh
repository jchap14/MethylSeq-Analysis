#!/bin/bash
#
module add bismark
module add bowtie
REF_GENOME=/srv/gsfs0/projects/snyder/chappell/Annotations/UCSC-hg19/WholeGenomeFasta/
bismark_genome_preparation --path_to_bowtie /srv/gsfs0/software/bowtie/bowtie2-2.3.1/ --verbose $REF_GENOME
#
