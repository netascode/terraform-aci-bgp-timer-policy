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

  tenant                  = aci_rest.fvTenant.content.name
  name                    = "BGP1"
  description             = "My Description"
  graceful_restart_helper = false
  hold_interval           = 60
  keepalive_interval      = 30
  maximum_as_limit        = 20
  stale_interval          = "120"
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

  equal "descr" {
    description = "descr"
    got         = data.aci_rest.bgpCtxPol.content.descr
    want        = "My Description"
  }

  equal "grCtrl" {
    description = "grCtrl"
    got         = data.aci_rest.bgpCtxPol.content.grCtrl
    want        = ""
  }

  equal "holdIntvl" {
    description = "holdIntvl"
    got         = data.aci_rest.bgpCtxPol.content.holdIntvl
    want        = "60"
  }

  equal "kaIntvl" {
    description = "kaIntvl"
    got         = data.aci_rest.bgpCtxPol.content.kaIntvl
    want        = "30"
  }

  equal "maxAsLimit" {
    description = "maxAsLimit"
    got         = data.aci_rest.bgpCtxPol.content.maxAsLimit
    want        = "20"
  }

  equal "staleIntvl" {
    description = "staleIntvl"
    got         = data.aci_rest.bgpCtxPol.content.staleIntvl
    want        = "120"
  }
}
