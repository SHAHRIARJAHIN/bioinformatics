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

CONDA_DIR="$HOME/miniconda3"

if ! command_exists conda; then
    echo "Installing Miniconda..."
    wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O miniconda.sh
    bash miniconda.sh -b -p "$CONDA_DIR"
    rm miniconda.sh

    # Initialize conda
    export PATH="$CONDA_DIR/bin:$PATH"
    source "$CONDA_DIR/etc/profile.d/conda.sh"
    conda init bash
    source ~/.bashrc
    echo "Miniconda installed successfully"
else
    echo "Miniconda is already installed or conda already available"
fi

# 3. Tool Installations
print_header "3. CREATING ENVIRONMENTS & INSTALLING TOOLS"

# SRA Toolkit
conda create -n sra-tools -y
conda activate sra-tools
conda install -c bioconda sra-tools -y
conda deactivate

# FastQC
conda create -n fastqc_env -y
conda activate fastqc_env
conda install -c bioconda fastqc -y
conda deactivate

# Trimmomatic
conda create -n trimmomatic_env -y
conda activate trimmomatic_env
conda install -c bioconda trimmomatic -y
conda deactivate

# FastP
conda create -n fastp_env -y
conda activate fastp_env
conda install -c bioconda fastp -y
conda deactivate

# Mapping tools: BWA, samtools, bcftools
conda create -n mapping_vcf -y
conda activate mapping_vcf
conda install -c bioconda bwa samtools bcftools -y
conda deactivate

# FreeBayes
conda create -n freebayes_env -y
conda activate freebayes_env
conda install -c bioconda freebayes -y
conda deactivate

# BCFTools (separate env)
conda create -n bcftools_env -y
conda activate bcftools_env
conda install -c bioconda bcftools htslib -y
conda deactivate

# SnpEff
conda create -n snpeff_env -y
conda activate snpeff_env
conda install -c bioconda snpeff -y
conda deactivate

# IGV
conda create -n igv_env python=3.9 -y
conda activate igv_env
conda install -c bioconda igv -y
conda deactivate

# SPAdes (Genome Assembly)
conda create -n spades_env python=3.8 -y
conda activate spades_env
conda install -c bioconda spades -y
conda deactivate

# QUAST (Assembly Quality Assessment)
conda create -n quast_env -y
conda activate quast_env
conda install -c bioconda quast -y
conda deactivate

# Prokka (Genome Annotation)
conda create -n prokka_env -y
conda activate prokka_env
conda install -c bioconda prokka -y
conda deactivate

# Artemis (Genome Visualization)
conda create -n artemis_env -y
conda activate artemis_env
conda install -c bioconda artemis -y
conda deactivate

# Abricate (Antibiotic Resistance)
conda create -n abricate_env -y
conda activate abricate_env
conda install -c bioconda abricate -y
conda deactivate

# Final message
print_header "INSTALLATION COMPLETE"
echo "All bioinformatics tools have been installed in their respective conda environments."
echo ""
echo "To use any tool, activate its environment first:"
echo "  conda activate [environment_name]"
echo ""
echo "Available environments:"
echo "  - sra-tools        # SRA Toolkit"
echo "  - fastqc_env       # FastQC"
echo "  - trimmomatic_env  # Trimmomatic"
echo "  - fastp_env        # FastP"
echo "  - mapping_vcf      # BWA, samtools, bcftools"
echo "  - freebayes_env    # FreeBayes"
echo "  - bcftools_env     # BCFTools"
echo "  - snpeff_env       # SnpEff"
echo "  - igv_env          # IGV"
echo "  - spades_env       # SPAdes "
echo "  - quast_env        # QUAST "
echo "  - prokka_env       # Prokka "
echo "  - artemis_env      # Artemis "
echo "  - abricate_env     # Abricate "
echo ""
echo "Note: For tools like ResFinder and SpeciesFinder, please visit:"
echo "  - https://www.genomicepidemiology.org/"
