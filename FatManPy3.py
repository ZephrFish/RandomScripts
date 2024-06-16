#!/usr/bin/env python3
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
    """
    Zone Transfer function.
    Takes line from file, finds nameservers,
    and tries AXFR on each nameserver for domain.
    """
    domain = line.replace("www.", "").strip()
    try:
        ns_records = dns.resolver.resolve(domain, 'NS')
        for ns in ns_records.rrset:
            server = str(ns).rstrip('.')
            try:
                zone = dns.zone.from_xfr(dns.query.xfr(server, domain, lifetime=5))
                if zone is not None:
                    report(zone, domain, server)
            except Exception:
                continue
    except Exception:
        return


def report(zone, domain, ns):
    """
    Handles output from successful transfers.
    Formats strings and attempts to make them look pretty.
    """
    if not domain.strip():
        domain = ns
    output = '{}: {}'.format('ZT!', domain)
    print(output)
    
    filename = os.path.join(savedir, domain + '_output.txt')
    with open(filename, 'a') as f:
        for host, data in zone.nodes.items():
            for record in data.rdatasets:
                record_data = str(record).split()
                if "SOA" in record_data[2]:
                    f.write(format_soa_record(domain, record_data))
                elif "TXT" in record_data[2] or "PTR" in record_data[2]:
                    f.write(format_txt_or_ptr_record(host, domain, record_data))
                else:
                    f.write(format_other_record(host, domain, record_data))


def format_soa_record(domain, record_data):
    """
    Formats an SOA record for output.
    """
    return (f"{domain}\t {record_data[0]}\t {record_data[1]}\t {record_data[2]}\t {record_data[3]} {record_data[4]} (\n"
            f"\t {record_data[5]} \t: Serial,\n"
            f"\t {record_data[6]} \t: Refresh,\n"
            f"\t {record_data[7]} \t: Retry,\n"
            f"\t {record_data[8]} \t: Expire,\n"
            f"\t {record_data[9]} \t: Minimum TTL\n)\n")


def format_txt_or_ptr_record(host, domain, record_data):
    """
    Formats a TXT or PTR record for output.
    """
    host = domain if host == '@' else host
    return f"{host}\t {record_data[0]}\t {record_data[1]}\t {record_data[2]}\t {' '.join(record_data[3:])}\n"


def format_other_record(host, domain, record_data):
    """
    Formats other types of records for output.
    """
    host = domain if host == '@' else (f"{host}.{domain}" if domain not in host else host)
    return f"{host}\t {record_data[0]}\t {record_data[1]}\t {record_data[2]}\t {' '.join(record_data[3:])}\n"


if __name__ == '__main__':
    parser = argparse.ArgumentParser(
        description="Attempt to perform a DNS zone transfer against targets in a file.")
    parser.add_argument("--targets-file", dest="targets_file", default="domains.txt",
                        help="A file containing target domains.")
    parser.add_argument("--save-dir", dest="save_dir", default=".",
                        help="A directory to save transfer results.")
    args = parser.parse_args()

    savedir = args.save_dir
    start_count = len(os.listdir(savedir))
    
    with open(args.targets_file, "r") as file:
        domains = file.readlines()
    
    total_domains = len(domains)
    with Pool(processes=25) as pool:
        pool.map(ztit, domains)
    
    end_count = len(os.listdir(savedir))
    successful_transfers = end_count - start_count
    success_rate = (successful_transfers / total_domains) * 100
    
    result_message = (f"\033[01;38mWe got {successful_transfers} Zone transfers out of {total_domains} "
                      f"with a hit rate of {success_rate:.2f}%\033[1;m")
    print(result_message)
