#$ -S /bin/sh
#!/bin/bash
 
# Tychele N. Turner
# Laboratory of Evan Eichler, Ph.D.
# xhmm analysis
echo "Usage: sh xhmm_analysis.sh <datasetName>"
 
PATHxhmm='/path/to/xhmm'
PATHparam='/path/to/params.txt'
datasetName="$1"

 # combine depth of coverage
"$PATHxhmm" --mergeGATKdepths -o "$datasetName" --GATKdepthsList "$datasetName".txt 
 
# filter samples and targets and then mean-centers the targets
"$PATHxhmm" --matrix -r "$datasetName" --centerData --centerType target -o "$datasetName".filtered_centered.RD.txt --outputExcludedTargets "$datasetName".filtered_centered.RD.txt.filtered_targets.txt --outputExcludedSamples "$datasetName".filtered_centered.RD.txt.filtered_samples.txt --minTargetSize 10 --maxTargetSize 10000 --minMeanTargetRD 10 --maxMeanTargetRD 500 --minMeanSampleRD 25 --maxMeanSampleRD 200 --maxSdSampleRD 150
 
# runs pca on mean-centered data
"$PATHxhmm" --PCA -r "$datasetName".filtered_centered.RD.txt --PCAfiles "$datasetName".RD_PCA 
 
# normalizes mean-centered data using PCA information
"$PATHxhmm" --normalize -r "$datasetName".filtered_centered.RD.txt --PCAfiles "$datasetName".RD_PCA --normalizeOutput "$datasetName".PCA_normalized.txt --PCnormalizeMethod PVE_mean --PVE_mean_factor 0.7
 
# filters and z-score centers (by sample) the PCA normalized data
"$PATHxhmm" --matrix -r "$datasetName".PCA_normalized.txt  --centerData --centerType sample --zScoreData -o "$datasetName".PCA_normalized.filtered.sample_zscores.RD.txt --outputExcludedTargets "$datasetName".PCA_normalized.filtered.sample_zscores.RD.txt.filtered_targets.txt --outputExcludedSamples "$datasetName".PCA_normalized.filtered.sample_zscores.RD.txt.filtered_samples.txt --maxSdTargetRD 30
 
# filters original read-depth data to be the same as filtered, normalized data
"$PATHxhmm" --matrix -r "$datasetName" --excludeTargets "$datasetName".filtered_centered.RD.txt.filtered_targets.txt --excludeTargets "$datasetName".PCA_normalized.filtered.sample_zscores.RD.txt.filtered_targets.txt --excludeSamples "$datasetName".filtered_centered.RD.txt.filtered_samples.txt --excludeSamples "$datasetName".PCA_normalized.filtered.sample_zscores.RD.txt.filtered_samples.txt -o "$datasetName".same_filtered.RD.txt
 
# discovers CNVs in all samples
"$PATHxhmm" --discover -p "$PATHparam" -r "$datasetName".PCA_normalized.filtered.sample_zscores.RD.txt -R "$datasetName".same_filtered.RD.txt -c "$datasetName".xcnv -a "$datasetName".aux_xcnv -s "$datasetName"

