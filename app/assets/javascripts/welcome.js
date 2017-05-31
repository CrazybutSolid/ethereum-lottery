<script type="text/javascript">
if (typeof web3 !== 'undefined') {
  web3 = new Web3(web3.currentProvider);
} else {
	var Web3 = require('web3');
	var web3 = new Web3(new Web3.providers.HttpProvider('https://ropsten.infura.io/lw3MDy2ASTmOSg0e6aaj'));
	var version = web3.version.api;
	    var contractABI = [ { "constant": false, "inputs": [], "name": "bet", "outputs": [], "payable": true, "type": "function" }, { "constant": true, "inputs": [ { "name": "", "type": "uint256" } ], "name": "gamblers", "outputs": [ { "name": "", "type": "address", "value": "0x0000000000000000000000000000000000000000" } ], "payable": false, "type": "function" }, { "constant": true, "inputs": [], "name": "random", "outputs": [ { "name": "", "type": "uint256", "value": "0" } ], "payable": false, "type": "function" }, { "constant": true, "inputs": [], "name": "my_length", "outputs": [ { "name": "", "type": "uint256", "value": "1" } ], "payable": false, "type": "function" }, { "inputs": [], "payable": false, "type": "constructor" } ];
	    if (contractABI != ''){
	        var MyContract = web3.eth.contract(contractABI);
	        var myContractInstance = MyContract.at("0x20b8c246DCaF8Dd2c739A49c02D0dDfC752C1c07");
	        var signups = myContractInstance.my_length();
	        var gamblers1 = myContractInstance.gamblers(1);
	        var gamblers2 = myContractInstance.gamblers(2);
	        var gamblers3 = myContractInstance.gamblers(3);
	        var gamblers4 = myContractInstance.gamblers(4);
	        var gamblers5 = myContractInstance.gamblers(5);
	         document.getElementById("signups").innerHTML = signups;
	         document.getElementById("gamblers1").innerHTML = gamblers1;
	         document.getElementById("gamblers2").innerHTML = gamblers2;
	         document.getElementById("gamblers3").innerHTML = gamblers3;
	         document.getElementById("gamblers4").innerHTML = gamblers4;
	         document.getElementById("gamblers5").innerHTML = gamblers5;

	    } else {
	        console.log("Error" );
	    }            
	
}
</script>