import re
import subprocess
from datetime import datetime, timedelta

def get_next_meeting(pl):
    raw = subprocess.Popen(['bash', '/Users/efirstenberg/bin/get_next_meeting.sh'], stdout=subprocess.PIPE).communicate()[0]
    raw = raw.splitlines()
    for line in raw:
        t = line.split(' ')[0]
        if datetime.strptime(t, '%H:%M:%S').time() < (datetime.now() - timedelta(minutes=5)).time():
            continue
        return line
