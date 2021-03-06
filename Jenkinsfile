pipeline {
        agent any
        environment {
                VERSION = getGitTag()
        }
        stages {
          stage("Docker build") {
                steps{
                        sh "sudo docker build . -t mohankrish3/nginxkube:${VERSION}"
                }
          }
          stage("Docker push") {
                        steps{
                                withCredentials([usernamePassword(credentialsId: 'dockerhub', passwordVariable: 'DOCKERHUBPASS', usernameVariable: 'DOCKERHUBUSER')]) {
                sh "sudo docker login -u $DOCKERHUBUSER -p $DOCKERHUBPASS"
                sh "sudo docker push mohankrish3/nginxkube:${env.VERSION}"
                }
                        }
          }
          stage("Running pods in kube master") {
                        steps {
                                sshagent(['kubemaster']) {
                sh "chmod +x tagversion.sh && ./tagversion.sh ${env.VERSION}"
                sh "scp -o StrictHostKeyChecking=no new-pods.yaml ubuntu@3.133.134.29:/home/ubuntu"
                script{
                        try {
                                sh """
                                      ssh -o StrictHostKeyChecking=no ubuntu@3.133.134.29 "sudo kubectl apply -f ."
                                """
                        }
                        catch (error){
                            sh """
                            ssh -o StrictHostKeyChecking=no ubuntu@3.133.134.29 "sudo kubectl create -f ."
                            """
                        }
                }


        }
}
}
}
}

def getGitTag(){
    def tag = sh script:'git rev-parse HEAD', returnStdout: true
    return tag
}
