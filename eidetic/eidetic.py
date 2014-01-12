import ast
import _ast
import sys
import re


# Internal parsing
last_traceback = None
DEBUG = 0
definitions = {}
definitions_stack = []

def add_definition(targets, s):
    for target in targets:
        definitions.setdefault(target, []).append(s)
    definitions_stack.append(s)

def parse_for_definitions(s):
    tree = None
    try:
        tree = ast.parse(s)
    except:
        if not DEBUG:
            return
        else:
            raise
    if tree and len(tree.body)!=1:
        return
    if isinstance(tree.body[0], _ast.Assign):
        add_definition([x.id for x in tree.body[0].targets], s)

def pre_prompt(ip):
    global last_traceback
    if hasattr(sys, "last_traceback") and sys.last_traceback!=last_traceback:
        last_traceback = sys.last_traceback
        return
    parse_for_definitions(ip.history_manager.input_hist_raw[-1])

# Magics

def print_definition(x):
    all_vars = [var for var in definitions.keys() if re.search("^"+x, var)]
    print "\n".join([definitions[var][-1] for var in all_vars])

def print_definitions_history(x):
    all_vars = [var for var in definitions.keys() if re.search("^"+x, var)]
    all_defs = set(reduce(lambda x,y:x+y, [definitions[var] for var in all_vars], []))
    try:
        print "\n".join([x for x in definitions_stack if x in all_defs])
    except KeyError:
        print "%s not defined"%x

# extension code

def load_ipython_extension(ip):
    ip.set_hook("pre_prompt_hook", pre_prompt)
    ip.register_magic_function(print_definition, magic_name="define")
    ip.register_magic_function(print_definition, magic_name="def")
    ip.register_magic_function(print_definitions_history, magic_name="hdef")

def unload_ipython_extension(ipython):
    pass
