# Short Term
1. Write a simple web server that runs on modifiable TLS (specifically handshake certificate send step needs to be modifiable)
2. Connect this with the client and test w/o certificate
# Long Term
1. Set up the server (using web3 libraries) to interface with the contract to request a certificate
2. Set up the server to display the contract's validation message such that validator nodes can confirm it via DV
3. Test with client w/ certificate in place on blockchain (shouldn't involve any changes to server protocol except for responding in TLS handshake w/ cert. number instead of cert. itself)
