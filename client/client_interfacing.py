from web3 import Web3
#from web3.auto import Web3
from web3 import providers

w3 = Web3(Web3.IPCProvider(providers.ipc.get_default_ipc_path()))
#w3 = Web3()

#file = open("C:\Users\katma\Desktop\CS6501_NSP\project\client\message.txt", "r")
#abi = file.read()
address = '0x8b43D07703a973340E855f22Bd76C61137d4Ed94'
abi = [
	{
		"inputs": [
			{
				"internalType": "uint256",
				"name": "id",
				"type": "uint256"
			}
		],
		"name": "cancel_signup",
		"outputs": [],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "uint256",
				"name": "requestID",
				"type": "uint256"
			}
		],
		"name": "endVerification",
		"outputs": [],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "bytes[]",
				"name": "publicKey",
				"type": "bytes[]"
			},
			{
				"internalType": "string",
				"name": "domain",
				"type": "string"
			}
		],
		"name": "issueCertificate",
		"outputs": [
			{
				"internalType": "uint256",
				"name": "",
				"type": "uint256"
			}
		],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "uint256",
				"name": "serialNum",
				"type": "uint256"
			}
		],
		"name": "readCertificate",
		"outputs": [
			{
				"internalType": "bytes[]",
				"name": "publicKey",
				"type": "bytes[]"
			},
			{
				"internalType": "string",
				"name": "domain",
				"type": "string"
			},
			{
				"internalType": "uint256",
				"name": "issued",
				"type": "uint256"
			},
			{
				"internalType": "uint256",
				"name": "exp",
				"type": "uint256"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "string",
				"name": "domain",
				"type": "string"
			}
		],
		"name": "request_verification",
		"outputs": [
			{
				"internalType": "uint256",
				"name": "",
				"type": "uint256"
			}
		],
		"stateMutability": "payable",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "sign_up",
		"outputs": [
			{
				"internalType": "uint256",
				"name": "",
				"type": "uint256"
			}
		],
		"stateMutability": "payable",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "uint256",
				"name": "requestID",
				"type": "uint256"
			},
			{
				"internalType": "bool",
				"name": "voteIn",
				"type": "bool"
			}
		],
		"name": "vote",
		"outputs": [],
		"stateMutability": "nonpayable",
		"type": "function"
	}
]

# block to verify (serial_num)
serial_num = 0
contract_instance = w3.eth.contract(address=address, abi=abi)
pk, domain, issued, exp = contract_instance.functions.readCertificate(serial_num).call()
print('Domain: ', domain)


if w3.isConnected():
    # what function to call?
    pk, domain, issued, exp = contract_instance.functions.readCertificate(serial_num)
    print('Domain: ', domain)
else:
    print("Not connected")
    