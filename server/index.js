var AWS = require('aws-sdk');
var dynamo = new AWS.DynamoDB.DocumentClient();

exports.handler = async (event, context, callback) => {

    const dbParams = {
        "TableName": "usuarios"
    }

    let resBody = null;
    let reqBody = JSON.parse(event['body'])
    let operation = reqBody['operation'];
    let insertItem = null;
    const maximoInsert = 50;

    try {

        if (operation == 'scan') {
            resBody = await getAll(dbParams);
        }

        if (operation == 'create') {

            let todosItens = await getAll(dbParams);

            if (todosItens.length >= maximoInsert) {
                resBody = {
                    "message": `Contagem excede o máximo: atual ${todosItens.length}, máximo: ${maximoInsert}`
                };
            }
            else {
                let chave = Date.now().toString();
                insertItem = {
                    ...dbParams,
                    ...{
                        Item: {
                            "UserId": chave,
                            ...reqBody['data']
                        }
                    }
                };
                await dynamo.put(insertItem).promise();

                resBody = await dynamo.get({
                    ...dbParams,
                    Key: {
                        "UserId": chave
                    }
                }).promise();
            }
        }

        if (operation == 'wipe') {
            let all = await getAll(dbParams);
            for (var i = 0; i < all.length; i++) {

                let deletar = {
                    ...dbParams,
                    "Key": {
                        "UserId": all[i]['UserId']
                    }
                }
                await dynamo.delete(deletar).promise();
            }

            resBody = {
                "message": "Dados apagados"
            };
        }
    }
    catch (e) {
        resBody = e;
    }

    if (operation == 'ping')
        resBody = { "pong": "pong" };

    const res = {
        "statusCode": 200,
        "headers": {
            "content-type": "application/json"
        },
        "body": JSON.stringify(

            resBody

        ),
        "isBase64Encoded": false
    };

    return res;
};

async function getAll(dbParams) {
    let retorno = []
    let items = [];
    do {
        items = await dynamo.scan(dbParams).promise();
        items.Items.forEach((item) => retorno.push(item));
        dbParams.ExclusiveStartKey = items.LastEvaluatedKey;
    } while (typeof items.LastEvaluatedKey !== "undefined");

    return retorno;
}

