# 説明

COBOLハッカソン2020で「こんな時だから、いつも笑顔で」が制作したアプリケーション.
1~2台ドローンのカメラで人の顔を認識して笑顔スコアを算出し,得点を競う.

# 必要機材

* [ドローン「Ryze TELLO」](https://www.ryzerobotics.com/jp/tello) 1~2台
* [Raspberry Pi](https://www.raspberrypi.org/) 1~2台
* AWS EC2インスタンス


# 内容物

* drone/  Raspberry piにインストールするソフトウェアのソースコード
* server/ Webサーバにインストールするソフトウェアのソースコード


# 環境構築

## Webサーバの環境構築
* AWSのコンソールより11111番ポートでTCP通信できるように設定する.
* SSHでEC2インスタンスにログインして必要なソフトウェアをインストールする.
```bash
apt install python3
pip3 install flask opencv-contrib-python
```
* server/中のファイルを/home/ec2-user/中へコピーする.
* データ保存用ディレクトリを作成する.
```bash
mkdir /home/ec2-user/photo_result
mkdir /home/ec2-user/photo
mkdir /home/ec2-user/score
mkdir /home/ec2-user/player_info

```
* openCV用のデータファイルのダウンロード
```
cd /home/ec2-user
wget https://raw.githubusercontent.com/opencv/opencv/master/data/haarcascades/haarcascade_frontalface_default.xml
wget https://raw.githubusercontent.com/opencv/opencv/master/data/haarcascades/haarcascade_smile.xml
```
* COBOLプログラムのコンパイル
```
cobc -m ranking.cob
```
## Raspberry Piの環境構築

### opencvのインストール

```bash
sudo apt install libopencv-dev
```

### opensource COBOLのインストール
[こちら](https://github.com/opensourcecobol/opensource-cobol)を参照のこと.

### sshの設定
* EC2インスタンスを各Raspberry piに/home/pi/cobolhack-y-sakamoto-key-pair.pemとして保存する.
* /home/pi/.ssh/configに以下を追記(aaa.bbb.ccc.dddはEC2インスタンスに割り当てられたIPアドレス)
```
host aaa.bbb.ccc.ddd 
  StrictHostKeyChecking no
```
* パーミッションを変更
```bash
chmod 600 /home/pi/.ssh/config
chmod 600 /home/pi/cobolhack-y-sakamoto-key-pair.pem
```

### その他設定
* ディレクトリdrone/の内容物をRaspberry Piの/home/pi/drone/ディレクトリの中にコピーする.
* 画像保存用ディレクトリの作成

```bash
mkdir /home/pi/drone_photo
```

* コンパイル
```bash
cd /home/pi/drone
make dronelib
make captest
```
(各種ソースコード中のWebサーバのIPアドレスが書かれている箇所を適当に書き換えてからコンパイルする)

# 使い方

* EC2インスタンスにログインしてHTTPサーバを起動する.
```bash
sh start_server.sh
```
* Raspberry PiとTELLOをWiFi接続する.
* Raspberry Piをインターネット接続する.
* Raspberry Piより2台のTELLOを同時に起動する.
```bash
sh run.sh [1or2] player_name
```
例
TELLO 1
```bash
sh run.sh 1 hanako
```
TELLO 2
```bash
sh run.sh 2 taro
```
* 終了するとRaspberry PiのWebブラウザが立ち上がり,結果を表示する.
