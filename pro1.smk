import pandas as pd
import os

# Load the chromosome selection file
SELECTION_FILE = "selection.tsv"
chromosomes = pd.read_csv(SELECTION_FILE, header=None, sep="\t")[0].str.strip().tolist()

# Rule to specify the final desired output
rule all:
    input:
        "sorted_bed_file_per_sample/sorted.bed"

# Rule to split BED files by chromosome
rule split:
    input:
        bed_a="shuf.a.bed.gz",
        bed_b="shuf.b.bed.gz"
    output:
        "split_individual/{chrom}.bed.gz"
    shell:
        """
        zcat {input.bed_a} {input.bed_b} | awk '$1 == "{wildcards.chrom}"' | gzip > {output}
        """

# Rule to sort each chromosome-specific file
rule sort:
    input:
        "split_individual/{chrom}.bed.gz"
    output:
        "sort_individual/{chrom}.bed.gz"
    shell:
        """
        zcat {input} | sort -k2,2n -k3,3n | gzip > {output}
        """

# Rule to merge sorted chromosome files based on user-defined order
rule merge:
    input:
        sorted_files=expand("sort_individual/{chrom}.bed.gz", chrom=chromosomes)
    output:
        "sorted_bed_file_per_sample/sorted.bed"
    shell:
        """
        > {output}
        for chrom in {chromosomes}; do
            zcat sort_individual/$chrom.bed.gz >> {output};
        done
        """

