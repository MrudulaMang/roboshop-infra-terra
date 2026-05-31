variable "project" {
   default = "roboshop"
}

variable "environment" {
    default = "dev"
}

variable "sg_names" {
    type = list
    default = [
        #database
        "mongodb","redis","mysql","rabbitmq",
        #backend
        "catalogue","user","cart","shipping","payment",
        "backend_alb",
        "frontend",
        "frontend_alb",
        "bastian"
    ]
}