pipeline {
    agent {
        kubernetes {
          label 'kubepod'  
          defaultContainer 'gcloud'
        }
    }
    environment {

       def app_infra_params = "${app_infra_params}"
       def projects_params = "${projects_params}"
       def bu1_development = "${bu1_development}"
       def bu1_non_production = "${bu1_non_production}"
       def bu1_production = "${bu1_production}"
        
  }
    stages {
        
        stage ('Test received params') {
            steps {
                sh '''
                echo \"$projects_params\"
                echo \"$app_infra_params\"
                echo \"$bu1_development\"
                echo \"$bu1_non_production\"
                echo \"$bu1_production\"
                '''
            }
        }
        stage('Activate GCP Service Account and Set Project') {
            steps {
                
                container('gcloud') {
                    sh '''
                        gcloud auth activate-service-account --key-file=$GOOGLE_APPLICATION_CREDENTIALS
                        gcloud config list
                       '''
                }
            }
            
        }
       stage('Setup Terraform & Dependencies') {
             steps {
                 container('gcloud') {
                     sh '''
                       
                         apt-get -y install jq wget unzip
                         wget -O /tmp/terraform.zip https://releases.hashicorp.com/terraform/0.14.6/terraform_0.14.6_linux_amd64.zip
                         unzip -q /tmp/terraform.zip -d /tmp
                         chmod +x /tmp/terraform
                         mv /tmp/terraform /usr/local/bin
                         rm /tmp/terraform.zip
                         terraform --version
                        '''
                 }
             }

         }
         stage('Deploy CFT app-infra') {
             steps {
                 container('gcloud') {
                     sh '''
                        export YOUR_INFRA_PIPELINE_PROJECT_ID=$projects_params
                        cd ./scripts/5-app-infra/ && echo \"$app_infra_params\" | jq "." > common.auto.tfvars.json && echo \"$bu1_development\" | jq "." > bu1-development.auto.tfvars.json
                        echo \"$bu1_non_production\" | jq "." > bu1-non-production.auto.tfvars.json && echo \"$bu1_production\" | jq "." > bu1-production.auto.tfvars.json
                        cat common.auto.tfvars.json bu1-development.auto.tfvars.json bu1-non-production.auto.tfvars.json bu1-production.auto.tfvars.json
                        cd ../.. && make app-infra
    
                 }
               
             }
         }
    
    
    }
    
    
    
}
