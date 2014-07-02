get_ipython().magic("logstart -ot ~/ipython-log/ipython-log rotate")
try:
    execfile("research/analyst/analyst_ipython.py")
    print "executed analyst_ipython.py"
except:
    print "cannot execute analyst_ipython.py"
try:
    get_ipython().magic('load_ext eidetic')
except:
    print "unable to load ipyton_eidetic"

