# download files from SRA, run fastqc, trim reads with trimmomatic

# set working directory
 cd /data/mcfadden/aquattrini/PROGRAMS/sratoolkit.3.0.2-ubuntu64/bin

 ./fasterq-dump --split-files SRR9648437 -O /data/mcfadden/smoaleman/esme/sra_data 

#try fastq-dump to see if files will be compatible for Trinity

./fastq-dump --defline-seq '@$sn[_$rn]/$ri' --defline-qual '+$sn[_$rn]/$ri' --split-files SRR9648437 -O /data/mcfadden/smoaleman/esme/sra_data2
 #change directory,run fastqc
 cd /data/mcfadden/smoaleman/esme
 
 gzip *fastq
 
 fastqc -t 12 sra_data/*.fastq.gz -o /data/mcfadden/smoaleman/esme/sra_data
 
 #didn't work: fastqc -t 12 sra_data/*.fastq -o /sra_data

 #download *fastqc.zip files to home desktop 
scp smoaleman@purves.cs.hmc.edu:/data/mcfadden/smoaleman/esme/sra_data/SRR9648437*fastqc.zip 
~/Desktop

#mkdir trimmed_reads

cd /data/mcfadden/smoaleman/esme/sra_data
# run trimmomatic to trim reads with poor quality #run in sra_dat directory
nohup java -jar /data/mcfadden/aquattrini/PROGRAMS/Trimmomatic-0.35/trimmomatic-0.35.jar PE -threads 12 SRR14577702_1.fastq.gz SRR14577702_2.fastq.gz /data/mcfadden/smoaleman/esme/trimmed_reads2/SRR14577702_R1_PE_trimmed.fastq.gz /data/mcfadden/smoaleman/esme/trimmed_reads2/SRR14577699_R1_SE_trimmed.fastq.gz /data/mcfadden/smoaleman/esme/trimmed_reads2/SRR14577702_R2_PE_trimmed.fastq.gz /data/mcfadden/smoaleman/esme/trimmed_reads2/SRR14577702_R2_SE_trimmed.fastq.gz ILLUMINACLIP:/data/mcfadden/smoaleman/esme/TruSeq3-PE-2.fa:2:30:10:2:keepBothReads LEADING:3 TRAILING:3 SLIDINGWINDOW:4:20 MINLEN:36 

#cat SRR_Acc_list.txt | java -jar /data/mcfadden/aquattrini/PROGRAMS/Trimmomatic-0.35/trimmomatic-0.35.jar PE -threads 4 {}_1.fastq.gz {}_2.fastq.gz 
#/data/mcfadden/smoaleman/esme/trimmed_reads/{}_R1_PE_trimmed.fastq.gz /data/mcfadden/smoaleman/esme/trimmed_reads/{}_R1_SE_trimmed.fastq.gz 
#/data/mcfadden/smoaleman/esme/trimmed_reads/{}_R2_PE_trimmed.fastq.gz /data/mcfadden/smoaleman/esme/trimmed_reads/{}_R2_SE_trimmed.fastq.gz 
#ILLUMINACLIP:/data/mcfadden/smoaleman/esme/TruSeq3-PE-2.fa:2:30:10:2:keepBothReads LEADING:3 TRAILING:3 SLIDINGWINDOW:4:20 MINLEN:36 


## for multiple SRAs downloaded in file SRR_Acc_List.txt 
# (cat SRR_Acc_List.txt | parallel -j 4 "trimmomatic PE -threads 4 -trimlog trimmedReads/{}trimming.log sra_data/{}_1.fastq sra_data/{}_2.fastq -baseout
# trimmed_reads/SRR968437 ILLUMINACLIP:TruSeq3-PE-2.fa:2:30:10:2:keepBothReads LEADING:3 TRAILING:3 SLIDINGWINDOW:4:20 MINLENGTH:36"

 
#rerun fastqc to check quality of trimmed reads

fastqc /data/mcfadden/smoaleman/esme/trimmed_reads/SRR9648437*.fastq.gz -o /data/mcfadden/smoaleman/esme/trimmed_reads #provide output directory

scp smoaleman@purves.cs.hmc.edu:/data/mcfadden/smoaleman/esme/trimmed_reads/*fastqc.zip ~/Desktop


# TRINITY
 Trinity --seqType fq --left reads_1.fq --right reads_2.fq --CPU 6 --max_memory 20G 
 
 /data/mcfadden/aquattrini/PROGRAMS/trinityrnaseq-Trinity-v2.4.0/Trinity --seqType fq --SS_lib_type RF --left /data/mcfadden/smoaleman/esme/trimmed_reads2/SRR14577702_1.fastq.gz --right /data/mcfadden/smoaleman/esme/trimmed_reads2/SRR14577702.fastq.gz --CPU 12 --max_memory 20G

