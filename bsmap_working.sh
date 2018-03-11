#!/bin/bash
#### Note that adaptors should be trimmed with trimGalore first

## run command:
## for x in `/bin/ls *trim.R1.fq.gz` ; do bash bsmap_working.sh $x; done

## add required modules
module add bsmap
module add samtools


## set variable names
FASTQ1=`echo $1`
name=`basename $1 .trim.R1.fq.gz`
REFERENCE_GENOME=/srv/gsfs0/projects/snyder/chappell/Annotations/UCSC-hg19/WholeGenomeFasta/genome.fa

## write a tempscript to be looped over
cat > $name.tempscript.sh << EOF
#!/bin/bash
#$ -cwd
#$ -V
#$ -l h_vmem=4G
#$ -pe shm 8
#$ -l h_rt=11:59:00
#$ -l s_rt=11:59:00
#$ -N $name.bsmap

echo "STARTING bsmap"
## USAGE: bismark [options] <genome_folder> {-1 <mates1> -2 <mates2> | <singles>}
bsmap -a $FASTQ1 -b $name.trim.R2.fq.gz -d ${REFERENCE_GENOME} -o $name.bam -p 8 -R -m 101
EOF

## qsub then remove the tempscript & useless zipfile
qsub $name.tempscript.sh 
sleep 1
rm $name.tempscript.sh
