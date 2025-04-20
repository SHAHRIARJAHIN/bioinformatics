#!/bin/bash

# Bioinformatics Pipeline Setup Script
# This script installs all required tools and sets up conda environments

# Function to print section headers
print_header() {
    echo ""
    echo "========================================"
    echo " $1"
    echo "========================================"
    echo ""
}

# Function to check if a command exists
command_exists() {
    command -v "$1" &> /dev/null
}

# 1. System Setup
print_header "1. SYSTEM SETUP"

# Check for Linux system
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    echo "Linux system detected"
elif [[ "$OSTYPE" == "msys"* ]]; then
    echo "Windows system detected - checking WSL"
    if ! command_exists wsl; then
        echo "WSL not found. Please install WSL first."
        exit 1
    fi
fi

# 2. Miniconda Installation
print_header "2. MINICONDA INSTALLATION"

if ! command_exists conda; then
    echo "Conda not found. Installing Miniconda..."

    # Download and install Miniconda
    wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O miniconda.sh
    bash miniconda.sh -b -p $HOME/miniconda3
    rm miniconda.sh

    # Initialize conda and reload shell
    $HOME/miniconda3/bin/conda init
    source ~/.bashrc

    # Check again
    if ! command_exists conda; then
        echo "Conda installation failed. Please check manually."
        exit 1
    fi

    echo "Miniconda installed successfully"
else
    echo "Conda is already installed"
fi

# 3. SRA Toolkit Setup
print_header "3. SRA TOOLKIT SETUP"

conda create -n sra-tools -y
conda activate sra-tools
conda install -c bioconda sra-tools -y
conda deactivate
echo "SRA Toolkit installed in 'sra-tools' environment"

# 4. Quality Control Tools
print_header "4. QUALITY CONTROL TOOLS"

# FastQC
conda create -n fastqc_env -y
conda activate fastqc_env
conda install -c bioconda fastqc -y
conda deactivate
echo "FastQC installed in 'fastqc_env' environment"

# Trimmomatic
conda create -n trimmomatic_env -y
conda activate trimmomatic_env
conda install -c bioconda trimmomatic -y
conda deactivate
echo "Trimmomatic installed in 'trimmomatic_env' environment"

# FastP
conda create -n fastp_env -y
conda activate fastp_env
conda install -c bioconda fastp -y
conda deactivate
echo "FastP installed in 'fastp_env' environment"

# 5. Mapping and Variant Calling Tools
print_header "5. MAPPING AND VARIANT CALLING TOOLS"

# Mapping tools (BWA, samtools, bcftools)
conda create -n mapping_vcf -y
conda activate mapping_vcf
conda install -c bioconda bwa samtools bcftools -y
conda deactivate
echo "Mapping tools installed in 'mapping_vcf' environment"

# FreeBayes
conda create -n freebayes_env -y
conda activate freebayes_env
conda install -c bioconda freebayes -y
conda deactivate
echo "FreeBayes installed in 'freebayes_env' environment"

# BCFTools (separate env)
conda create -n bcftools_env -y
conda activate bcftools_env
conda install -c bioconda bcftools htslib -y
conda deactivate
echo "BCFTools installed in 'bcftools_env' environment"

# SnpEff
conda create -n snpeff_env -y
conda activate snpeff_env
conda install -c bioconda snpeff -y
conda deactivate
echo "SnpEff installed in 'snpeff_env' environment"

# IGV
conda create -n igv_env python=3.9 -y
conda activate igv_env
conda install -c bioconda igv -y
conda deactivate
echo "IGV installed in 'igv_env' environment"

# Completion Message
print_header "INSTALLATION COMPLETE"
echo "All bioinformatics tools have been installed in their respective conda environments."
echo ""
echo "To use any tool, activate its environment first:"
echo "  conda activate [environment_name]"
echo ""
echo "Available environments:"
echo "  - sra-tools"
echo "  - fastqc_env"
echo "  - trimmomatic_env"
echo "  - fastp_env"
echo "  - mapping_vcf"
echo "  - freebayes_env"
echo "  - bcftools_env"
echo "  - snpeff_env"
echo "  - igv_env"
