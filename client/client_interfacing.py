from web3 import Web3

w3 = Web3(Web3.IPCProvider('./path/to/geth.ipc'))

file = open("C:\Users\katma\Desktop\CS6501_NSP\project\client\message.txt", "r")
address = '0x8b43D07703a973340E855f22Bd76C61137d4Ed94'
abi = file.read()
contract_instance = w3.eth.contract(address=address, abi=abi)

# block to verify (serial_num)
serial_num = 0

if w3.isConnect():
    # what function to call?
    pk, domain, issued, exp = contract_instance.functions.readCertificate(serial_num)
    print('Domain: ', domain)
else:
    print("Not connected")
    