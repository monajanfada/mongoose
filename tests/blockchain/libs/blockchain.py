import rlp
from eth_utils import decode_hex
from eth_rlp.transactions import LegacyTransaction
from robot.api.deco import keyword


@keyword(name='Decode Raw Transaction')
def decode_raw_transaction(raw_tx_hex):
    raw_tx_bytes = decode_hex(raw_tx_hex)
    decoded_tx = rlp.decode(raw_tx_bytes, LegacyTransaction)
    # Convert the transaction to a dictionary
    # tx_dict = {
    #     "nonce": decoded_tx.nonce,
    #     "gasPrice": decoded_tx.gas_price,
    #     "gas": decoded_tx.gas,
    #     "to": decoded_tx.to,
    #     "value": decoded_tx.value,
    #     "data": decoded_tx.data,
    #     "v": decoded_tx.v,
    #     "r": decoded_tx.r,
    #     "s": decoded_tx.s,
    # }
    return tx_dict
