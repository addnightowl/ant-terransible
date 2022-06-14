terraform {
  cloud {
    organization = "ant-terransible"

    workspaces {
      name = "terransible"
    }
  }
}
