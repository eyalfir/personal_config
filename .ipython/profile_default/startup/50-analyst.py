get_ipython().magic("logstart -ot ~/ipython-log/ipython-log rotate")
try:
    execfile("research/analyst/analyst_ipython.py")
    print "executed analyst_ipython.py"
except:
    print "cannot execute analyst_ipython.py"

