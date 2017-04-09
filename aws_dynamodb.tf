#####################################
# DynamoDB Settings
#####################################
resource "aws_dynamodb_table" "sample" {
    name = "sample"
    read_capacity = 5
    write_capacity = 5
    hash_key = "primary_key"
    attribute {
        name = "primary_key"
        type = "S"
    }
}
