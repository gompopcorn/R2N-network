const { Gateway, Wallets, TxEventHandler, GatewayOptions, DefaultEventHandlerStrategies, TxEventHandlerFactory } = require('fabric-network');
const fs = require('fs');
const path = require("path")
const log4js = require('log4js');
const logger = log4js.getLogger('BasicNetwork');
const util = require('util')

// const createTransactionEventHandler = require('./MyTransactionEventHandler.ts')

const helper = require('./helper')

// const createTransactionEventHandler = (transactionId, network) => {
//     /* Your implementation here */
//     const mspId = network.getGateway().getIdentity().mspId;
//     const myOrgPeers = network.getChannel().getEndorsers(mspId);
//     return new MyTransactionEventHandler(transactionId, network, myOrgPeers);
// }

const invokeTransaction = async (channelName, chaincodeName, fcn, args, username, org_name, transientData) => {
    try {
        logger.debug(util.format('\n============ invoke transaction on channel %s ============\n', channelName));

        // load the network configuration
        // const ccpPath =path.resolve(__dirname, '..', 'config', 'connection-org1.json');
        // const ccpJSON = fs.readFileSync(ccpPath, 'utf8')
        const ccp = await helper.getCCP(org_name) //JSON.parse(ccpJSON);

        // Create a new file system based wallet for managing identities.
        const walletPath = await helper.getWalletPath(org_name) //path.join(process.cwd(), 'wallet');
        const wallet = await Wallets.newFileSystemWallet(walletPath);
        console.log(`Wallet path: ${walletPath}`);

        // Check to see if we've already enrolled the user.
        let identity = await wallet.get(username);
        if (!identity) {
            console.log(`An identity for the user ${username} does not exist in the wallet, so registering user`);
            await helper.getRegisteredUser(username, org_name, true)
            identity = await wallet.get(username);
            console.log('Run the registerUser.js application before retrying');
            return;
        }



        const connectOptions = {
            wallet, identity: username, discovery: { enabled: true, asLocalhost: false },
            eventHandlerOptions: {
                commitTimeout: 100,
                strategy: DefaultEventHandlerStrategies.NETWORK_SCOPE_ALLFORTX
            }
            // transaction: {
            //     strategy: createTransactionEventhandler()
            // }
        }

        // Create a new gateway for connecting to our peer node.
        const gateway = new Gateway();
        await gateway.connect(ccp, connectOptions);

        // Get the network (channel) our contract is deployed to.
        const network = await gateway.getNetwork(channelName);

        const contract = network.getContract(chaincodeName);

        // let result
        // let message;
        // switch (fcn) {
        //     case "CreateInvoice":
        //         result = await contract.submitTransaction(fcn, args[0]);
        //         // obj = JSON.stringify(JSON.parse(args[0]))
        //         // console.log(JSON.parse(args[0]))
        //         message = `Successfully added the Invoice Data`
        //         break;
        //     case "UpdateInvoice":
        //         if (org_name == "Org1") {
        //             return { message: "Only Organization 2 is allowed to add transactions" }
        //         } else {
        //             result = await contract.submitTransaction(fcn, args[0], args[1], args[2]);
        //             // obj = JSON.stringify(JSON.parse(args[0]))
        //             // console.log(JSON.parse(args[0]))
        //             message = `Successfully updated the Invoice Data`
        //             break;
        //         }


        //     // case ""

        //     default:
        //         return utils.getResponsePayload("Please send correct chaincode function name", null, false)
        //         break;
        // }
        let result
        let message;
        if (fcn === "createCar" || fcn === "createPrivateCarImplicitForOrg1"
            || fcn == "createPrivateCarImplicitForOrg2") {
            result = await contract.submitTransaction(fcn, args[0], args[1], args[2], args[3], args[4]);
            message = `Successfully added the car asset with key ${args[0]}`

        } else if (fcn === "changeCarOwner") {
            result = await contract.submitTransaction(fcn, args[0], args[1]);
            message = `Successfully changed car owner with key ${args[0]}`
        } else if (fcn == "createPrivateCar" || fcn == "updatePrivateData") {
            console.log(`Transient data is : ${transientData}`)
            let carData = JSON.parse(transientData)
            console.log(`car data is : ${JSON.stringify(carData)}`)
            let key = Object.keys(carData)[0]
            const transientDataBuffer = {}
            transientDataBuffer[key] = Buffer.from(JSON.stringify(carData.car))
            result = await contract.createTransaction(fcn)
                .setTransient(transientDataBuffer)
                .submit()
            message = `Successfully submitted transient data`
        }
        else {
            return `Invocation require either createCar or changeCarOwner as function but got ${fcn}`
        }
        await gateway.disconnect();

        // result = JSON.parse(result.toString());

        let response = {
            message: message
            // result
        }

        // let response = {
        //     message: message,
        //     result
        // }

        return response;


    } catch (error) {

        console.log(`Getting error: ${error}`)
        return error.message

    }
}

exports.invokeTransaction = invokeTransaction;