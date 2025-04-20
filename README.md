# 🧬 Bioinformatics Pipeline: A Comprehensive Guide

This guide outlines the full pipeline for processing Next-Generation Sequencing (NGS) data—starting from system setup to variant visualization. Each step includes the required software installations and core commands.

---

## 🔧 1. System Setup

### 🖥️ Enable WSL (Windows Subsystem for Linux)

```bash
wsl --install
```
➡ Restart your computer after installation.

### 🛠️ Troubleshooting WSL: Enable Windows Features

Ensure the following Windows features are enabled:

- ✅ Virtual Machine Platform  
- ✅ Windows Hypervisor Platform  
- ✅ Windows PowerShell 2.0  
- ✅ Windows Subsystem for Linux  
- ✅ Work Folders Client  

---

## 📦 2. Install Miniconda

### 🔽 Download and Install

```bash
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
bash Miniconda3-latest-Linux-x86_64.sh
```

Follow the prompts (mostly pressing `Enter` and typing `yes`).

### 📂 Conda Environment Commands

```bash
conda create -n myenv        # Create a new environment
conda activate myenv         # Activate environment
conda deactivate             # Deactivate current environment
conda remove --name myenv --all  # Delete an environment
```

---

## 📥 3. Download SRA Data

### 🧰 Install SRA Toolkit

```bash
conda create -n sra-tools
conda activate sra-tools
conda install bioconda::sra-tools
```

### 📥 Commands to Fetch and Convert Data

```bash
prefetch SRR_ID                      # Download SRA data
fastq-dump --split-files SRR_ID      # Convert to FASTQ format
```

---

## ✅ 4. Quality Control with FastQC

### 🛠️ Install FastQC

```bash
conda create --name fastqc_env
conda activate fastqc_env
conda config --add channels bioconda
conda install fastqc
```

### 🧪 FastQC Commands

```bash
fastqc your_file.fastq
fastqc file_1.fastq file_2.fastq
fastqc *.fastq                      # Run QC on all FASTQ files
```

---

## ✂️ 5. Read Trimming

### Option A: **Trimmomatic**

```bash
conda create --name trimmomatic_env
conda activate trimmomatic_env
conda install -c bioconda trimmomatic
```

#### 📋 Commands:

- **Single-end**
```bash
trimmomatic SE input.fastq output_trimmed.fastq LEADING:3 TRAILING:3 SLIDINGWINDOW:4:20 MINLEN:36
```

- **Paired-end**
```bash
trimmomatic PE input_1.fastq input_2.fastq output_1_paired.fastq output_1_unpaired.fastq output_2_paired.fastq output_2_unpaired.fastq ILLUMINACLIP:TruSeq3-PE.fa:2:30:10:2:TRUE LEADING:3 TRAILING:3 SLIDINGWINDOW:4:20 MINLEN:36
```

---

### Option B: **FastP (with HTML/JSON reports)**

```bash
conda create --name fastp_env
conda activate fastp_env
conda install -c bioconda fastp
```

#### 📋 Commands:

- **Single-end**
```bash
fastp -i input.fastq -o output.fastq -h report.html -j report.json
```

- **Paired-end**
```bash
fastp -i input_1.fastq -I input_2.fastq -o output_1.fastq -O output_2.fastq -h fastp_report.html -j fastp_report.json
```

---

## 🧬 6. Read Mapping & Variant Calling

### 🛠️ Tools Setup

```bash
conda create --name mapping_vcf
conda activate mapping_vcf
sudo apt-get update && sudo apt-get install -y bwa samtools bcftools
```

### 🔁 Mapping Workflow

```bash
bwa index reference.fasta                          # Index reference genome
samtools faidx reference.fasta                     # Create FASTA index
bwa mem reference.fasta R1.fastq R2.fastq > aligned_reads.sam
samtools view -S -b aligned_reads.sam > aligned_reads.bam
samtools sort aligned_reads.bam -o aligned_reads_sorted.bam
samtools index aligned_reads_sorted.bam
samtools flagstat aligned_reads_sorted.bam > mapping_report.txt
```

---

### 🔍 Variant Calling with FreeBayes

```bash
conda create -n freebayes_env python=3.9 -y
conda activate freebayes_env
conda install -c bioconda freebayes

freebayes -f reference.fasta aligned_reads_sorted.bam > variants.vcf
```

---

### 🧹 VCF Processing with BCFTools

```bash
conda create -n bcftools_env
conda activate bcftools_env
conda install -c bioconda bcftools htslib

bgzip variants.vcf
bcftools index variants.vcf.gz
bcftools filter -i 'QUAL>30' variants.vcf.gz -o high_quality.vcf
bcftools stats variants.vcf.gz > stats.txt
```

---

### 🧠 Variant Annotation with SnpEff

```bash
conda create --name snpeff_env
conda activate snpeff_env
conda install -c bioconda snpeff

snpeff GRCh37.75 variants.vcf > annotated_variants.vcf
```

---

## 🔬 7. Visualization using IGV

```bash
conda create -n igv_env python=3.9 -y
conda activate igv_env
conda install -c bioconda igv

igv     # Launch IGV GUI
```

➡ Use the GUI to load your reference genome and BAM file to visually inspect aligned reads and called variants.

---

## 🧾 Final Notes

- 📁 Organize outputs into directories like `raw_data/`, `trimmed/`, `aligned/`, `variants/`, etc.
- 🧪 Always verify file integrity and check logs for errors.
- 🔁 Use `conda list` to view installed packages within an environment.
- 📤 Export environments using:

```bash
conda env export > env_name.yml
```
