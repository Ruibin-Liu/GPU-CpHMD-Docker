FROM nvidia/cuda:10.0-runtime
LABEL maintainer="ruibin.liu@computchem.com"

# path settings to be compatible with the AWS version
ENV HOME="/home/ubuntu"
ENV PATH="$HOME/bin:$HOME/miniconda3/bin:$HOME/GPU-CpHMD/PDBprep:$HOME/GPU-CpHMD/Scripts:$PATH"
ENV PYTHONPATH="$PYTHONPATH:$HOME/GPU-CpHMD/PDBprep:$HOME/GPU-CpHMD/Scripts"

# systm update, upgrade and install basics
RUN mkdir -p ${HOME}/dat/leap/prep ${HOME}/dat/leap/lib ${HOME}/dat/leap/parm ${HOME}/dat/leap/cmd ${HOME}/bin \
    && apt-get -yqq update \
    && apt-get -yqq upgrade \
    && DEBIAN_FRONTEND=noninteractive apt-get -yqq --no-install-recommends install curl bc gfortran openmpi-bin libopenmpi-dev openssh-client \
    && rm -rf /var/lib/apt/lists/*

# install miniconda, openmm, pdbfixer, parmed, and ambertools
RUN curl -o miniconda.sh -sL https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh \
    && bash miniconda.sh -b \
    && rm miniconda.sh \
    && conda install --freeze-installed -c conda-forge nomkl parmed nodejs \
    && conda install --freeze-installed -c omnia openmm pdbfixer \
    # && conda install --freeze-installed -c ambermd ambertools \
    && conda clean -afy \
    && find ${HOME}/miniconda3 -follow -type f -name '*.a' -delete \
    && find ${HOME}/miniconda3 -follow -type f -name '*.pyc' -delete \
    && find ${HOME}/miniconda3 -follow -type f -name '*.js.map' -delete 

# python and node.js package dependencies
COPY requirements.txt CCInterface/package.json CCInterface/package-lock.json ./
RUN npm install \
    && pip install --quiet -r requirements.txt

# copy our application code
ADD . $HOME/GPU-CpHMD

# executable
ARG ARCH=turing
WORKDIR $HOME/GPU-CpHMD/CCInterface
RUN mv ../executables/pmemd.cuda.${ARCH} ${HOME}/bin/pmemd.cuda \
    && mv ../executables/pmemd.MPI ${HOME}/bin/pmemd.MPI \
    && mv ../executables/tleap ${HOME}/bin/tleap \
    && mv ../executables/teLeap ${HOME}/bin/teLeap \
    && mv ../Files/parm10.dat ${HOME}/dat/leap/parm/parm10.dat \
    && mv ../Files/frcmod.ff14SB ${HOME}/dat/leap/parm/frcmod.ff14SB \
    && mv ../Files/amino*.lib ${HOME}/dat/leap/lib/ \
    && rm -r ../executables

# expose port
EXPOSE 3001

# start app
CMD ["node", "app.js"]
