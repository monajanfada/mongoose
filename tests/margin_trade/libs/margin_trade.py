import requests
from robot.api.deco import keyword
import time


@keyword(name='Open Position')
def open_position(market: str, side: str, collateral: str,
                  risk_coef: str, open_price: str, stop_loss: str, take_profit: str):
    """
    Open a margin trade position and get id
    """
    url = "https://api-6.staging.k8s.wallex.dev/v1/margin-trade/positions"
    headers = {
        "accept": "application/json",
        "content-type": "application/json",
        "X-Rabbit-API-Key": "some_long_random_string",
        "X-Rabbit-User-ID": "3",
        "X-Rabbit-KYC": "2",
        "X-api-key": "17|dPcIN8a6rDRuxpHfUfd8hpyG9qiSbe43qKt2vTko",
    }
    body = {
        "market": market,
        "side": side,
        "collateral": collateral,
        "risk_coef": risk_coef,
        "open_price": open_price,
        "stop_loss": stop_loss,
        "take_profit": take_profit,
    }

    response = requests.post(url, headers=headers, json=body)
    response_data = response.json()
    time.sleep(10)
    id = response_data.get('result', {}).get('id')
    return id


@keyword(name='Get Status')
def get_status(id):
    """
    Get margin trade status
    """
    url = f"https://api-6.staging.k8s.wallex.dev/v1/margin-trade/positions/{id}"
    headers = {
        "X-api-key": "17|dPcIN8a6rDRuxpHfUfd8hpyG9qiSbe43qKt2vTko",
    }
    id = None
    for _ in range(3):
        try:
            response = requests.get(url, headers=headers)
            response_data = response.json()
            state = response_data.get('result', {}).get('state')
            print('%%%%%%%%%%%%%%%%')
            print(response_data)
            print('%%%%%%%%%%%%%%%%')
            if state == 'CREATED' or state == 'OPEN' or state == 'CLOSING':
                return response_data
        except requests.RequestException as e:
            print(f"The id was empty: {e}")
    return response_data
