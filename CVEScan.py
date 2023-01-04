# CVE Scanner
# The file should contain one operating system per line. For example:
# Example: python scan_cves.py affected_operating_systems.txt
# Copy code
# Windows
# Linux

import argparse
import requests

def scan_cves(affected_operating_systems_file):
  # Read the list of affected operating systems from the file
  with open(affected_operating_systems_file, 'r') as f:
    affected_operating_systems = [line.strip() for line in f]
  
  # Set the URL for the National Vulnerability Database (NVD) API
  url = 'https://services.nvd.nist.gov/rest/json/cves/1.0'

  # Set the parameters for the API call
  params = {
    'resultsPerPage': '20',  # Number of results per page
    'startIndex': '0'  # Starting index for the results
  }

  # Make the API call and store the response
  response = requests.get(url, params=params)

  # Check the status code of the response
  if response.status_code == 200:
    # Convert the response to a dictionary
    cve_data = response.json()

    # Get the list of CVEs
    cves = cve_data['result']['CVE_Items']

    # Iterate through the list of CVEs
    for cve in cves:
      # Get the CVE number
      cve_number = cve['cve']['CVE_data_meta']['ID']

      # Get the list of affected products
      affected_products = cve['cve']['affects']['vendor']['vendor_data']

      # Iterate through the list of affected products
      for product in affected_products:
        # Get the name of the product
        product_name = product['product']['product_data'][0]['product_name']

        # Check if the product is in the list of affected operating systems
        if product_name in affected_operating_systems:
          print(f'CVE {cve_number} affects {product_name}')
  else:
    print('An error occurred while making the API call')

# Set up the argument parser
parser = argparse.ArgumentParser(description='Scan for the latest CVE numbers and check the affected operating system against a list')
parser.add_argument('affected_operating_systems_file', type=str, help='File containing the list of affected operating systems')

# Parse the command line arguments
args = parser.parse_args()

# Call the scan_cves function with the file containing the list of affected operating systems as the argument
scan_cves(args.affected_operating_systems_file)
