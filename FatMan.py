#!/usr/bin/python
# Fatman.py
# Attempt to zone transfer every
# domain in a file.
# Format of list:
# www.domain.com
# or
# domain.com
# NO http:// or https://
# 'pip install dnspython' - Requirement


import dns.query
import dns.zone
import dns.resolver
from multiprocessing import Pool
import os
import argparse

def ztit(line):
 #Zone Transfer function
 #Takes line from file finds nameservers
 #tries AXFR on each nameserver for domain.
  uni = line.replace("www.", "")
  uni = uni.strip()
  try:
    ns = dns.resolver.query(uni, 'NS')
    for ser in ns.rrset:
      server = str(ser)[:-1]
      try:
        z = dns.zone.from_xfr(dns.query.xfr(server, uni, lifetime=5))
      except:
        z = None
      if z is not None:
        reporter(z, uni, server.strip())
      else:
        continue
  except Exception as e:
    return

def reporter(z, server, ns):
 #Handles output from succesful transfers
 #Formats strings
 #Tries to make look pretty - fails hard
 #Work needed
  if server.strip() is '':
    server = ns
  out = '{}: {}'.format('ZT!', server)
  print out
  fn = os.path.join(savedir, server + '_output.txt')
  i = '{:=^60} Vulnerable Name Server! ' + ns + '\n'
  with open(fn, 'a') as d:
    ip = []
    emp = ' '
    nl = '\n'
    for host, data in z.nodes.iteritems():
      for sets in data.rdatasets:
        ip = str(sets).split()
        if "SOA" in ip[2]:
          s = """{0}\t {1}\t {2}\t {3}\t {4} {5} (
                                             \t {6}  \t: Serial,
                                             \t {7}  \t: Refresh,
                                             \t {8}  \t: Retry,
                                             \t {9}  \t: Expire,
                                             \t {10} \t: Minimum TTL
                                             ){11}""".format(server, ip[0], ip[1], ip[2],
                                                                              ip[3], ip[4], ip[5], ip[6], ip[7], ip[8], ip[9], nl)

          d.write(s)
        elif "TXT" in ip[2]:
          host = str(server)
          s = '{}\t {}\t {}\t {}\t {} {}'.format(host, ip[0], ip[1], ip[2], emp.join(ip[3:]), nl)
          d.write(s)
        elif "PTR" in ip[2]:
          s = '{}\t {}\t {}\t {}\t {} {}'.format(host, ip[0], ip[1], ip[2], emp.join(ip[3:]), nl)
          d.write(s)
        else:
          if str(host) == '@':
            host = str(server)
          elif str(server) not in str(host):
            host = str(host) + '.' + str(server)

          s = '{}\t {}\t {}\t {}\t {} {}'.format(host, ip[0], ip[1], ip[2], emp.join(ip[3:]), nl)
          d.write(s)

if __name__ == '__main__':
  parser = argparse.ArgumentParser(description="Attempt to perform a DNS zone transfer against targets in file.")
  parser.add_argument("--targets-file", dest="targets_file", default="domains.txt", help="a file containing target domains")
  parser.add_argument("--save-dir", dest="save_dir", default=".", help="a directory to save transfer results")
  args = parser.parse_args()
  
  savedir = args.save_dir
  #Some not so fancy number collection
  #Grab some processes
  #Open file give process a function and a line
  #More number collection
  #Finish
  startcount = len(os.listdir(savedir))
  dom = Pool(processes=25)
  mains = open(args.targets_file, "r").readlines()
  overall = len(mains)
  dom.map(ztit, mains)
  abscount = len(os.listdir(savedir))
  totcount = abscount - startcount
  stats = float(totcount) / float(overall) * 100
  finished = '\033[01;38mWe got {} Zone transfers out of {} With a hit % of {}%\033[1;m'.format(str(totcount),
                                                                                str(overall), str(stats))
  print finished
