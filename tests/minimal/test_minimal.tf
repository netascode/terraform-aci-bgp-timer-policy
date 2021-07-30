terraform {
  required_providers {
    test = {
      source = "terraform.io/builtin/test"
    }

    aci = {
      source  = "netascode/aci"
      version = ">=0.2.0"
    }
  }
}

resource "aci_rest" "fvTenant" {
  dn         = "uni/tn-TF"
  class_name = "fvTenant"
}

module "main" {
  source = "../.."

  tenant = aci_rest.fvTenant.content.name
  name   = "BGP1"
}

data "aci_rest" "bgpCtxPol" {
  dn = "uni/tn-${aci_rest.fvTenant.content.name}/bgpCtxP-${module.main.name}"

  depends_on = [module.main]
}

resource "test_assertions" "bgpCtxPol" {
  component = "bgpCtxPol"

  equal "name" {
    description = "name"
    got         = data.aci_rest.bgpCtxPol.content.name
    want        = module.main.name
  }
}
