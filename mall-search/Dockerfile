# 1. 构建阶段
FROM maven:3.9.6-eclipse-temurin-17 AS BUILD
WORKDIR /build
# 拷贝整个项目，因为微服务依赖了 mall-common 等公共模块
COPY . /build

# 关键点：使用 -pl 指定只打包当前模块，-am 表示同时构建它依赖的模块
RUN mvn clean package -pl mall-search -am -DskipTests -Ddocker.skip=true

# 2. 运行阶段
FROM eclipse-temurin:17-jre
WORKDIR /app
# 只拷贝当前模块下打好的 jar 包
COPY --from=BUILD /build/mall-search/target/*.jar app.jar

ENV PORT 8080
EXPOSE 8080

ENTRYPOINT ["java", "-jar", "/app/app.jar"]