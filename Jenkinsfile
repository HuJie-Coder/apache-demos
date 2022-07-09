pipeline {
    agent any
    stages {
        stage('编译代码') {
            steps {
                echo "开始编译代码"
                sh 'mvn clean package -U'
                echo "代码编译成功"
            }
        }
        stage('构建镜像') {
            steps {
                echo 'docker build xxxxx'
            }
        }
        stage('推送镜像') {
            steps {
                echo 'docker push xxxx'
            }
        }
        stage('部署镜像') {
            steps {
                echo 'deploy xxxx'
            }
        }
    }
}