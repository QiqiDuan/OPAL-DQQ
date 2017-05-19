# 在Linux操作系统下安装MATLAB

MATLAB版本 : MATLAB R2016b [学术版]。

操作系统版本: CentOS 7 [64位]、Ubuntu 16.04 [64位]。

## 阅读安装指南

[MATLAB官方安装指南](https://www.mathworks.com/help/install/ug/install-mathworks-software.html)介绍了在Windows、Mac OS X、Linux操作系统下MATLAB软件的主要安装步骤。

## 安装注意事项

MATLAB软件由C、C++、JAVA等语言混合编写而成。因此，先配置JAVA JDK基础环境（配置方式有许多，这里只是其中一种配置形式）：

```
export JAVA_HOME="/usr/lib/jvm/java-8-oracle/jre/"
```

采取在线安装方式（需确保互联网连接通畅）：使用MATLAB安装包中```glnxa64```文件夹下的SHELL脚本```install```进行安装（区别DVD安装方式）。

安装命令为：

```
$ ./install
```

在线安装过程较为漫长，需耐心等待（并建议定时检查安装进度）。在安装过程中，可能因为网络连接问题，导致安装停止；一般点击继续安装即可。
