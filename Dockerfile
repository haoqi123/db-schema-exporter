# 基础镜像
FROM golang:1.20.3 AS build
# 设置工作目录
WORKDIR /app

# 在一些情况下，禁用CGO是有益的，例如在使用静态链接的情况下。将CGO_ENABLED的值设置为0后，Go语言将以静态方式编译程序，不需要C编译器和链接器的支持，从而减小了二进制文件的大小并且更加安全
# 加上这步与apline中的ln相呼应，才可以使程序运行
ENV CGO_ENABLED=0

# 将当前目录下的所有文件复制到容器中的 /app 目录下
COPY . .
# 使用 make 命令编译可执行文件
RUN make build

# 在另一个镜像中运行二进制文件
# 多阶段构建，是一种常用的容器镜像构建手段，这样构建出来的容器镜像就会特别小，易于分发，节省部署时间
FROM alpine:3.17.3

# alpine中缺，得加上
RUN mkdir /lib64 && \
    ln -s /lib/libc.musl-x86_64.so.1 /lib64/ld-linux-x86-64.so.2

WORKDIR /app
COPY --from=build /app/bin/db-schema-exporter /app

# 运行可执行文件
ENTRYPOINT ["./db-schema-exporter"]