#!/usr/bin/env groovy 



pipeline {
  agent { node { label 'DockerHost' } }
  stages {
    //////////////////Stage 1: build the source code//////////////////
    ///
    /// Function:
    ///           1. Build the war and upload into Nexus Server
    ///           2. Build docker image and upload to Docker Registry
    ///
    //////////////////Stage 1: build the source code//////////////////
        stage('DevBuild') {
          agent { docker { 
            image 'maven' 
            args '-v /var/run/docker.sock:/var/run/docker.sock -v /usr/bin/docker:/usr/bin/docker'
            }
          }
          steps{
            sh "mvn clean deploy sonar:sonar"
            sh "cp -rf ROOT dockers/runtime/"
            sh "zip dockers/runtime/ROOT.zip ROOT/*"
            sh "cp target/sample-prevayper-1.0-SNAPSHOT.war dockers/runtime/CompanyNews.war"
            withCredentials([usernamePassword(credentialsId: 'docker_registry', passwordVariable: 'password', usernameVariable: 'username')]) {
               sh "cd ./dockers/runtime/;./build_docker.sh --ver ${env.BUILD_NUMBER} --user ${username} --pwd ${password} --push;cd -"
            }
            //reset all file due to root auth.
          }
        }

    //////////////////Stage 2: Dev confirmation//////////////////
    ///
    /// Function:
    ///           1. Pull the docker image from Registry and run container.
    ///           2. get approvment from Dev Team
    /// Notice: It may skip with rate of coverage.
    ///
    //////////////////Stage 1: build the source code//////////////////
    stage('Dev Environment') {
      agent {
        docker {
            image 'myregistry.com/aws:${env.BUILD_NUMBER}'
            registryUrl 'https://myregistry.com/'
            registryCredentialsId 'myPredefinedCredentialsInJenkins'
        }
    }
    stages {
        stage('Build') {
            steps {
              sh 'echo "Waiting for the Dev  Check and Confirm"'
                //mail bcc: '', body: 'Do some notification', cc: 'Dev Team', from: 'CI-Notice', replyTo: '', subject: '${env.JOB_NAME}-${env.BUILD_NUMBER} is Ready to QA Env', to: 'QA_Team'
            }
            input {
              message 'Dev Confirmation'
              ok 'Ready for QA'
              submitter "Dev Team"
            }
        }
    }

    }
    //////////////////Stage 3: Test confirmation//////////////////
    ///
    /// Integration Test and approved by QA.
    /// Function:
    ///           1. Pull the docker image from Registry and run container.
    ///           2. Do some integration test with selenium
    ///           3. QA Team do somke testing and approve it.
    ///
    stage('QA Environment') {
      agent {
        docker {
            image 'myregistry.com/aws:${env.BUILD_NUMBER}'
            registryUrl 'https://myregistry.com/'
            registryCredentialsId 'myPredefinedCredentialsInJenkins'
        }
      }
      steps {
        sh '''echo "Do some integration test with selenium & manual"'''
      }
      input {
        message 'QA Confirmation'
        ok 'Ready for PRD'
        submitter "QA Team"
      }
    }

    //////////////////Stage 4: Product Manager confirmation//////////////////
    /// Integration Test and approved by QA.
    /// Function:
    ///           1. Pull the docker image from Registry and run container.
    ///           2. PRD Team check and approve it.
    ///
    stage('Approve') {
      agent {
        docker {
            image 'myregistry.com/aws:${env.BUILD_NUMBER}'
            registryUrl 'https://myregistry.com/'
            registryCredentialsId 'myPredefinedCredentialsInJenkins'
        }
      }
      steps {
        sh 'echo "Waiting for the PRD  Check and Approve"'
        // mail bcc: '', body: 'Do some notification', cc: 'Dev Team', from: 'CI-Notice', replyTo: '', subject: '${env.JOB_NAME}-${env.BUILD_NUMBER} is Relasing to Production', to: 'QA_Team; Dev_Team;PRD_Team'
      }
      input {
          message 'Is it approved?'
          ok 'Approve'
          submitter "PRD Team"
        }
    }
  }
  post{
    success{
            script {
           emailext body: '''<body leftmargin="8" marginwidth="0" topmargin="8" marginheight="4"
    offset="0">
    <table width="95%" cellpadding="0" cellspacing="0"
        style="font-size: 11pt; font-family: Tahoma, Arial, Helvetica, sans-serif">
        <tr>
            <td><br />
            <b><font color="#0B610B">构建信息</font></b>
            <hr size="2" width="100%" align="center" /></td>
        </tr>
        <tr>
            <td>
                <ul> 
                    <li>BuildName：${JOB_NAME}</li>
                    <li>BuildResult: <span style="color:green"> ${BUILD_STATUS}</span></li> 
                    <li>BuildNo.：${BUILD_NUMBER}  </li>
                    <li>GIT Addr：${git_url}</li>                    
                    <li>GIT Branch：${git_branch}</li>
                    <li>ChangeLog: ${CHANGES,showPaths=true,showDependencies=true,format="<pre><ul><li>ID: %r</li><li>UserName: %a</li><li>Date：%d</li><li>Message：%m</li><li>files: <br />%p</li></ul></pre>",pathFormat="         %p <br />"}
                </ul>
            </td>
        </tr>
    </table>
</body>
</html>
''', subject: '${PROJECT_NAME} Approved.', to: 'All_Team@aaa.com,'
                }
    }
  }
}