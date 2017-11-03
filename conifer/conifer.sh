#$ -S /bin/sh
#!/bin/bash

module load modules modules-init modules-gs
module load python/2.7.2
module load hdf5/1.8.3
module load pytables/2.3.1_hdf5-1.8.3
module load numpy/1.6.1

python /path/to/conifer_v0.2.2/conifer.py analyze --probes /path/to/probes.bed --rpkm_dir /path/to/rpkm/ --output /path/to/outfile.hdf5 --plot_scree /path/to/outfile.png --svd 7

python /path/to/conifer_v0.2.2/conifer.py call --input /path/to/outfile.hdf5 --output /path/to/outfilecalls.txt

python /path/to/conifer_v0.2.2/conifer.py export --input /path/to/outfile.hdf5 --output /path/to/export_svdzrpkm/

python /path/to/conifer_v0.2.2/conifer.py plotcalls --input /path/to/outfile.hdf5 --calls /path/to/outfilecalls.txt --outputdir /path/to/call_imgs/

