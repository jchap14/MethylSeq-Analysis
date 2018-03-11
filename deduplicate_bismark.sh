#!/bin/bash

## run command (if sam.gz):
## for x in `/bin/ls *pe.sam.gz` ; do bash deduplicate_bismark.sh $x; done

## run command (if bam):
## for x in `/bin/ls *.bam` ; do bash deduplicate_bismark.sh $x; done

## add required modules
module add bismark
module add samtools

## set variable names
BAMFILE=`echo $1`
name=`basename $1 .bam`

## write a tempscript to be looped over
cat > $name.tempscript.sh << EOF
#!/bin/bash
#$ -N $name.dedup_bismark
#$ -j y
#$ -cwd
#$ -V
#$ -l h_vmem=4G
#$ -pe shm 12
#$ -l h_rt=11:59:00
#$ -l s_rt=11:59:00

echo "STARTING dedup BISMARK"
## USAGE: deduplicate_bismark --paired [options] filename(s)
deduplicate_bismark --paired --bam $BAMFILE
rm $BAMFILE
EOF

## qsub then remove the tempscript & useless zipfile
qsub $name.tempscript.sh 
sleep 1
rm $name.tempscript.sh
