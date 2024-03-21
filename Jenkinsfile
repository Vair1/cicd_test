@Library("shared-libraries")
import io.libs.SqlUtils
import io.libs.ProjectHelpers
import io.libs.Utils

pipeline {

    parameters {
        string(defaultValue: "${env.jenkinsAgent}", description: 'Нода дженкинса, на которой запускать пайплайн. По умолчанию master', name: 'jenkinsAgent')
        string(defaultValue: "${env.serveradress}", description: 'Адрес серверного кластера', name: 'serveradress')
        string(defaultValue: "${env.ibadress}", description: 'Наименование базы данных', name: 'ibadress')
        string(defaultValue: "${env.platform1c}", description: 'Версия платформы 1с, например 8.3.12.1685. По умолчанию будет использована последня версия среди установленных', name: 'platform1c')
        string(defaultValue: "${env.admin1cUser}", description: 'Имя администратора с правом открытия вншних обработок (!) для базы тестирования 1с Должен быть одинаковым для всех баз', name: 'admin1cUser')
        string(defaultValue: "${env.admin1cPwd}", description: 'Пароль администратора базы тестирования 1C. Должен быть одинаковым для всех баз', name: 'admin1cPwd')
    }

    agent {
        label "${(env.jenkinsAgent == null || env.jenkinsAgent == 'null') ? "master" : env.jenkinsAgent}"
    }
    options {
        timeout(time: 8, unit: 'HOURS') 
        buildDiscarder(logRotator(numToKeepStr:'10'))
    }
    stages {
        stage("Подготовка") {
            steps {
                timestamps {
                    script {
                        // создаем пустые каталоги
                        dir ('build') {
                            writeFile file:'dummy', text:''
                        }
                    }
                }
            }
        }
        stage("Тестирование ADD") {
            steps {
                timestamps {
                    script {
                        
                        returnCode = utils.cmd("runner vanessa --settings tools/vrunner.json --v8version ${platform1cLine} --ibconnection /S${serveradress}\${ibadress} --db-user ${admin1cUsrLine} --db-pwd ${admin1cPwdLine}")

                        if (returnCode != 0) {
                            utils.raiseError("Возникла ошибка при запуске ADD на базе ${baseConnString}")
                        }
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
