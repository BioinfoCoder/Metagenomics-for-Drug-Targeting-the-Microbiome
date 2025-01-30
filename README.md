# Metagenomics for Drug Targeting the Microbiome

## Overview

This project utilizes metagenomic analysis to identify biosynthetic gene clusters (BGCs) responsible for producing bioactive compounds, such as antibiotics. By integrating taxonomic profiling, genome assembly, annotation, and functional analysis, we aim to uncover novel drug candidates like Francamicin, an antibacterial polyketide.

## Workflow

### 1. **Quality Control & Host Read Removal**

- **Input:** Raw metagenomic reads (FASTQ format)
- **Tools:** FastQC (quality check), Trimmomatic (adapter removal), Bowtie2 (host read removal)
- **Output:** High-quality reads free from host contamination

### 2. **Taxonomic Profiling**

- **Input:** Cleaned metagenomic reads
- **Tools:** MetaPhlAn (marker gene-based high-resolution profiling)
- **Output:** Taxonomic classification of microbial communities

### 3. **Metagenome Assembly**

- **Input:** Processed reads
- **Tools:** SPAdes (assembly)
- **Output:** Assembled contigs

### 4. **Metagenome Annotation**

- **Input:** Assembled contigs
- **Tools:** Prokka (annotation), COG, KEGG (functional insights)
- **Output:** Annotated genes, functional pathway insights

### 5. **BGC Identification & Functional Analysis**

- **Input:** Assembled contigs (.fasta) and Annotated genome sequence (.gff)
- **Tools:** antiSMASH (BGC prediction)
- **Output:** Predicted BGCs and functional annotations of biosynthetic genes

### 6. **3D Protein Structure & Active Site Prediction**

- **Input:** Protein sequences from BGCs
- **Tools:** UniProt, AlphaFold, Swiss-Model (homology modeling), proteins.plus  (active site prediction)
- **Output:** 3D models of key biosynthetic enzymes and active site characterization

### 7. **Linking BGCs to Therapeutic Effects**

- **Example:** Francamicin, a polyketide antibiotic, inhibits bacterial RNA polymerase, preventing transcription and bacterial proliferation.
- **Functional Insights:** Gene classification based on roles in antibiotic biosynthesis, enzymatic modifications, and regulatory pathways.

## Repository Structure

```
📂 Metagenomics-Drug-Targeting
│-- 📂 data/                  # Raw and processed metagenomic datasets
│-- 📂 scripts/               # Scripts for preprocessing, analysis, and visualization
│-- 📂 Results/               # Output files from different analysis steps
│-- 📂 Models/                # Homology models and active site predictions
│-- 📂 Extra resources/       # Presentation and extra resorces for reading 
│-- 📄 README.md              # Project documentation
│-- 📄 Requirements.txt       # Dependencies for reproducing the analysis
│-- 📄 Annotation file manipulation.txt   # Add COG and Pathway information to the annotation file
```

## Installation & Dependencies

The install.sh script will automatically install the necessary tools for metagenomics analysis.

## How to Use

1. **Run Quality Control using FastQC:**
   ```bash
   fastqc test_sample_R1.fastq test_sample_R2.fastq -o fastqc_output/
   ```
2. **Trim Reads with Trimmomatic:**
   ```bash
   trimmomatic PE -phred33 test_sample_R1.fastq test_sample_R2.fastq \
   trimmed_R1.fastq unpaired_R1.fastq \
   trimmed_R2.fastq unpaired_R2.fastq \
   SLIDINGWINDOW:4:15 MINLEN:40
   ```
3. **Remove Host Contamination with Bowtie2:**
   ```bash
   bowtie2-build Homo_sapiens.GRCh38.dna.alt.fa host_index
   bowtie2 -x host_index -1 trimmed_R1.fastq -2 trimmed_R2.fastq \
   --un-conc output/cleaned_reads.fastq -S output/output.sam
   ```
4. **Perform Taxonomic Profiling with MetaPhlAn:**
   ```bash
   metaphlan output/cleaned_reads.1.fastq,output/cleaned_reads.2.fastq \
   --input_type fastq --bowtie2db /home/doaa/Metagenomics_workshop/creative_sucesss/ \
   -o results/taxonomy_profile.tsv
   ```
5. **Assemble Metagenome with SPAdes:**
   ```bash
   spades.py --memory 30 -s output/cleaned_reads.1.fastq -o spades_output_R1
   spades.py --memory 30 -s output/cleaned_reads.2.fastq -o spades_output_R2
   ```
6. **Annotate Genome with Prokka:**
   ```bash
   prokka spades_output_R1/contigs.fasta --outdir annotation_R1 --prefix my_bacterium_R1
   prokka spades_output_R2/contigs.fasta --outdir annotation_R2 --prefix my_bacterium_R2
   ```
 
## Contributors

- **Dr. Doaa Hussein** – Metagenomics & Microbiome  Senior Bioinformatics Scientist


## License

This project is licensed under the MIT License. See `LICENSE` for details.

## References

1. Singh, B., & Roy, A. (2020). Metagenomics and Drug Discovery.
2. Jethwa, A., Bhagat, J., George, J.T., & Shah, S. (2023). Metagenomics for Drug Discovery.
3. Flory Pereira. (2019). Metagenomics: A Gateway to Drug Discovery.
4. Quince, C., Walker, A., & Simpson, J. (2017). Shotgun Metagenomics: From Sampling to Analysis.
5. Mullany, P. (2014). Functional Metagenomics for Antibiotic Resistance Investigation.
6. Garmendia, L., Hernandez, A., Sanchez, M.B., & Martinez, J.L. (2012). Metagenomics and Antibiotics.

## Contact

For any inquiries, feel free to reach out via [[doaadewedar63@gmail.com](mailto:doaadewedar63@gmail.com)] or open an issue in this repository.

