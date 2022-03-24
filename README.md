# EthCA
A trustless certificate authority system built on a private ethereum blockchain
# Components
1. Private Ethereum Blockchain with Solidity Smart Contract that provides proof-of-stake domain validation certificates stored transparently on the blockchain
2. Validator nodes for above, which stake ethereum on their validations and in exchange receive rewards if their validation is agreed upon
3. Client that is capable of checking the blockchain for a valid certificate at time of connection to confirm domain ownership of public key
4. Server capable of requesting certificate and displaying it appropriately to client at connection time
