#!/bin/bash

# Step 1: Download the COG definition file
#wget https://ftp.ncbi.nih.gov/pub/COG/COG2020/data/cog-20.def.tab -O cog-20.def.tab

# Step 2: Download pathway-EC mapping file from KEGG
#wget -O ec_pathway_mapping.txt https://rest.kegg.jp/link/pathway/ec

# Step 7: Combine pathway information with my_bacterium_R2.tsv based on enzyme numbers
awk -F"\t" '
NR==FNR {
    sub("ec:", "", $1); 
    ec[$1] = (ec[$1] ? ec[$1] ", " : "") $2;  # Concatenate multiple items with a comma separator
    next
} 
FNR > 1 && $5 in ec { 
    print $0, ec[$5]  # Append all matched items to the row
}' OFS="\t" annotation_R1/ec_pathway_mapping.txt  annotation_R1/my_bacterium_R1.tsv > annotation_R1/combined_ec_R1.txt


awk -F"\t" '
NR==FNR {
    sub("ec:", "", $1); 
    ec[$1] = (ec[$1] ? ec[$1] ", " : "") $2;  # Concatenate multiple items with a comma separator
    next
} 
FNR > 1 && $5 in ec { 
    print $0, ec[$5]  # Append all matched items to the row
}' OFS="\t" annotation_R2/ec_pathway_mapping.txt annotation_R2/my_bacterium_R2.tsv > annotation_R2/combined_ec_R2.txt

