#!/bin/bash

# Set variables for file paths and directories
RAW_R1="test_sample_R1.fastq"
RAW_R2="test_sample_R2.fastq"
HOST_GENOME="Homo_sapiens.GRCh38.dna.alt.fa"
HOST_INDEX="host_index"
OUTPUT_DIR="output"
FASTQC_DIR="fastqc_output"
TRIMMED_R1="trimmed_R1.fastq"
TRIMMED_R2="trimmed_R2.fastq"
UNPAIRED_R1="unpaired_R1.fastq"
UNPAIRED_R2="unpaired_R2.fastq"
INPUT_R1="output/cleaned_reads.1.fastq"
INPUT_R2="output/cleaned_reads.2.fastq"
OUTPUT="metaphlan_output.txt"
BOWTIE2_DB="/home/doaa/miniconda3/lib/python3.11/site-packages/metaphlan/metaphlan_databases/"
SPADES_OUTPUT_R1="spades_output_R1"
SPADES_OUTPUT_R2="spades_output_R2"
ANNOTATION_DIR_R1="annotation_R1"
ANNOTATION_DIR_R2="annotation_R2"
PROKKA_PREFIX_R1="my_bacterium_R1"
PROKKA_PREFIX_R2="my_bacterium_R2"

Step 1: Quality Control using FastQC
#echo "Running FastQC for quality control on raw reads..."
mkdir -p $FASTQC_DIR
fastqc $RAW_R1 $RAW_R2 -o $FASTQC_DIR

# Step 2: Read Trimming using Trimmomatic
# echo "Trimming low-quality reads and adapters using Trimmomatic..."
 trimmomatic PE -phred33 \
$RAW_R1 $RAW_R2 \
$TRIMMED_R1 $UNPAIRED_R1 \
$TRIMMED_R2 $UNPAIRED_R2 \
SLIDINGWINDOW:4:15 MINLEN:40

# Step 3: Host Genome Removal with Bowtie2
# echo "Building Bowtie2 index for the host genome..."
bowtie2-build $HOST_GENOME $HOST_INDEX

# Create the output directory if it doesn't exist
mkdir -p $OUTPUT_DIR


#echo "Aligning trimmed reads to the host genome and retrieving unaligned reads..."
bowtie2 -x $HOST_INDEX -1 $TRIMMED_R1 -2 $TRIMMED_R2 \
  --un-conc $OUTPUT_DIR/cleaned_reads.fastq \
  -S $OUTPUT_DIR/output.sam

#echo "Downloading MetaPhlAn database..."
aria2c -x 16 -d /home/doaa/miniconda3/lib/python3.11/site-packages/metaphlan/metaphlan_databases/ \
http://cmprod1.cibio.unitn.it/biobakery4/metaphlan_databases/bowtie2_indexes/mpa_vJun23_CHOCOPhlAnSGB_202403_bt2.tar

# Run MetaPhlAn with trimmed R1 and R2 fastq files and install it 
metaphlan $INPUT_R1,$INPUT_R2 \
    --input_type fastq \
    --bowtie2db /home/doaa/Metagenomics_workshop/creative_sucesss/ \
    -o $OUTPUT


# Step 5: De Novo Assembly using SPAdes
#echo "Running SPAdes to assemble paired reads into contigs..."
spades.py --memory 30 -s $INPUT_R1 -o $SPADES_OUTPUT_R1
spades.py --memory 30 -s $INPUT_R2  -o $SPADES_OUTPUT_R2


# Step 7: Genome Annotation using Prokka
#echo "Annotating contigs from R1 assembly using Prokka..."
prokka $SPADES_OUTPUT_R1/contigs.fasta --outdir $ANNOTATION_DIR_R1 --prefix $PROKKA_PREFIX_R1

#echo "Annotating contigs from R2 assembly using Prokka..."
prokka $SPADES_OUTPUT_R2/contigs.fasta --outdir $ANNOTATION_DIR_R2 --prefix $PROKKA_PREFIX_R2




echo "Workflow completed successfully!


