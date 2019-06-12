## This reposistory is created with learning purposes for Terraform, focusing on GitHub provider, including KitchenCI test. 

## Purpose :

- It provides a simple example of how to use Terraform `github` provider and test the outcome with KitchenCI.

## How to install terraform : 

- The information about installing terraform can be found on the HashiCorp website 
[here](https://learn.hashicorp.com/terraform/getting-started/install.html)


## How to setup KitchenCI and RBENV (MacOS Mojave 10.14.5) :
- In a directory of your choice, clone the github repository :
    ```
    git clone https://github.com/martinhristov90/terraformGithubKitchen.git
    ```

- Change into the directory :
    ```
    cd terraformGithubKitchen
    ```

### Setup RBENV:
- Run `brew install ruby`
- After previous command finish, run `gem install rbenv`, this would give you ability to choose particular version of Ruby. This is a prerequisite.
- Run the following two commands, to setup Ruby environment for the local directory.
    ```bash
    echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bash_profile
    echo 'eval "$(rbenv init -)"' >> ~/.bash_profile
    ```
- Reload your BASH interpreter or apply the changes to the profile :
    ```shell
    source ~/.bash_profile 
    ```
- Verify rbenv is installed properly with :
    ```shell
    type rbenv   # → "rbenv is a function"
    ```
- To install the particular version that we need, run the following command in the project directory:
    ```shell
    rbenv install 2.5.3
    ```
- Set local version to be used with command :
    ```shell
    rbenv local 2.5.3
    ```
- Previous step is going to create a file named .ruby-version, with the following content `2.5.3`

- Next, [Bundler](https://bundler.io) needs to be installed, run `gem install bundler`, this would provide the dependencies that KitchenCI needs. It is going to install the Gems defined in the `Gemfile`

### Setup KitchenCI:
- Install the needed Gems for KitchenCI using Bundle with command :
    ```shell
    bundle install
    ```
- Now you should have KitchenCI installed and running, verify with `bundle exec kitchen list`, the output should look like :
    ```
    Instance        Driver     Provisioner  Verifier   Transport  Last Action    Last Error
    default-github  Terraform  Terraform    Terraform  Ssh        <Not Created>  <None>
    ```

### How to use it :

- Edit a file named `testing.tfvars` and set the following variables in it :
    ```
    github_token = "YOUR_GITHUB_TOKEN" # Token should have following rights : `repo admin:org admin:public_key admin:repo_hook admin:org_hook user delete_repo admin:gpg_key`.
    github_organization = "YOUR_ORG" # Name of your organization in which the repo to be created in.
    ```

- Run `bundle exec kitchen converge` to create the infrastructure that is going to be tested. The output should look like this :
    ```
    -----> Starting Kitchen (v2.2.5)
    ---SNIP--
           github_repository.testRepo: Creating...
             allow_merge_commit: "" => "true"
             allow_rebase_merge: "" => "true"
             allow_squash_merge: "" => "true"
             archived:           "" => "false"
             default_branch:     "" => "<computed>"
             description:        "" => "This repository is created by using Terraform GitHub provider"
             etag:               "" => "<computed>"
             full_name:          "" => "<computed>"
             git_clone_url:      "" => "<computed>"
             html_url:           "" => "<computed>"
             http_clone_url:     "" => "<computed>"
             name:               "" => "repositoryCreatedWithTerraform"
             ssh_clone_url:      "" => "<computed>"
             svn_url:            "" => "<computed>"
           github_repository.testRepo: Creation complete after 5s (ID: repositoryCreatedWithTerraform)

           Apply complete! Resources: 1 added, 0 changed, 0 destroyed.

           Outputs:

           testRepoGitHTTPURL = https://github.com/organization24/repositoryCreatedWithTerraform
           Finished converging <default-github> (0m5.92s).
    -----> Kitchen is finished. (0m12.76s)
    ```
- Now, the testing of the Github repostory is going to be performed to verify if it exists. Run `bundle exec kitchen verify` The output should look like :
    ```
    default: Verifying
    Profile: tests from /Users/martinhristov/Tasks/TerraformLearn/terraformGithubKitchen/test/integration/default (tests from   .Users.martinhristov.Tasks.TerraformLearn.terraformGithubKitchen.test.integration.default)
    Version: (not specified)
    Target:  local://

      ✔  check_website: HTTP GET on https://github.com/organization24/repositoryCreatedWithTerraform
         ✔  HTTP GET on https://github.com/organization24/repositoryCreatedWithTerraform status should cmp == 200
         ✔  HTTP GET on https://github.com/organization24/repositoryCreatedWithTerraform body should match "repositoryCreatedWithTerraform"


    Profile Summary: 1 successful control, 0 control failures, 0 controls skipped
    Test Summary: 2 successful, 0 failures, 0 skipped
           Finished verifying <default-github> (0m1.27s).
    -----> Kitchen is finished. (0m4.93s)
    ```

- To destroy the `KitchenCI` resources, execute `bundle exec kitchen destroy`.
