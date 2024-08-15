 #!/bin/bash
export TF_VAR_do_token=$(pass sf/digitalocean_api)
export TF_VAR_user_deploy_hash=$(pass sf/deployhash)
