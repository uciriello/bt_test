import hudson.tasks.junit.TestResultSummary

def lastRunningStage; 

pipeline {
  agent any
  
  environment {
    DISCORD_WEBHOOK_URL = 'https://discord.com/api/webhooks/815900156364587030/Y-wZkMJznoUNpvC7g0Kpxnew0ZpmhCRh-aenkYGavf5KBcN9Z9i6Y6r2qtOYG_ySnyZU'
    // PATH = "$PATH:${pwd()}/flutter/bin:$HOME/.pub-cache/bin:$PATH:${pwd()}/flutter/bin/cache/dartk-sdk/bin:$PATH:${pwd()}/flutter/.pub-cache/bin"
  }
  stages {

    stage('Flutter init') {
      steps {
        script {
          lastRunningStage="Flutter Init"
        }
        sh 'flutter pub get'
        sh 'flutter pub global activate junitreport'
      }
    }

    stage("Sonar Analysis") {
      steps {
          script {
            lastRunningStage="Sonar Analysis"
          }
          // withSonarQubeEnv('Quinck Sonarqube') {
          //   sh '${SCANNER_HOME}/bin/sonar-scanner --version'
          // }
      }
    }
    
    // stage("Test") {
    //   when {
    //     not {
    //       branch 'master'
    //     }
    //   }
    //   steps {
    //     script {
    //       lastRunningStage="Test"
    //       sh 'echo $PATH'
    //       sh 'flutter test'
    //       sh 'flutter test --machine | tojunit --output report.xml'
    //     }
    //   }
    // }

    // stage("Build") {
    //   when {
    //     anyOf {
    //       branch 'release';
    //       branch 'develop';
    //       branch 'master'
    //     }
    //   }
      // parallel {
    stage("Build Android") {
      when {
        anyOf {
          branch 'release';
          branch 'develop';
          branch 'master'
        }
      }
      steps {
        script {
          lastRunningStage="Build"
        }
        withAWS(credentials:'aws-credentials', region: 'eu-west-1') {
          awsCodeBuild projectName: '	advice-h_cube-mobile-build', credentialsType: 'keys', region: 'eu-west-1', sourceControlType: 'project'
          // awsCodeBuild projectName: '	advice-h_cube-mobile-build', credentialsType: 'keys', envVariables: '[ { BRANCH, $BRANCH } ]', region: 'eu-west-1', sourceControlType: 'project'
        }
      }
    }
        // stage("Build iOS") {
        //   // agent {
        //   //   label "macmini"
        //   // }
        //   steps {
        //     script {
        //       // lastRunningStage="Build"
        //       // sh 'flutter build ipa'
        //     }
        //   }
        // }
      // }
    // }
  }

  post {
    always {
      script {
        // def exists = fileExists "report.xml"
        // notifyDiscord(currentBuild.result, lastRunningStage, testResult)
        notifyDiscord(currentBuild.result, lastRunningStage)
        deleteDir() /* clean up our workspace */
        }
    }
    failure {
      script {
        sh 'exit 1'
      }
    }
  }
}

// def notifyDiscord(String buildStatus = 'SUCCESS', String lastRunningStage ="PRE-BUILD", TestResultSummary testResult) {
def notifyDiscord(String buildStatus = 'SUCCESS', String lastRunningStage ="PRE-BUILD") {
  
  def statusIcon;

  def successIcons = [":unicorn:",":man_dancing:", ":ghost:", ":dancer:", ":scream_cat:"]
  def failedIcons = [":fire:", "dizzy_face", ":man_facepalming:"]
  def buildFailed = false

  if (buildStatus == 'SUCCESS') {
    def successRandomIndex = (new Random()).nextInt(successIcons.size())
    statusIcon = "${successIcons[successRandomIndex]}"
  } else {
    def failedRandomIndex = (new Random()).nextInt(failedIcons.size())
    buildFailed = true
    statusIcon = "${successIcons[failedRandomIndex]}"
  }

  def title = "${env.JOB_NAME} Build: ${env.BUILD_NUMBER}"
  def title_link = "${env.RUN_DISPLAY_URL}"

  // def testSummary = "\n *Test Summary* - ${testResult.totalCount}, Failures: ${testResult.failCount}, Skipped: ${testResult.skipCount}, Passed: ${testResult.passCount}\n\nTest link: ${env.RUN_TESTS_DISPLAY_URL}"

  def author = sh(returnStdout: true, script: "git --no-pager show -s --format='%an'").trim()

  def commitTimestamp = sh(returnStdout: true, script: "git log -n 1 --pretty=format:'%cd' --date=format:'%d/%m/%Y - %H:%M:%S'").trim()
  def commitMessage = sh(returnStdout: true, script: 'git log -1 --pretty=%B').trim()
  def commitShortHash = sh(returnStdout: true, script: "git log -n 1 --pretty=format:'%h'").trim()

  def commitMessageDetail = "Commit: ${commitTimestamp}\nMessage: ${commitMessage}\nHash: ${commitShortHash}"

  def branchName = "${env.BRANCH_NAME}"

  def tokens = "${env.JOB_NAME}".tokenize('/')
  def org = tokens[0]
  def subject = "${statusIcon} Status: *${buildStatus}*"

  if (buildFailed == true) {
    subject = subject + "\n> Failed in stage: *${lastRunningStage}*"
  }

  // subject = subject + "\n${testSummary}"

  def completeMessage;
  def detailMessage = statusDetailMessage(!buildFailed, author)
  
  completeMessage = subject + "\n\n" + detailMessage

  discordSend (description: completeMessage, footer: "${commitMessageDetail}", link: title_link, result: currentBuild.currentResult, title: JOB_NAME, webhookURL: "${DISCORD_WEBHOOK_URL}")
}

def statusDetailMessage(boolean success, String authorName) {
  def message;

  if (success == true) {
    def messages = [":champagne::champagne:\tCongrats **${authorName}**, ci sei riuscito. :sunglasses:\t:champagne::champagne:", 
    ":moyai::moyai:\tMah man **${authorName}**, you made it. :women_with_bunny_ears_partying:\t:moyai::moyai:",
    ":burrito::burrito:\t**${authorName}**, sei stato bravo. :women_with_bunny_ears_partying:\t:burrito::burrito:",
    ":pig::pig:\t **${authorName}** You son of a bitch. you did it. :women_with_bunny_ears_partying:\t:pig::pig:"]
    def randomIndex = (new Random()).nextInt(messages.size())
    message = messages[randomIndex]
  } else {
    def messages = [ ":fire::fire:\t* **${authorName}**, Sei un coglione!*\t:fire::fire:",
    ":bomb::bomb:\t*${authorName}*, Ma sarà possibile?\t:bomb::bomb:"]
    def randomIndex = (new Random()).nextInt(messages.size())

    message = messages[randomIndex]
  }

  return message
}