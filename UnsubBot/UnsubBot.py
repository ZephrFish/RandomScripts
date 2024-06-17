import os
import base64
import re
import requests
import argparse
from urllib.parse import urlparse
from google.auth.transport.requests import Request
from google.oauth2.credentials import Credentials
from google_auth_oauthlib.flow import InstalledAppFlow
from googleapiclient.discovery import build
from bs4 import BeautifulSoup

# If modifying these SCOPES, delete the file token.json.
os.environ['OAUTHLIB_RELAX_TOKEN_SCOPE'] = '1'

SCOPES = ['https://www.googleapis.com/auth/gmail.modify', 'https://mail.google.com']

def get_or_create_label(service, label_name):
    """Get or create a label in the user's mailbox."""
    labels = service.users().labels().list(userId='me').execute().get('labels', [])
    for label in labels:
        if label['name'].lower() == label_name.lower():
            return label['id']

    # If label doesn't exist, create it
    label = {
        "name": label_name,
        "labelListVisibility": "labelShow",
        "messageListVisibility": "show"
    }
    created_label = service.users().labels().create(userId='me', body=label).execute()
    return created_label['id']

def main(skip_confirmation, delete_after_unsub):
    creds = None
    # The file token.json stores the user's access and refresh tokens, and is
    # created automatically when the authorization flow completes for the first time.
    if os.path.exists('token.json'):
        creds = Credentials.from_authorized_user_file('token.json', SCOPES)
    # If there are no (valid) credentials available, let the user log in.
    if not creds or not creds.valid:
        if creds and creds.expired and creds.refresh_token:
            creds.refresh(Request())
        else:
            flow = InstalledAppFlow.from_client_secrets_file(
                'credentials.json', SCOPES)
            creds = flow.run_local_server(port=0)
        # Save the credentials for the next run
        with open('token.json', 'w') as token:
            token.write(creds.to_json())

    service = build('gmail', 'v1', credentials=creds)

    # Get or create the "Unsubscribed Emails" label
    label_id = get_or_create_label(service, "Unsubscribed Emails")

    # Call the Gmail API
    results = service.users().messages().list(userId='me', q="unsubscribe").execute()
    messages = results.get('messages', [])

    if not messages:
        print("No marketing emails found.")
    else:
        print("Marketing emails found:")
        for message in messages:
            msg = service.users().messages().get(userId='me', id=message['id']).execute()
            payload = msg.get('payload', {})
            parts = payload.get('parts', [])
            for part in parts:
                if part.get('mimeType') == 'text/html':
                    data = part['body']['data']
                    decoded_data = base64.urlsafe_b64decode(data.encode('UTF-8')).decode('UTF-8')
                    soup = BeautifulSoup(decoded_data, 'html.parser')
                    unsubscribe_links = soup.find_all('a', string=re.compile("unsubscribe", re.IGNORECASE))
                    for link in unsubscribe_links:
                        href = link.get('href')
                        if href:
                            parsed_url = urlparse(href)
                            if not parsed_url.scheme:
                                # Prepend 'http://' if scheme is missing
                                href = 'http://' + href
                            print(f"Unsubscribe link: {href}")
                            if not skip_confirmation:
                                user_input = input("Do you want to click this unsubscribe link? (yes/Y/return for yes, no for no): ").strip().lower()
                                if user_input not in ('', 'yes', 'y'):
                                    continue
                            try:
                                response = requests.get(href)
                                print(f"Unsubscribe response status: {response.status_code}")
                                # Apply the "Unsubscribed Emails" label
                                service.users().messages().modify(
                                    userId='me',
                                    id=message['id'],
                                    body={'addLabelIds': [label_id]}
                                ).execute()
                                if delete_after_unsub:
                                    service.users().messages().delete(userId='me', id=message['id']).execute()
                                    print(f"Email deleted: {message['id']}")
                            except requests.exceptions.RequestException as e:
                                print(f"Failed to unsubscribe: {e}")

if __name__ == '__main__':
    parser = argparse.ArgumentParser(description="Unsubscribe from marketing emails.")
    parser.add_argument('--skip-confirmation', action='store_true', help="Skip confirmation prompts for unsubscribing.")
    parser.add_argument('--delete-after-unsub', action='store_true', help="Delete emails after unsubscribing.")
    args = parser.parse_args()

    main(args.skip_confirmation, args.delete_after_unsub)