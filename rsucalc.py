# needs yfinance; pip3 install yfinance
import yfinance as yf
import requests
import argparse

def get_stock_price(ticker):
    """Fetch the current share price for the given stock using Yahoo Finance API."""
    print(f"Fetching current share price for ${ticker}...")
    stock = yf.Ticker(ticker)
    price = stock.history(period="1d")["Close"].iloc[-1]
    print(f"Current ${ticker} share price retrieved: ${price:.2f}")
    return price

def get_usd_to_gbp_exchange_rate():
    """Fetch the latest USD to GBP exchange rate."""
    print("Fetching latest USD to GBP exchange rate...")
    response = requests.get("https://api.exchangerate-api.com/v4/latest/USD")
    if response.status_code == 200:
        exchange_rate = response.json().get("rates", {}).get("GBP", 0.0)
        print(f"Current USD to GBP exchange rate: {exchange_rate:.4f}")
        return exchange_rate
    print("Failed to fetch exchange rate. Defaulting to 0.78.")
    return 0.78  # Default fallback exchange rate

def calculate_rsu_net(rsu_amount, income_tax_rate, employee_ni_rate, employer_ni_rate):
    """Calculate net RSU amount after employer NI, income tax, and employee NI deductions."""
    rsu_taxable = rsu_amount * (1 - employer_ni_rate)
    income_tax = rsu_taxable * income_tax_rate
    employee_ni = rsu_taxable * employee_ni_rate
    net_amount = rsu_taxable - (income_tax + employee_ni)
    return net_amount

def main():
    parser = argparse.ArgumentParser(description="RSU Tax Calculator")
    parser.add_argument("--stock", type=str, help="Stock ticker to fetch share price")
    parser.add_argument("--simple", action="store_true", help="Simple calculation mode")
    parser.add_argument("--complex", action="store_true", help="Complex calculation mode")
    args = parser.parse_args()

    if args.simple:
        rsu_amount = float(input("Enter RSU amount before tax: "))
    
    elif args.complex and args.stock:
        stock_price = get_stock_price(args.stock)
        exchange_rate = get_usd_to_gbp_exchange_rate()
        shares_due_to_vest = float(input("Enter the number of shares due to vest: "))
        rsu_amount_usd = shares_due_to_vest * stock_price
        rsu_amount = rsu_amount_usd * exchange_rate
        print(f"Total RSU amount in USD: ${rsu_amount_usd:.2f}")
        print(f"Total RSU amount in GBP (after conversion): £{rsu_amount:.2f}")
    
    else:
        print("Please specify --simple or --complex with --stock <ticker>")
        return
    
    income_tax_rate = float(input("Enter income tax rate (e.g., 0.48 for 48%): "))
    employee_ni_rate = float(input("Enter employee NI rate (e.g., 0.02 for 2%): "))
    employer_ni_rate = float(input("Enter employer NI rate (e.g., 0.15 for 15%): "))
    
    net_amount = calculate_rsu_net(rsu_amount, income_tax_rate, employee_ni_rate, employer_ni_rate)
    print(f"Net amount received after deductions: £{net_amount:.2f}")

if __name__ == "__main__":
    main()
