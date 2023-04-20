# 基础镜像
FROM golang:1.20.3 AS build

# 将当前目录下的所有文件复制到容器中的 /app 目录下
COPY . /app

# 设置工作目录
WORKDIR /app

# 使用 make 命令编译可执行文件
RUN make build

# 在另一个镜像中运行二进制文件
FROM alpine:3.14
COPY --from=build /app/bin/db-schema-exporter /usr/local/bin/db-schema-exporter

# 运行可执行文件
ENTRYPOINT ["db-schema-exporter"]
CMD []
