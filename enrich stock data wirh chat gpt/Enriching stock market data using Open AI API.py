
import pandas as pd

# import data
ns100 = pd.read_csv('nasdaq100.csv')
ns100pc = pd.read_csv('nasdaq100_price_change.csv')

ns100m = ns100.merge(ns100pc[['symbol','ytd']], on='symbol', how='left')

# Import the OpenAI client
from openai import OpenAI

# Create the OpenAI client and set your API key
client = OpenAI(api_key="")

# classify stocks
for i, row in ns100m.iterrows():
  company = row['name']
  response = client.completions.create(
    # Specify the correct model
    model="gpt-3.5-turbo-instruct",
    prompt=f"""Classify company {company} into one of the following sectors. 
    Answer only with the sector name: Technology, Consumer Cyclical, Industrials, Utilities, Healthcare, 
    Communication, Energy, Consumer Defensive, Real Estate, or Financial.
    """,
    temperature = 0.2
  )
  ns100m.loc[i,'class'] = response.choices[0].text

print(ns100m)


# Find best stocks
company_data = dict(ns100m)

response = client.completions.create(
  # Specify the correct model
  model="gpt-3.5-turbo-instruct",
  prompt=f"""Recommend the three best performers including year to date (YTD) information, founded before 1980.
            Company data: {company_data} 
  """,
  temperature = 0.0,
  max_tokens = 200
)

print(response.choices[0].text)