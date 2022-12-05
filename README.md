# T1K Nextflow pipeline

## Reference files

Create reference files for HLA and KIR alleles along with gene coordinate file for BAM inputs.

```bash
git clone https://github.com/mourisl/T1K.git
cd T1K/

wget https://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_human/release_41/gencode.v41.annotation.gtf.gz | \
  gzip -cd > gencode.v41.annotation.gtf
perl t1k-build.pl -o kiridx --download IPD-KIR -g gencode.v41.annotation.gtf
perl t1k-build.pl -o hlaidx --download IPD-IMGT/HLA -g gencode.v41.annotation.gtf
```

## Example run

> Uses reference files generated above

```bash
nextflow run main.nf -params-file params.json
```
