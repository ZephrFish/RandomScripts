# TCP Port Scanner
# ZephrFish 2022 - Quick and Dirty port scanner takes initial port and last port then checks if open or not
# python3 portscanner.py x.x.x.x 0 65535
import socket
import sys 
import ipaddress

openports = []

def scanhost(ip_addr, port):
    print(f'Scanning {ip_addr}')
    for port in ports:
        try:
            tcp = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
            if not tcp.connect_ex((ip_addr, port)):
                print(f"TCP Port {port} Open on {ip_addr}")
                openports.append(port)
                tcp.close()

        except Exception:
            pass

    print(f'Finished Scanning {ip_addr}, the following TCP ports are open {openports}')

if __name__ == '__main__':
    socket.setdefaulttimeout(0.01)
    args = sys.argv
    ip_addr = args[1]
    firstport = int(args[2])
    lastport = int(args[3]) 
    ports = range(firstport, lastport)
     
    try:
        if not firstport >= 0:
            sys.exit(f"{args[2]} not a valid port number, select a number greater than 0")
        elif not lastport <= 65535:
            sys.exit(f"{args[3]} not a valid port number, select a number less than 65535")
        elif not ipaddress.ip_address(ip_addr):
            sys.exit(f"{args[1]} not a valid IP address.")
 
    except ValueError:
        sys.exit("Please enter a valid port range > 0 and < 65535 or valid IP address")

    scanhost(ip_addr, ports)
