##### Check breadth and depth of coverage for methylseq

# for x in `/bin/ls *.bam` ; do bash methylSeq_coverage_bedtools.sh $x; done

## add modules
module add bedtools/2.16.2

## define variables
BAMFILE=$1
TARGETBED="/srv/gsfs0/projects/snyder/chappell/Annotations/hg19_methylSeq_padded_regions.bed"
NAME=`basename $1 .deduplicated.bam`

cat > /tmp/tempscript.sh << EOF
#!/bin/bash
#$ -N $NAME.coverage
#$ -j y
#$ -cwd
#$ -V
#$ -l h_vmem=6G
#$ -pe shm 4
#$ -l h_rt=11:59:00
#$ -l s_rt=11:59:00

## run commands
##usage: coverageBed [OPTIONS] -a <BED/GFF/VCF> -b <BED/GFF/VCF>
bedtools coverage -hist -abam $BAMFILE -b $TARGETBED | grep ^all > $NAME.bam.hist.all.txt
EOF
qsub /tmp/tempscript.sh
sleep 1
rm /tmp/tempscript.sh

##### test command: use bedtools version 2.16.2
# bamfile="M4.trim.R1.markdup.realigned.bam"
# name=`basename $bamfile .trim.R1.markdup.realigned.bam`
# bedtools coverage -hist -abam $bamfile -b clinical_exome_targets.bed | grep ^all > $name.bam.hist.all.txt
# 
# bamfile="MC.trim.R1.markdup.realigned.bam"
# name=`basename $bamfile .trim.R1.markdup.realigned.bam`
# bedtools coverage -hist -abam $bamfile -b clinical_exome_targets.bed | grep ^all > $name.bam.hist.all.txt
# 
# bamfile="P4.trim.R1.markdup.realigned.bam"
# name=`basename $bamfile .trim.R1.markdup.realigned.bam`
# bedtools coverage -hist -abam $bamfile -b clinical_exome_targets.bed | grep ^all > $name.bam.hist.all.txt
# 
# bamfile="PC.trim.R1.markdup.realigned.bam"
# name=`basename $bamfile .trim.R1.markdup.realigned.bam`
# bedtools coverage -hist -abam $bamfile -b clinical_exome_targets.bed | grep ^all > $name.bam.hist.all.txt
# 
# bamfile="FC.trim.R1.markdup.realigned.bam"
# name=`basename $bamfile .trim.R1.markdup.realigned.bam`
# bedtools coverage -hist -abam $bamfile -b clinical_exome_targets.bed | grep ^all > $name.bam.hist.all.txt
# 
# bamfile="F1.trim.R1.markdup.realigned.bam"
# name=`basename $bamfile .trim.R1.markdup.realigned.bam`
# bedtools coverage -hist -abam $bamfile -b clinical_exome_targets.bed | grep ^all > $name.bam.hist.all.txt