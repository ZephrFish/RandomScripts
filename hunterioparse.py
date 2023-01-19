# python3 hunterioparse.py domain.com out.csv
import requests
import csv
import sys

# Replace YOUR_API_KEY with your actual Hunter.io API key
api_key = 'YOUR_API_KEY'

# Get the domain name from the command line argument
if len(sys.argv) < 2:
    print("Please provide the domain name as a command line argument")
    exit()
domain = sys.argv[1]

# Get the CSV file name from the command line argument
if len(sys.argv) < 3:
    print("Please provide the CSV file name as a command line argument")
    exit()
csv_file_name = sys.argv[2]

try:
    # Send GET request to Hunter.io API
    response = requests.get(f'https://api.hunter.io/v2/email-finder?domain={domain}&api_key={api_key}')
    # Get the data from the response
    data = response.json()
    if response.status_code != 200:
        print(f'Error: {response.json()}')
        exit()

    if 'data' not in data:
        print(f'No data found for {domain}')
        exit()

    if 'emails' not in data['data']:
        print(f'No emails found for {domain}')
        exit()
    # Extract the email addresses from the data
    emails = [result['value'] for result in data['data']['emails']]

    # Create a CSV file and write the email addresses to it
    with open(csv_file_name, mode='w') as csv_file:
        fieldnames = ['email']
        writer = csv.DictWriter(csv_file, fieldnames=fieldnames)
        writer.writeheader()
        for email in emails:
            writer.writerow({'email': email})
except requests.exceptions.HTTPError as errh:
    print ("HTTP Error:",errh)
except requests.exceptions.ConnectionError as errc:
    print ("Error Connecting:",errc)
except requests.exceptions.Timeout as errt:
    print ("Timeout Error:",errt)
except requests.exceptions.RequestException as err:
    print ("Something went wrong",err)
