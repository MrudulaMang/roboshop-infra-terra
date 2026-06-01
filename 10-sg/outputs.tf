/*output "sg_id" {
    value = module.sg.sg_id
}*/

output "sg_ids" {
  value = {
    for k, v in module.sg : k => v.sg_id
  }
}