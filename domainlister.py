# Domain Lister
# Debug Script
import argparse

def debug():
        url = input("Enter URL>")
        portList = [80,443,5800,8080,9090,10000]
        for port in portList:
            verbose('[+] hosts running on port %r' % str(port))
            print('https://' + url + ':'+ str(port))
            print('http://' + url + ':' + str(port))

# Verbose Mode
def verbose(v):
    if args.verbose:
        print(v)

# Main Function
# Lists out urls with ports appended
def main():
    if args.debug:
        print('[!] Debug Mode [ON] OFF')
        debug()
    else:
        print('[!] No Flag Given')
        print('[!] Quitting...')
        quit()

# Argument Parsing
if __name__ == "__main__":
    parser = argparse.ArgumentParser(
        description='Domain Lister',
        prog="lister.py",
        usage='%(prog)s [options]'
    )
    parser.add_argument('--verbose', action='store_true', help='turn on verbose mode')
    parser.add_argument('--debug', action='store_true', help='turn on debug')
    args = parser.parse_args()

main()
