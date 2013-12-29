get_ipython().magic("logstart -ot ~/ipython-log/ipython-log rotate")
get_ipython().magic(u'load_ext autoreload')
get_ipython().magic(u'autoreload 2')
try:
    execfile("research/analyst/analyst_ipython.py")
    print "executed analyst_ipython.py"
except:
    print "cannot execute analyst_ipython.py"

