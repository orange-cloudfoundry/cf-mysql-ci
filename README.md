# cf-mysql-ci
Contains Concourse CI scripts and configuration we use to test [cf-mysql-release](https://github.com/cloudfoundry/cf-mysql-release)

#### Configure a pipeline
```
 $ ./ci/configure-pipeline
```
Select the number of the pipeline you wish to set.

This script uses the reconfigure-pipeline tool from https://github.com/pivotal-cf/reconfigure-pipeline
which automatically pulls creds from lastpass by name (but not folder).

#### Credentials

The pipeline config files are parametrized to allow private credentials to be stored outside this repo. The configure-pipeline script will pull creds from lastpass, based on the access of whoever is logged into lpass.

#### Environment Config Files

The cf-mysql and cf-mysql-acceptance pipelines are also parametrized to allow CI to deploy to different environments.
The cf-mysql pipeline deploys to `initial_env` at the start of the pipeline, and `integration_env` at the end.
The cf-mysql-acceptance pipeline performs a single deploy to `acceptance_env`.
There are a collection of variables in the pipeline configs (e.g. `{{initial_env_bosh_url}}`) to allow these environments to be specified by the user.
These config variables can be defined in the above credentials file, or by adding `--vars-from YOUR_ENVS.yml` to the above command.

In addition to the Concourse parameters, our scripts expect the following files to exist for each environment:
```
${DEPLOYMENTS_CONFIG_DIR}/${ENV_NAME}/cf-aws-stub.yml
${DEPLOYMENTS_CONFIG_DIR}/${ENV_NAME}/cf-networks-stub.yml
${DEPLOYMENTS_CONFIG_DIR}/${ENV_NAME}/cf-shared-secrets.yml
${DEPLOYMENTS_CONFIG_DIR}/${ENV_NAME}/cf-mysql-plans-stub.yml
${DEPLOYMENTS_CONFIG_DIR}/${ENV_NAME}/cf-properties.yml
${DEPLOYMENTS_CONFIG_DIR}/${ENV_NAME}/cf-mysql-secrets.yml
```
