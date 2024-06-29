# IAM User
variable "iam_user_name" {
   description = "IAM user name"
   type =  string
   default = ""  
}

variable "iam_user_path" {
    description = "IAM user path ,default value is '/'(example:'/system/')"
    type = string
    default = "/"
}

variable "iam_user_tags" {
    description = "IAM user tags (example:Environment = 'Production' Department  = 'IT')"
    type = map(string)
    default = null
}

variable "iam_user_policy_json_file_path" {
    description = "iam user policy json file"
    type = file
    default = null
}

# IAM Group

variable "iam_group_yes_no" {
    description = "IAM group requried or not"
    type = bool
    default = false
}

variable "iam_group_name" {
    description = "IAM group name"
    type = string
    default = ""
}

variable "iam_group_path" {
    description = "IAM user path ,default value is '/'(example:'/system/')"
    type = string
    default = "/"  
}


#IAM group policy
variable "iam_policy_json_file" {
    description = "IAM policy arn or json file, if json file true else false"
    type = bool
    default = false
}

variable "iam_group_policy_json_file_path" {
    description = "JSON file path if iam policy json file is true"
    type = file
    default = null
}

variable "policy_arn" {
    description = "IAM policy arn for IAM group"
    type = string
    default = null  
}