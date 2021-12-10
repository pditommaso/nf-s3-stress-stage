nextflow.enable.dsl=2

params.index = "index-full.txt"

channel
  .fromPath(params.index)
  .splitText() 
  .map { it.trim() }
  .set { files_ch }


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

workflow {
  foo(files_ch)
  bar(files_ch)
}
