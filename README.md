# xray-reality
This is a Bash script that installs Xray Beta and downloads the configuration for the repository created by [Teegrce](https://twitter.com/Teegrce) for Iran inside this repository with your own key and places it only with one command :)
#
## Installation Guide
just need you to run this command
```
 bash -c "$(curl -L https://raw.githubusercontent.com/sajjaddg/xray-reality/master/install.sh)"
``` 
and it will do the rest for you.

## Uninstallation guide
```
 bash -c "$(curl -L https://raw.githubusercontent.com/sajjaddg/xray-reality/master/uninstall.sh)"
``` 

## Installation Guide with Docker 

0. install docker 
``` bash
curl -fsSL https://get.docker.com | sh
```
1. clone this project 
``` bash
git clone https://github.com/sajjaddg/xray-reality && cd xray-reality
```
2. build docker image 
``` bash
docker build -t xrayreality .
```
3. run 
``` bash
 docker run -d --name xrayreality -p443:443 xrayreality
```
4. get connection config :
> get url
``` bash
docker exec -it xrayreality cat /root/test.url
```
> view qrcode 
``` bash
docker exec -it xrayreality sh -c 'qrencode -s 120 -t ANSIUTF8 $(cat /root/test.url)'
```
## how to manage ?
> status :
``` bash
docker ps -a | grep xrayreality
```
> stop :
``` bash
docker stop xrayreality
```
> start :
``` bash
docker stop xrayreality
```
>remove :
``` bash
docker rm -f xrayreality
```
#
## Note
1. I have only tested it on Ubuntu 22 and wrote it for that system. Although I have the time and willingness to write it for other systems, I don't think I will need to do so unless I am forced to.
2. I used ChatGPT to translate my words. Please pardon any mistakes in the translation.

## ToDo
- [ ] Add menu
- [ ] test it on other OS and modify the script for them
