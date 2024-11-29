To runthis code you will need to have shuf.a.bed.qz and shuf.b.bed.qz file in working 
directory along with pro1.smk and selection.tsv files. 
pro1.smk is snakemake code and selection.tsv file have list of chr to merge

to run code initiate snakemake environment and run following code in bash:
$ snakemake -s pro1.smk --cores 1
