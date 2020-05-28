#!/usr/bin/env python2
# coding: utf-8
# vim:ts=4 sts=4 tw=100:
"""
Run multiple nmap instances in parallel. First command line
parameter is name of file with list of targets.
Default setup is to SYN scan networks for 50 most common TCP ports
"""

import os
import sys
import logging
import argparse
import subprocess

if __name__ == "__main__":

    nmap_bin = "unknown"
    nmap_ports = "80,21,25,3389,23,8080,53,135,110,443,4567,139,1863,445,22,1723,143,1025,113,81,8081,1026,5000,389,1027,1028,10000,1029,37,5678,5900,4444,1002,27374,18067,8594,30722,4664,8000,1050,52749,1024,111,12345,138,4,137,12000,56789,62483,9100"

    parser = argparse.ArgumentParser(
        formatter_class=argparse.RawDescriptionHelpFormatter,
        description="Nmap wrapper",
        epilog="Example:\n\t{0} -t /tmp/targets.txt".format(__file__),
        add_help=True)

    parser.add_argument(
        "-t",
        "--target",
        action="store",
        dest="target",
        required=True,
        type=str,
        help="file containing one target per line (CIRD)")

    parser.add_argument(
        "-l",
        "--loglevel",
        action="store",
        dest="level",
        required=False,
        type=int,
        help="verbose level (10,20,30,40,50; default=20)",
        default=logging.DEBUG)

    parser.add_argument(
        "-i",
        "--iface",
        action="store",
        dest="iface",
        required=False,
        type=str,
        help="interface name (i.e.: eth0, etc)",
        default=None)

    args = parser.parse_args()

    logging.basicConfig(level=args.level)
    logging.info("Detected platform: %s", sys.platform)

    if sys.platform.startswith("linux") or sys.platform == "darwin":
        nmap_bin = "/usr/bin/nmap"
    elif sys.platform == "win32":
        nmap_bin = "c:/program files/nmap/nmap"
    else:
        logging.exception("Cannot detect underlying operating system")
        # raise Exception("Cannot detect underlying operating system")

    with open(args.target, "r") as input_file:
        logging.info("Reading input file \"{0}\"".format(args.target))
        for line in input_file.readlines():
            target = line.strip()
            nmap_out = "nmap-{0}".format(target)
            nmap_opts = ["-PN", "-sS", "-p", nmap_ports, "-oA", nmap_out]
            nmap_cmd = [nmap_bin] + nmap_opts + [target]
            logging.info("Running nmap against {0}", target)
            logging.debug("Nmap cmd: {0}".format(nmap_cmd))
            try:
                subprocess.call(nmap_cmd)
            except subprocess.CalledProcessError as e:
                logging.exception("Cannot run: {0}".format(e))
