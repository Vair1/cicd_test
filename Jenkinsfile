@Library("shared-libraries")
import io.libs.Utils

def utils = new Utils()

pipeline {

    parameters {
        string(defaultValue: "${env.jenkinsAgent}", description: 'Нода дженкинса, на которой запускать пайплайн. По умолчанию vbm_node', name: 'jenkinsAgent')
        string(defaultValue: "${env.serveradress}", description: 'Адрес серверного кластера', name: 'serveradress')
        string(defaultValue: "${env.ibadress}", description: 'Наименование базы данных', name: 'ibadress')
        string(defaultValue: "${env.platform1c}", description: 'Версия платформы 1с, например 8.3.12.1685. По умолчанию будет использована последня версия среди установленных', name: 'platform1c')
        string(defaultValue: "${env.admin1cUser}", description: 'Имя администратора с правом открытия вншних обработок (!) для базы тестирования 1с Должен быть одинаковым для всех баз', name: 'admin1cUser')
        string(defaultValue: "${env.admin1cPwd}", description: 'Пароль администратора базы тестирования 1C. Должен быть одинаковым для всех баз', name: 'admin1cPwd')
    }

    agent {
        label "vbm_node"
    }
    options {
        timeout(time: 8, unit: 'HOURS') 
        buildDiscarder(logRotator(numToKeepStr:'10'))
    }
    stages {
        stage("Тестирование ADD") {
            steps {
                timestamps {
                    script {
                        
                        returnCode = utils.cmd("runner vanessa --settings tools/vrunner.json --v8version ${platform1c} --ibconnection /S${serveradress}\${ibadress} --db-user ${admin1cUsr} --db-pwd ${admin1cPwd}")

                    }
                }
            }
        }
    }   
    post {
        always {
            script {
                if (currentBuild.result == "ABORTED") {
                    return
                }

                dir ('build/out/allure') {
                    writeFile file:'environment.properties', text:"Build=${env.BUILD_URL}"
                }

                allure includeProperties: false, jdk: '', results: [[path: 'build/out/allure']]
            }
        }
    }
}
