resource "aws_glue_catalog_database" "datalake" {
  name       = "datalake"
  catalog_id = "000000000000"
}