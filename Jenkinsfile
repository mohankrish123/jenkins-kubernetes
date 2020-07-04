pipeline {
	agent any
	environment {
		VERSION = sh(script: "git rev-parse HEAD", returnStdout=true)
	}
	stages {
	  stage("Docker build") {
		steps{
			sh "docker build -t mohankrish3/nginxkube:"${env.VERSION}""
		}	
	  }
	  stage("Docker push") {
			steps{
				withCredentials([usernamePassword(credentialsId: 'dockerhub', passwordVariable: 'DOCKERHUBPASS', usernameVariable: 'DOCKERHUBUSER')]) {
                sh "docker login -u $DOCKERHUBUSER -p $DOCKERHUBPASS"
                sh "docker push mohankrish3/nginxkube:$VERSION"  
                }
			}
	  }
	  stage("Running pods in kube master") {
			steps {
				sshagent(['kubemaster']) {
                sh "chmod +x tagversion.sh && ./tagversion.sh $VERSION"
                sh "scp -o StrictHostKeyChecking=no new-pods.yaml ubuntu@3.133.134.29:/home/ubuntu"
                script{
                	try {
                		sh "ssh -o StrictHostKeyChecking=no ubuntu@3.133.134.29 "kubectl apply -f .""
                	}
                	catch (error){
                	    sh "ssh -o StrictHostKeyChecking=no ubuntu@3.133.134.29 "kubectl create -f .""	
                	}
                }
                

	}
}
}
}
