#!/bin/bash

# inpit variables
# CHANNEL_NAME=$1
# CC_NAME=$2
# id=$3
# make=$4
# model=$5
# colour=$6
# owner=$7

CHANNEL_NAME="mychannel"
CC_NAME="fabcar"
id="bash_car"
make="Toyota"
model="Fj_Crouser"
colour="Green"
owner="Alireza.HN"


# paths, addresses and ports
addr_peer0_org1="peer0.org1.example.com"
addr_peer0_org2="peer0.org2.example.com"
addr_peer0_org3="peer0.org3.example.com"
addr_orderer0_org1="orderer0.org1.example.com"

port_peer0_org1="7051"
port_peer0_org2="9051"
port_peer0_org3="11051"
port_orderer0_org1="7050"

# path_cafile="/etc/hyperledger/channel/crypto-config/peerOrganizations/org1.example.com/orderers/orderer0.org1.example.com/tls/tlscacerts/tls-localhost-7054-ca-org1-example-com.pem"
# path_tlsRootCertFiles_org1="/etc/hyperledger/channel/crypto-config/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt"
# path_tlsRootCertFiles_org2="/etc/hyperledger/channel/crypto-config/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/ca.crt"
# path_tlsRootCertFiles_org3="/etc/hyperledger/channel/crypto-config/peerOrganizations/org3.example.com/peers/peer0.org3.example.com/tls/ca.crt"

# CORE_PEER_MSPCONFIGPATH="/etc/hyperledger/channel/crypto-config/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp"
# CORE_PEER_ADDRESS=$addr_peer0_org1:$port_peer0_org1
# ORDERER_CA="/etc/hyperledger/channel/crypto-config/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem"
# VERSION="1"


# loop variables
counter=1
numOfAdds=10
id="car_$counter"


path_cafile="/usr/local/go/src/github.com/hyperledger/fabric-samples/raft-2node/org1/crypto-config/peerOrganizations/org1.example.com/orderers/orderer0.org1.example.com/tls/tlscacerts/tls-localhost-7054-ca-org1-example-com.pem"
path_tlsRootCertFiles_org1="/usr/local/go/src/github.com/hyperledger/fabric-samples/raft-2node/org1/crypto-config/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt"
path_tlsRootCertFiles_org2="/usr/local/go/src/github.com/hyperledger/fabric-samples/raft-2node/org2/crypto-config/peerOrganizations/org2.example.com/peers/peer1.org2.example.com/tls/ca.crt"
path_tlsRootCertFiles_org3="/usr/local/go/src/github.com/hyperledger/fabric-samples/raft-2node/org3/crypto-config/peerOrganizations/org3.example.com/peers/peer0.org3.example.com/tlsca.crt"

CORE_PEER_MSPCONFIGPATH="/usr/local/go/src/github.com/hyperledger/fabric-samples/raft-2node/artifacts/channel/config"
CORE_PEER_ADDRESS=$addr_peer0_org1:$port_peer0_org1
ORDERER_CA="/usr/local/go/src/github.com/hyperledger/fabric-samples/raft-2node/org1/crypto-config/peerOrganizations/org1.example.com/orderers/orderer0.org1.example.com/tls/tlscacerts/tls-localhost-7054-ca-org1-example-com.pem"
VERSION="1"



export CORE_PEER_MSPCONFIGPATH=$CORE_PEER_MSPCONFIGPATH
export CORE_PEER_ADDRESS=$CORE_PEER_ADDRESS
export ORDERER_CA=$ORDERER_CA
export VERSION=$VERSION

peer chaincode invoke -o $addr_orderer0_org1:$port_orderer0_org1 --ordererTLSHostnameOverride $addr_orderer0_org1 \
--tls --cafile $path_cafile -C $CHANNEL_NAME -n $CC_NAME \
--peerAddresses $addr_peer0_org1:$port_peer0_org1 --tlsRootCertFiles $path_tlsRootCertFiles_org1 \
--peerAddresses $addr_peer0_org2:$port_peer0_org2 --tlsRootCertFiles $path_tlsRootCertFiles_org2 \
--peerAddresses $addr_peer0_org3:$port_peer0_org3 --tlsRootCertFiles $path_tlsRootCertFiles_org3 \
-c '{"function": "createCar", "Args":["$id", "$make", "$model", "$colour", "$owner"]}'



# createCar() 
# {
#     cat << EOF | docker exec --interactive cli bash

#     export CORE_PEER_MSPCONFIGPATH=$CORE_PEER_MSPCONFIGPATH
#     export CORE_PEER_ADDRESS=$CORE_PEER_ADDRESS
#     export ORDERER_CA=$ORDERER_CA
#     export VERSION=$VERSION

#     peer chaincode invoke -o $addr_orderer0_org1:$port_orderer0_org1 --ordererTLSHostnameOverride $addr_orderer0_org1\ 
#     --tls --cafile $path_cafile -C $CHANNEL_NAME -n $CC_NAME \
#     --peerAddresses $addr_peer0_org1:$port_peer0_org1 --tlsRootCertFiles $path_tlsRootCertFiles_org1 \
#     --peerAddresses $addr_peer0_org2:$port_peer0_org2 --tlsRootCertFiles $path_tlsRootCertFiles_org2 \
#     --peerAddresses $addr_peer0_org3:$port_peer0_org3 --tlsRootCertFiles $path_tlsRootCertFiles_org3 \
#     -c '{"function": "createCar", "Args":["$1", "$2", "$3", "$4", "$5"]}'

# EOF
# }



# while [ $counter -le $numOfAdds ]
# do

#     createCar "$id" "$make" "$model" "$colour" "$owner" &

#     counter=$((counter + 1))
#     id="car_$counter"

#     # sleep $delay

# done





# peer chaincode query -C mychannel -n fabcar -c '{"function": "queryCar","Args":["${id}"]}'
