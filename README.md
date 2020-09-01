# Dockerfile 构建 nginx-rtmp-ffmpeg 流服务镜像
一个Dockerfile从源代码安装NGINX，nginx-rtmp-module和FFmpeg
HLS实时流媒体的默认设置。 建立在CentOS7.8.2003上。

* Nginx 1.18.0 (从源代码编译)
* nginx-rtmp-module 1.2.1 (从源代码编译)
* ffmpeg 2.8.15 (从源代码编译)
* 默认HLS设置(见: nginx.conf)


## 用法:

### 服务端
* 拉取docker镜像并运行:
```shell
docker pull dancefingers/nginx-rtmp-ffmpeg-centos7.8.2003:1.0.0
docker run -it -d -p 11935:1935 -p 180:80 -p 1443:443 dancefingers/nginx-rtmp-ffmpeg-centos7.8.2003:1.0.0
```
或者 

* 构建docker镜像并运行:
```shell
docker build -t [镜像名称][:tag] .
docker run -it -d -p 11935:1935 -p 180:80 -p 1443:443 [镜像名称][:tag]
```

* 将实时内容串流到服务端:
```shell
rtmp://<server ip>:11935/stream/$STREAM_NAME
```

### OBS配置
* 流类型: `自定义流媒体服务器`
* 流地址: `rtmp://<server ip>:11935/stream`
* 流密钥: `$STREAM_NAME` 如：hello

### 观看流
* 在Safari，VLC或任何HLS播放器中，打开:
```shell
rtmp://<server ip>:11935/stream/$STREAM_NAME
或
http://<server ip>:180/hls/$STREAM_NAME/index.m3u8
或
https://<server ip>:1443/hls/$STREAM_NAME/index.m3u8
```
* 例如: `http://192.168.1.1:180/hls/hello/index.m3u8`


### FFMPEG构建
```shell
[root@962fad302551 /]# ffmpeg
ffmpeg version 2.8.15 Copyright (c) 2000-2018 the FFmpeg developers
  built with gcc 4.8.5 (GCC) 20150623 (Red Hat 4.8.5-36)
  configuration: --prefix=/usr --bindir=/usr/bin --datadir=/usr/share/ffmpeg --incdir=/usr/include/ffmpeg --libdir=/usr/lib64 --mandir=/usr/share/man --arch=x86_64 --optflags='-O2 -g -pipe -Wall -Wp,-D_FORTIFY_SOURCE=2 -fexceptions -fstack-protector-strong --param=ssp-buffer-size=4 -grecord-gcc-switches -m64 -mtune=generic' --extra-ldflags='-Wl,-z,relro ' --enable-libopencore-amrnb --enable-libopencore-amrwb --enable-libvo-amrwbenc --enable-version3 --enable-bzlib --disable-crystalhd --enable-gnutls --enable-ladspa --enable-libass --enable-libcdio --enable-libdc1394 --enable-libfdk-aac --enable-nonfree --disable-indev=jack --enable-libfreetype --enable-libgsm --enable-libmp3lame --enable-openal --enable-libopenjpeg --enable-libopus --enable-libpulse --enable-libschroedinger --enable-libsoxr --enable-libspeex --enable-libtheora --enable-libvorbis --enable-libv4l2 --enable-libx264 --enable-libx265 --enable-libxvid --enable-x11grab --enable-avfilter --enable-avresample --enable-postproc --enable-pthreads --disable-static --enable-shared --enable-gpl --disable-debug --disable-stripping --shlibdir=/usr/lib64 --enable-runtime-cpudetect
  libavutil      54. 31.100 / 54. 31.100
  libavcodec     56. 60.100 / 56. 60.100
  libavformat    56. 40.101 / 56. 40.101
  libavdevice    56.  4.100 / 56.  4.100
  libavfilter     5. 40.101 /  5. 40.101
  libavresample   2.  1.  0 /  2.  1.  0
  libswscale      3.  1.101 /  3.  1.101
  libswresample   1.  2.101 /  1.  2.101
  libpostproc    53.  3.100 / 53.  3.100
Hyper fast Audio and Video encoder
usage: ffmpeg [options] [[infile options] -i infile]... {[outfile options] outfile}...

Use -h to get full help or, even better, run 'man ffmpeg'
```

## 资源
* nginx下载地址： http://nginx.org
* nginx-rtmp-module下载地址： https://github.com/arut/nginx-rtmp-module
* ffmpeg下载地址： https://www.ffmpeg.org
* OBS下载地址： https://obsproject.com
* VLC下载地址： https://www.videolan.org/

> 参考：https://github.com/alfg/docker-nginx-rtmp