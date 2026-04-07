#!/bin/bash

# 提取ACTB基因区域
grep -v '^#' hg38.ACTB.gff | awk 'BEGIN {FS="\t"; OFS="\t"}$3 == "gene"{print $1,$4-1,$5}'| sort -k1,1 -k2,2n > ACTB_gene.bed

# 提取ACTB外显子区域
grep -v '^#' hg38.ACTB.gff | awk 'BEGIN {FS="\t"; OFS="\t"}$3 == "exon"{print $1,$4-1,$5}'| sort -k1,1 -k2,2n > ACTB_exon.bed

# 获得ACTB内含子区域

bedtools subtract -a ACTB_gene.bed -b ACTB_exon.bed > ACTB_intron.bed

# 提取bam文件中比对到ACTB基因内含子区域的信息

