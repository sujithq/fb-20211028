terraform {
  required_providers {
    okta = {
      source  = "okta/okta"
      version = "~> 3.17"
    }
  }
}
provider "okta" {
}

locals {
  instances = [
    {
      instance  = "test1"
      baseUrl   = "url"
      subDomain = "sd"
      groups = [
        "app1",
        "app2",
        "app3",
      ]
    },
    {
      instance  = "test2"
      baseUrl   = "url2"
      subDomain = "sd2"
      groups = [
        "t1",
        "t2",
        "t3",
      ]
    },
  ]
  instancesTransformed = flatten([
    for i_key, i in local.instances : [
      for g_key, g in i.groups : {
        instance = i.instance
        group    = g
      }
    ]
  ])
}

resource "okta_group" "snowflake" {
  for_each = {
    for i in local.instancesTransformed : "${i.instance}.${i.group}" => i
  }
  name = each.value.group
}