variable "cloudwatch_log_group_name" {
    description = "cloudwatch log goup nme"
    type = string
    default = null  
}

variable "log_group_skip_destroy" {
    description = "Set to true if you do not wish the log group (and any logs it may contain) to be deleted at destroy time, and instead just remove the log group from the Terraform state."
    type = bool
    default = false  
}

variable "log_group_class" {
    description = "Specified the log class of the log group. Possible values are: STANDARD or INFREQUENT_ACCESS."
    type = string
    default = "STANDARD"
}

variable "logs_retention_in_days" {
    description = "Specifies the number of days you want to retain log events in the specified log group."
    type = number
    default = 7  
}