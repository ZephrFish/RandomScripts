#!/usr/bin/env python2
# coding: utf-8
# vim:ts=4 sts=4 tw=100:

import sys
import re
a = open(sys.argv[1]).read()
m = re.search('Testing SSL server ([\d.]+) on port (\d+)', a, re.S)

print("""<?xml version="1.0" encoding="UTF-8"?>
<document title="SSLScan Results" version="1.8.2" web="http://www.titania.co.uk">
<ssltest host="%s" port="%s">""" % m.groups())

for b in re.findall(
    'Accepted.*?(TLSv1|SSLv2|SSLv3)\s+(\d+) bits\s+([\w-]+)',
        a):
    print('<cipher status="accepted" sslversion="%s" bits="%s" cipher="%s" />' % b)

print("</ssltest></document>")
