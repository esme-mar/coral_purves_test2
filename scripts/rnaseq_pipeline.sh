# download files from SRA, run fastqc, trim reads,

# set working directory
 cd /data/mcfadden/aquattrini/PROGRAMS/sratoolkit.3.0.2-ubuntu64/bin

 ./fasterq-dump SRR9648437 -O /data/mcfadden/smoaleman/esme/sra_data 

 #run fastqc
 fastqc -t 12 sra_data/*.fastq -o /data/mcfadden/smoaleman/esme/sra_data
 
 #didn't work: fastqc -t 12 sra_data/*.fastq -o /sra_data

 #download *fastqc.zip files to home desktop 
scp smoaleman@purves.cs.hmc.edu:/data/mcfadden/smoaleman/esme/sra_data/SRR9648437_*_fastqc.zip 
~/Desktop
# SRR9648437_*_fastqc didn't work, had to put _1_ and _2_


#mkdir trimmed_reads

gz *fastq

# run trimmomatic to trim reads with poor quality #run in sra_dat directory
nohup java -jar /data/mcfadden/aquattrini/PROGRAMS/trimmomatic-0.35/trimmomatic-0.35.jar PE -threads 4 SRR9648437_1.fastq.gz SRR9648437_2.fastq.gz 
/data/mcfadden/smoaleman/esme/trimmed_reads/SRR9648437_R1_PE_trimmed.fastq.gz /data/mcfadden/smoaleman/esme/trimmed_reads/SRR9648437_R1_SE_trimmed.fastq.gz 
/data/mcfadden/smoaleman/esme/trimmed_reads/SRR9648437_R2_PE_trimmed.fastq.gz /data/mcfadden/smoaleman/esme/trimmed_reads/SRR9648437_R2_SE_trimmed.fastq.gz 
ILLUMINACLIP:/data/mcfadden/smoaleman/esme/TruSeq3-PE-2.fa:2:30:10:2:keepBothReads LEADING:3 TRAILING:3 SLIDINGWINDOW:4:20 MINLENGTH:36 

echo "Trimmomatic finished running!"

## for multiple SRAs downloaded in file SRR_Acc_List.txt 
# (cat SRR_Acc_List.txt | parallel -j 4 "trimmomatic PE -threads 4 -trimlog trimmedReads/{}trimming.log sra_data/{}_1.fastq sra_data/{}_2.fastq -baseout
# trimmed_reads/SRR968437 ILLUMINACLIP:TruSeq3-PE-2.fa:2:30:10:2:keepBothReads LEADING:3 TRAILING:3 SLIDINGWINDOW:4:20 MINLENGTH:36"

 
/data/mcfadden/smoaleman/esme/sra_data/*.fastq /data/mcfadden/smoaleman/esme/trimmed_reads

fastqc /data/mcfadden/smoaleman/esme/trimmed_reads -o #provide output directory
