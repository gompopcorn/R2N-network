# host1:
docker-compose -f docker-compose-host1.yaml up -d
# Host2:
docker-compose -f docker-compose-host2.yaml up -d
# Host3:
docker-compose -f docker-compose-host3.yaml up -d





# create channel

# org1:
docker exec cli peer channel create -o orderer0.org1.example.com:7050 -c mychannel -f ./channel-artifacts/mychannel.tx --tls --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/peers/orderer0.org1.example.com/msp/tlscacerts/tlsca.example.com-cert.pem

docker exec cli peer channel join -b mychannel.block

docker exec -e CORE_PEER_ADDRESS=peer1.org1.example.com:8051 -e CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/peers/peer1.org1.example.com/tls/ca.crt cli peer channel join -b mychannel.block

# host1:
docker cp cli:/opt/gopath/src/github.com/hyperledger/fabric/peer/mychannel.block .

