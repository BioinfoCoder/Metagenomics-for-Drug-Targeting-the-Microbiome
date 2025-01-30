#!/bin/bash

# Define a log file for the installation process
LOG_FILE="installation_log.txt"

# Function to check if a tool is already installed
check_installed() {
    command -v $1 >/dev/null 2>&1
}

# Function to install Bowtie2 (for read alignment to a reference genome)
install_bowtie2() {
    echo "Installing Bowtie2..."
    if ! check_installed bowtie2; then
        # Bowtie2 is a fast and memory-efficient tool for aligning sequencing reads to a reference genome.
        wget https://github.com/BenLangmead/bowtie2/releases/download/v2.4.5/bowtie2-2.4.5-linux-x86_64.tar.gz -O bowtie2.tar.gz
        tar -zxvf bowtie2.tar.gz
        sudo mv bowtie2-2.4.5-linux-x86_64 /opt/bowtie2
        sudo ln -s /opt/bowtie2/bowtie2 /usr/local/bin/bowtie2
        echo "Bowtie2 installation completed!" >> $LOG_FILE
    else
        echo "Bowtie2 is already installed."
    fi
}

# Function to install FastQC (for quality control of sequencing reads)
install_fastqc() {
    echo "Installing FastQC..."
    if ! check_installed fastqc; then
        # FastQC is used for performing quality control on raw sequence data, allowing quick assessment of sequencing quality.
        wget https://github.com/s-andrews/FastQC/releases/download/0.11.9/fastqc_v0.11.9.zip -O fastqc.zip
        unzip fastqc.zip
        sudo mv FastQC /opt/fastqc
        sudo ln -s /opt/fastqc/fastqc /usr/local/bin/fastqc
        echo "FastQC installation completed!" >> $LOG_FILE
    else
        echo "FastQC is already installed."
    fi
}

# Function to install Trimmomatic (for trimming low-quality or adapter sequences from reads)
install_trimmomatic() {
    echo "Installing Trimmomatic..."
    if ! check_installed java; then
        # Java is required for Trimmomatic, which is a tool for trimming and cleaning sequencing reads.
        sudo apt install -y default-jre || sudo yum install -y java-1.8.0-openjdk
        echo "Java is installed."
    fi
    if ! check_installed trimmomatic; then
        # Trimmomatic is used for trimming low-quality or adapter sequences from raw reads to improve the quality of input data for downstream analysis.
        wget http://www.usadellab.org/cms/uploads/supplementary/Trimmomatic/trimmomatic-0.39.jar -O trimmomatic.jar
        sudo mv trimmomatic.jar /opt/trimmomatic/
        echo "Trimmomatic installation completed!" >> $LOG_FILE
    else
        echo "Trimmomatic is already installed."
    fi
}

# Function to install SPAdes (for genome assembly from short reads)
install_spades() {
    echo "Installing SPAdes..."
    if ! check_installed spades.py; then
        # SPAdes is a popular genome assembler used for assembling short-read sequencing data into complete genomes.
        wget https://github.com/ablab/spades/releases/download/v3.15.4/SPAdes-3.15.4-Linux.tar.gz -O spades.tar.gz
        tar -zxvf spades.tar.gz
        sudo mv SPAdes-3.15.4-Linux /opt/spades
        sudo ln -s /opt/spades/spades.py /usr/local/bin/spades.py
        echo "SPAdes installation completed!" >> $LOG_FILE
    else
        echo "SPAdes is already installed."
    fi
}

# Function to install Prokka (for functional annotation of bacterial genomes)
install_prokka() {
    echo "Installing Prokka..."
    if ! check_installed prokka; then
        # Prokka is used for annotating prokaryotic genomes with genes, rRNA, tRNA, and other features.
        wget https://github.com/tseemann/prokka/releases/download/v1.14.6/prokka-1.14.6-linux-x86_64.tar.gz -O prokka.tar.gz
        tar -zxvf prokka.tar.gz
        sudo mv prokka-1.14.6-linux-x86_64 /opt/prokka
        sudo ln -s /opt/prokka/prokka /usr/local/bin/prokka
        echo "Prokka installation completed!" >> $LOG_FILE
    else
        echo "Prokka is already installed."
    fi
}

# Function to install MetaPhlAn (for profiling microbial communities)
install_metaphlan() {
    echo "Installing MetaPhlAn..."
    if ! check_installed metaphlan; then
        # MetaPhlAn is used to profile the composition of microbial communities from metagenomic data.
        pip install metaphlan
        echo "MetaPhlAn installation completed!" >> $LOG_FILE
    else
        echo "MetaPhlAn is already installed."
    fi
}


# Install all the tools
install_bowtie2
install_fastqc
install_trimmomatic
install_spades
install_prokka
install_metaphlan

# Print completion message
echo "All tools have been checked and installed as needed." | tee -a $LOG_FILE
