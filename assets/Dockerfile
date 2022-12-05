FROM mambaorg/micromamba:0.24.0

USER root

RUN \
  apt-get update && \
  apt-get install -y procps && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/*

USER mambauser

RUN \
  micromamba install -y -n base -c bioconda -c conda-forge \
    't1k ==1.0.1' && \
  micromamba clean --all --yes

ENV PATH="/opt/conda/bin:/opt/conda/condabin:${PATH}"
