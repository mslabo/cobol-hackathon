#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <unistd.h>
#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include <arpa/inet.h>

#include <opencv2/core.hpp>
#include <opencv2/videoio.hpp>
#include <opencv2/highgui.hpp>

#include <iostream>
#include <sstream>
#include <fstream>

using namespace std;
using namespace cv;

static int sock;
static struct sockaddr_in addr;
string photo_save_dir = "/home/pi/drone_photo";
string sshkey = "/home/pi/cobolhack-y-sakamoto-key-pair.pem";
static int photo_counter;

void drone_begin() {
    sock = socket(AF_INET, SOCK_DGRAM, 0);
    addr.sin_family = AF_INET;
    addr.sin_port = htons(8889);
    addr.sin_addr.s_addr = inet_addr("192.168.10.1");
    //system((photo_save_dir + "/*").c_str());
    photo_counter = 1;
}

void send_command(char *command) {
    sendto(sock, command, strlen(command), 0, (struct sockaddr *)&addr, sizeof(addr));
}

void send_command_cppstring(string command) {
    sendto(sock, command.c_str(), command.size(), 0, (struct sockaddr *)&addr, sizeof(addr));
}

void drone_command() {
    send_command_cppstring("command");
}

void drone_takeoff() {
    send_command_cppstring("takeoff");
}

void drone_land() {
    send_command_cppstring("land");
}

void drone_up(int n) {
    char buf[32];
    sprintf(buf, "up %d", n);
    send_command(buf);
}

void drone_down(int n) {
    char buf[32];
    sprintf(buf, "down %d", n);
    send_command(buf);
}

void drone_left(int n) {
    char buf[32];
    sprintf(buf, "left %d", n);
    send_command(buf);
}

void drone_right(int n) {
    char buf[32];
    sprintf(buf, "right %d", n);
    send_command(buf);
}

void drone_forward(int n) {
    char buf[32];
    sprintf(buf, "forward %d", n);
    send_command(buf);
}

void drone_back(int n) {
    char buf[32];
    sprintf(buf, "back %d", n);
    send_command(buf);
}

void drone_cw(int n) {
    char buf[32];
    sprintf(buf, "cw %d", n);
    send_command(buf);
}

void drone_ccw(int n) {
    char buf[32];
    sprintf(buf, "ccw %d", n);
    send_command(buf);
}

void drone_flip(int n) {
    switch(n) {
    case 0: send_command_cppstring("flip l"); break;
    case 1: send_command_cppstring("flip r"); break;
    case 2: send_command_cppstring("flip f"); break;
    case 3: send_command_cppstring("flip b"); break;
    default: cerr << "out of index" << endl; break;
    }
}


int drone_capture_image() {
    send_command_cppstring("streamon");
    sleep(1);

    VideoCapture cap = VideoCapture("udp://0.0.0.0:11111/");
    Mat frame;
    ostringstream oss;
    oss << photo_save_dir << "/a.jpg";


    if(cap.isOpened()) {
        cap.read(frame);
        imwrite(oss.str().c_str(), frame);
    } else {
    }

    send_command_cppstring("streamoff");
    return photo_counter++;
}


int get_smile_score(int player_id) {
    char buf[256];
    //sprintf(buf, "sh upload.sh %d", player_id);

    sprintf(buf, "scp -i /home/pi/cobolhack-y-sakamoto-key-pair.pem ~/drone_photo/a.jpg  ec2-user@18.180.32.71:/home/ec2-user/photo/%d.jpg", player_id);
    system(buf);
    sprintf(buf, "wget http://18.180.32.71:11111/score/%d -O /home/pi/score.txt", player_id);
    system(buf);
    ifstream ifs("/home/pi/score.txt");
    int score;
    ifs >> score;
    return score;
}

int is_winner(int player_id) {
    char buf[256];
    sprintf(buf, "wget http://18.180.32.71:11111/win/%d -O /home/pi/win.txt", player_id);
    system(buf);
    ifstream ifs("/home/pi/win.txt");
    int score;
    ifs >> score;
    return score;
}

void init_server() {
    system(string("wget http://18.180.32.71:11111/init -O /dev/null").c_str());
}

void drone_end() {
    close(sock);
}


void lib_sleep(int n) {
    sleep(n);
}
