from flask import Flask, request
import os
import random
from face_detection import detect_faces

app = Flask(__name__, static_folder='/home/ec2-user/photo_result/')
base_dir = '/home/ec2-user/photo_result'
photo_dir = '/home/ec2-user/photo'
score_dir = '/home/ec2-user/score'
player_info_dir = '/home/ec2-user/player_info'
result_file = '/home/ec2-user/result.txt'
ranking_file = '/home/ec2-user/ranking.txt'

def get_ranking():
    with open(ranking_file) as f:
        return [
            {
                'Y': line[0:4],
                'M': line[4:6],
                'D': line[6:8],
                'h': line[8:10],
                'm': line[10:12],
                's': line[12:14],
                'name': line[14:34],
                'score': line[34:39]
            }
            for line
            in f
        ]

@app.route('/')
def index():
    os.system('cobcrun ranking')
    header = '''
<!DOCTYPE html>
<html>
<head>
</head>
<body>
'''
    body = '<h1>ランキング</h1>'
    body += '<ol>'
    for p in get_ranking()[:5]:
        body += '<li>'
        body += f'{p["Y"]}/{p["M"]}/{p["D"]} {p["h"]}:{p["m"]}:{p["s"]} <b>{p["score"]} pts {p["name"]}</b>'
        body += '</li>'
    body += '</ol>'
    body += '<hr>'
    body += '<h1>結果</h1>'
    for fname in os.listdir(player_info_dir):
        with open(player_info_dir + '/' + fname) as f:
            body += 'Player %s ' % fname.replace('.txt', '')
            body += f.read()[14:34]
            body += '<br>'
        body += '<img src="%s?%d" /><br>' % (fname.replace('.txt', '.jpg'), random.randint(1, 2 ** 64))
    footer = '''
</body>
</html>
'''
    return header + body + footer


def remove_files_in_dir(d):
    for fname in os.listdir(d):
        os.remove(d + '/' + fname)


@app.route('/init')
def init():
    remove_files_in_dir(base_dir)
    remove_files_in_dir(photo_dir)
    remove_files_in_dir(score_dir)
    remove_files_in_dir(player_info_dir)
    return 'init'


@app.route('/score/<int:player_id>')
def get_score(player_id):
    # calclate score
    input_file = photo_dir + '/' + str(player_id) + '.jpg'
    output_file = base_dir + '/' + str(player_id) + '.jpg'
    score = detect_faces(input_file, output_file)

    # save score
    with open(score_dir + '/' + str(player_id), 'w') as f:
        f.write(str(score))

    # load player info
    player_info = None
    with open(player_info_dir + '/' + '%d.txt' % player_id, 'r') as f:
        # 最後の改行は読み込まない
        player_info = f.read()[:-1]

    # save result
    with open(result_file, 'a') as f:
        print(player_info + '%05d' % score, file=f)

    return str(score)


@app.route('/win/<int:player_id>')
def get_winner(player_id):
    player_id_list = [int(fname) for fname in os.listdir(score_dir)]
    scores = {
        pid: int(open(score_dir + '/' + str(pid)).read())
        for pid in player_id_list
    }
    score = scores[player_id]
    max_score = max(scores.values())
    return str(1 if score == max_score else 0)


if __name__ == '__main__':
    app.run(debug=False, host='0.0.0.0', port=11111)
