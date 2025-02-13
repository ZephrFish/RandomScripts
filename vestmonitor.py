import yfinance as yf
import time
import argparse
import requests
from datetime import datetime
from tabulate import tabulate

def get_stock_price(ticker):
    """Fetch the current share price for the given stock using Yahoo Finance API."""
    stock = yf.Ticker(ticker)
    price = stock.history(period="1d")["Close"].iloc[-1]
    timestamp = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    return price, timestamp

def get_usd_to_gbp_exchange_rate():
    """Fetch the latest USD to GBP exchange rate."""
    response = requests.get("https://api.exchangerate-api.com/v4/latest/USD")
    if response.status_code == 200:
        return response.json().get("rates", {}).get("GBP", 0.0)
    return 0.78  # Default fallback exchange rate

def calculate_vesting_amount(stock_price, shares_due_to_vest, exchange_rate):
    rsu_amount_usd = shares_due_to_vest * stock_price
    rsu_amount_gbp = rsu_amount_usd * exchange_rate
    return rsu_amount_usd, rsu_amount_gbp

def monitor_stock_price(ticker, shares_due_to_vest):
    print(f"Monitoring ${ticker} every 15 minutes...")
    while True:
        stock_price, timestamp = get_stock_price(ticker)
        exchange_rate = get_usd_to_gbp_exchange_rate()
        rsu_amount_usd, rsu_amount_gbp = calculate_vesting_amount(stock_price, shares_due_to_vest, exchange_rate)

        table_data = [["Timestamp", timestamp],
                      ["Stock Price (USD)", f"${stock_price:.2f}"],
                      ["Exchange Rate (USD -> GBP)", f"{exchange_rate:.4f}"],
                      ["Shares Due to Vest", shares_due_to_vest],
                      ["Total RSU Value (USD)", f"${rsu_amount_usd:.2f}"],
                      ["Total RSU Value (GBP)", f"£{rsu_amount_gbp:.2f}"]]

        print(tabulate(table_data, headers=["Metric", "Value"], tablefmt="grid"))
        print("Refreshing in 15 minutes...")
        time.sleep(900)  # Wait 15 minutes

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Stock Price Monitor for RSU Vesting")
    parser.add_argument("--stock", type=str, required=True, help="Stock ticker to monitor")
    parser.add_argument("--amount", type=int, required=True, help="Number of shares due to vest")
    args = parser.parse_args()

    monitor_stock_price(args.stock, args.amount)
