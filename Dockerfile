# python alphine 代表轻量级,保证docker最终减小docker最终文件大小
FROM python:3.9-alpine3.15
LABEL maintainer='bamboo5320@gmail.com'

# 设定python log直接打印在终端,可以减少一些bug
ENV PYTHONUNBUFFERED 1

# 复制本地的一些文件到docker内的路径下
COPY ./requirements.txt /requirements.txt
COPY ./app /app

# 设定docker的初始运行路径
WORKDIR /app
# 设定外部可以访问的docker端口
EXPOSE 8000

# "&& \"代表换行继续运行下一行,让代码不要显得那么臃肿,提高可读性
# 在docker内一行行运行以下bash命令,自动在docker内安装之前设定好的需要的依赖包 例如: django
# "RUN" 可以在docker运行命令时,不重建一层,减小docker最终文件大小
# 第一行命令可以在docker内新建一个python虚拟环境减少可能得一些冲突
# 最后一行代表新建一个用户名字叫"app",没有密码,不要建立"home"文件夹,默认linux会在基础目录下新建一个   
RUN python -m venv /py && \
    /py/bin/pip install --upgrade pip && \
    apk add --update --no-cache postgresql-client && \
    apk add --update --no-cache --virtual .tmp-deps \
        build-base postgresql-dev musl-dev && \
    /py/bin/pip install -r /requirements.txt && \
    apk del .tmp-deps && \
    adduser --disabled-password --no-create-home app && \
    mkdir -p /vol/web/static && \
    mkdir -p /vol/web/media && \
    chmod -R 755 /wol
    
# 添加环境路径,这样docker运行命令时不用添加路径
ENV PATH="/py/bin:$PATH"

# 这条命令后,docker会以user的身份运行,减少docker权限,提高docker安全性
USER app