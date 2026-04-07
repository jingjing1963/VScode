#!/bin/bash

# 创建必要目录
mkdir -p ./OUTPUT_SEQ
mkdir -p ./DATABASE

# 定义原始序列
s="MSTRSVSSSSYRRMFGGPGTASRPSSSRSYVTTSTRTYSLGSALRPSTSRSLYASSPGGVYATRSSAVRL"

# 定义生成序列id
for seq_num in {1..10};do
    seq_id=$(printf "seq_%02d" "$seq_num")

    # 获取序列长度
    L=${#s}

    # 初始化打乱后序列为空
    shuffled=""

    # 生成打乱后的序列：
    # 1. seq 0 $(($L-1)) 生成从0到L-1的所有索引
    # 2. shuf 随机打乱这些索引的顺序
    # 3. for循环按打乱后的索引顺序从原序列取氨基酸
    for i in $(seq 0 $((L-1)) | shuf);do
        shuffled=$shuffled${s:$i:1}
    done

    # 输出所生成的序列结果为fasta文件:
    # 1. 将每个序列存为单个文件用于比对
    # 2. 将所有序列存入一个文件用于建库
    echo -e ">$seq_id\n$shuffled" > ./OUTPUT_SEQ/$seq_id.fasta
    echo -e ">$seq_id\n$shuffled" >> ./shuffled_sequences.fasta
done

# 建立blast数据库
makeblastdb -dbtype prot -in ./shuffled_sequences.fasta -out ./DATABASE/shuffled_seq

# 进行两两blast比对
for query_file in OUTPUT_SEQ/*; do 
    blastp -query $query_file -db ./DATABASE/shuffled_seq -outfmt 6 >> ./shuffled_seq.blastp
done

exit 0