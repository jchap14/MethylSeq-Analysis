#!/bin/bash
#### Note that adaptors should be trimmed with trimGalore first

## run command:
## for x in `/bin/ls *trim.R1.fq.gz` ; do bash bismark.sh $x; done

## add required modules
module add bismark
module add bowtie

## set variable names
read1=`echo $1`
name=`basename $1 .trim.R1.fq.gz`

## write a tempscript to be looped over
cat > $name.tempscript.sh << EOF
#!/bin/bash
#$ -cwd
#$ -V
#$ -l h_vmem=8G
#$ -pe shm 4
#$ -l h_rt=47:59:00
#$ -l s_rt=47:59:00
#$ -N $name.bismark

echo "STARTING BISMARK"
## USAGE: bismark [options] <genome_folder> {-1 <mates1> -2 <mates2> | <singles>}

bismark -N 1 -L 20 -p 4 /srv/gsfs0/projects/snyder/chappell/Annotations/UCSC-hg19/WholeGenomeFasta/ \
-1 $read1 -2 $name.trim.R2.fq.gz
mv $name.trim.R1_bismark_bt2_pe.bam $name.bam
EOF

## qsub then remove the tempscript & useless zipfile
qsub $name.tempscript.sh 
sleep 1
rm $name.tempscript.sh
