nextflow.enable.dsl=2

params.index = "$baseDir/index-full.txt"
params.upload_count = 0
params.upload_size = '10G'
params.upload_dir = "s3://nextflow-ci/data/"

channel
  .fromPath(params.index)
  .splitText() 
  .map { it.trim() }
  .set { files_ch }


workflow {
  download()
  upload()
}

workflow download {
  foo(files_ch)
  bar(files_ch)
}

workflow upload {
  if( params.upload_count ) {
      uploadRandomFile( channel.of(1..params.upload_count) )
  }
}

process foo {
  input:
    path x
  """
  ls -lah
  """
}

process bar {
  input:
    path x
  """
  ls -lah
  """
}

process uploadRandomFile {
  publishDir params.upload_dir
  input:
  val index
  output:
  path '*.data'
  """
  dd if=/dev/zero of=myfile-${index}.data bs=1 count=0 seek=${params.upload_size}
  """
}
