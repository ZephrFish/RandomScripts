# Unsubscribe Bot
Takes a token and credentials from a Google Cloud app and authenticates to your gsuite, finds marketing emails, tags them and unsubscribes from said emails.

## Prerequisites

- Python 3.6 or higher
- Google Cloud Platform (GCP) account

## Setup Instructions - GCP 
### 1. Set Up Google Cloud Project

1. Go to the [Google Cloud Console](https://console.cloud.google.com/).
2. Click on the project dropdown at the top of the page.
3. Select "New Project" and enter a name for your project.
4. Click "Create."

### 2. Enable Gmail API

1. In the Google Cloud Console, go to the [Gmail API page](https://console.developers.google.com/apis/library/gmail.googleapis.com).
2. Make sure your new project is selected.
3. Click "Enable."

### 3. Set Up OAuth 2.0 Credentials

1. Go to the [Credentials page](https://console.developers.google.com/apis/credentials).
2. Click "Create Credentials" and select "OAuth client ID."
3. You might be prompted to configure the OAuth consent screen:
   - For "User Type," select "External" and click "Create."
   - Fill in the required fields (app name, user support email, developer contact email).
   - Under "Scopes," click "Add or Remove Scopes" and add `https://www.googleapis.com/auth/gmail.modify` and https://mail.google.com scopes.
   - Click "Save and Continue."
4. Under 'OAuth consent screen' Add your email as the test user;
`<screenshot>`
5. After configuring the consent screen, create the OAuth client ID:
   - Choose "Desktop app" as the application type.
   - Enter a name for the OAuth client and click "Create."
6. Download the JSON file by clicking "Download" and save it as `credentials.json` in your project directory.

### 4. Install Required Libraries

Install the necessary libraries using pip:
```bash
pip install -r requirements.txt
```

### 5. Run The Script
Save the script as unsubscribe.py and ensure the credentials.json file is in the same directory. Run the script:
```
python3 -m venv unsub
source unsub/bin/activate
python3 UnsubBot.py
```

The script will throw open a browser and then prompt you to allow your app to connect to GSuite, once accepted it'll do it's work. By default it's setup to ask you if you want to unsub from each link but you can pass the `--skip-confirmation` to just go for it.

## Help
```bash
python3 UnsubBot.py -h
usage: UnsubBot.py [-h] [--skip-confirmation] [--delete-after-unsub]

Unsubscribe from marketing emails.

options:
  -h, --help            show this help message and exit
  --skip-confirmation   Skip confirmation prompts for unsubscribing.
  --delete-after-unsub  Delete emails after unsubscribing.
```

## Bugs?
If you find issues with this script, submit a pull request as it worked for me ;).