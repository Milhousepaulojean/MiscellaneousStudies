module.exports = function (app) {

    this.callServicesGetTypeUrlAntigaItems = async function () {
        console.log("services");

        let object = await app.repository.repositorySample.callDynamoGetTypeUrlAntigaItems();

        // //console.log(object.Items)

        // let objectjson = {};

        // let i = 0;
        // let j = 0;
        // const objectFinal = object.Items.map(objItem => {
        //     switch (objItem["campo3Amigo"]) {
        //         case "5pir44f5c":
        //             i++;
        //             break;

        //         default:
        //             j++;
        //             break;
        //     }

        // });

        // objectjson.total = i + j;
        // objectjson.totalA = j;
        // objectjson.totalB = i;

        //console.log(`count total amigo: ${i}, \n count total sem amigo: ${j}`)
        return object;
    }

    return this;
}
