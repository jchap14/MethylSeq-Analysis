#!/bin/bash
#### Note that adaptors should be trimmed with trimGalore first
#### Also, bt2 indexes may cause an issue if diff version than built previously

## run command:
## for x in `/bin/ls *trim.R1.fq.gz` ; do bash bismark_scoreMin.sh $x; done

## add required modules
module add bismark
module add bowtie
module add samtools

## set variable names
read1=`echo $1`
name=`basename $1 .trim.R1.fq.gz`

## write a tempscript to be looped over
cat > $name.tempscript.sh << EOF
#!/bin/bash
#$ -cwd
#$ -V
#$ -l h_vmem=1G
#$ -pe shm 12
#$ -l h_rt=5:59:00
#$ -l s_rt=5:59:00
#$ -N $name.bisScoreMin

echo "STARTING BISMARK"
## USAGE: bismark [options] <genome_folder> {-1 <mates1> -2 <mates2> | <singles>}

bismark -N 1 -L 20 --score_min L,0,-0.6 --maxins 1000 -p 12 /srv/gsfs0/projects/snyder/chappell/Annotations/GENCODE-v19-GRCh37-hg19/ \
-1 $read1 -2 $name.trim.R2.fq.gz
EOF

## qsub then remove the tempscript & useless zipfile
qsub $name.tempscript.sh 
sleep 1
rm $name.tempscript.sh

