# 1. 构建阶段：明确指定使用 JDK 17 的 Maven 镜像
FROM maven:3.9.6-eclipse-temurin-17 AS BUILD

COPY . /usr/src/app
# 编译并打包（如果打包很慢，可以加上 -DskipTests）
RUN mvn --batch-mode -f /usr/src/app/pom.xml clean package -DskipTests

# 2. 运行阶段：明确指定使用 JDK 17 的运行环境
FROM eclipse-temurin:17-jre
ENV PORT 8080
EXPOSE 8080

# 注意：这里假设你的多模块打包后，各微服务的 jar 会被汇总到根目录的 target 下。
# 如果你的项目结构不同（比如在各自模块的 target 下），这个 COPY 路径可能需要调整。
COPY --from=BUILD /usr/src/app/target /opt/target
WORKDIR /opt/target

# 运行找到的第一个 SNAPSHOT.jar（建议后续按微服务拆分 Dockerfile）
CMD ["/bin/bash", "-c", "find -type f -name '*-SNAPSHOT.jar' | head -n 1 | xargs java -jar"]