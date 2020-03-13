pid=`ps -A | grep python | awk '{print $1}'`
if [ -n "$pid" ]; then
    kill $pid
fi
python3 http_server.py
