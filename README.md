# Pcap_DNSProxy
 - 版本: 0.4.9.7
 - 项目地址: [https://github.com/chengr28/Pcap_DNSProxy](https://github.com/chengr28/Pcap_DNSProxy "https://github.com/chengr28/Pcap_DNSProxy")
 - Docker Hub: [https://hub.docker.com/r/lisonfan/pcap_dnsproxy/](https://hub.docker.com/r/lisonfan/pcap_dnsproxy/)

## 打开姿势
```
docker run -itd \
-p 53:53/tcp \
-p 53:53/udp \
--restart always \
--name Pcap_DNSProxy \
lisonfan/pcap_dnsproxy
```

## 自定义配置文件
```
docker run -itd \
-p 53:53/tcp \
-p 53:53/udp \
-v /you/path/xxx.xxx:/pcap_dnsproxy/xxx.xxx \
--restart always \
--name Pcap_DNSProxy \
lisonfan/pcap_dnsproxy
```