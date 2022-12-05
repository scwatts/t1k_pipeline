#!/usr/bin/env nextflow


process T1K {
    tag "${meta.id}"

    container 'docker.io/scwatts/t1k:1.0.1'

    input:
    tuple val(meta), path(read_fps), val(input_type)
    path gene_coordinates
    path reference
    val preset

    output:
    path '*candidate*fq', emit: fastq_candidate
    path '*aligned*fa'  , emit: fastq_aligned
    path '*tsv'         , emit: tsv
    path '*vcf'         , emit: vcf

    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: ''

    def input_args
    if (input_type == 'fastq_paired') {
        input_args = "-1 ${read_fps[0]} -2 ${read_fps[1]}"
    } else if (input_type == 'fastq_single'){
        input_args = "-u ${read_fps}"
    } else if (input_type == 'fastq_interleaved'){
        input_args = "-i ${read_fps}"
    } else if (input_type == 'bam'){
        input_args = "-b ${read_fps}"
    } else {
        assert false
    }

    def gene_coord_arg = gene_coordinates ? "-c ${gene_coordinates}" : ''
    def preset_arg = preset ? "--preset ${preset}" : ''

    """
    run-t1k \\
        ${input_args} \\
        -f ${reference} \\
        ${gene_coord_arg} \\
        ${preset_arg} \\
        -o ${meta.id} \\
        -t ${task.cpus} \\
        --od ./
    """

    stub:
    """
    touch ${meta.id}_candidate_1.fq
    touch ${meta.id}_candidate_2.fq

    touch ${meta.id}_aligned_1.fq
    touch ${meta.id}_aligned_2.fq

    touch ${meta.id}_allele.tsv
    touch ${meta.id}_allele.vcf
    """
}

def get_file_object(path) {
    return path ? file(path) : []
}

if (params.input_type == 'fastq_paired') {
    input_fps = params.input_fps.collect { file(it) }
} else {
    input_fps = file(params.input_fps)
}

ch_inputs = Channel.of(
    [[id: params.subject_id], input_fps, params.input_type],
)
gene_coordinates = get_file_object(params.gene_coordinates)
reference = get_file_object(params.reference)
preset = params.preset ?: ''

workflow {

    T1K(
        ch_inputs,
        gene_coordinates,
        reference,
        preset,
    )

}
