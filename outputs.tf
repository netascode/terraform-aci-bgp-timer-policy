output "dn" {
  value       = aci_rest.bgpCtxPol.id
  description = "Distinguished name of `bgpCtxPol` object."
}

output "name" {
  value       = aci_rest.bgpCtxPol.content.name
  description = "BGP timer policy name."
}
