#!/bin/bash

## run command:
# for x in `/bin/ls *deduplicated.bam` ; do bash methylation_extractor.sh $x; done

## add required modules
module add bismark
module add samtools

## set variable names
BAMFILE=`echo $1`
name=`basename $1 .deduplicated.bam`
GENOMEfolder=/srv/gsfs0/projects/snyder/chappell/Annotations/UCSC-hg19/WholeGenomeFasta/

## write a tempscript to be looped over
cat > $name.tempscript.sh << EOF
#!/bin/bash
#$ -N $name.methylation_extractor
#$ -j y
#$ -cwd
#$ -V
#$ -l h_vmem=4G
#$ -pe shm 12
#$ -l h_rt=5:59:00
#$ -l s_rt=5:59:00

echo "STARTING methylation_extractor"
bismark_methylation_extractor --paired-end --no_overlap --report --bedGraph \
--buffer_size 10G --no_header --cytosine_report --merge_non_CpG --genome_folder \
$GENOMEfolder $BAMFILE
EOF

## qsub then remove the tempscript & useless zipfile
qsub $name.tempscript.sh 
sleep 1
# rm $name.tempscript.sh
