# 基础镜像
FROM golang:1.20.3 AS build
# 设置工作目录
WORKDIR /app
ENV CGO_ENABLED=0
# 将当前目录下的所有文件复制到容器中的 /app 目录下
COPY . .
# 使用 make 命令编译可执行文件
RUN make build

# 在另一个镜像中运行二进制文件
FROM alpine:3.17.3

RUN mkdir /lib64 && \
    ln -s /lib/libc.musl-x86_64.so.1 /lib64/ld-linux-x86-64.so.2

WORKDIR /app
COPY --from=build /app/bin/db-schema-exporter /app

# 运行可执行文件
ENTRYPOINT ["./db-schema-exporter"]