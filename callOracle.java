

public static void main(String[] args) {

    try {

        //1、java spring 框架监听http上链请求

        //2、调用合约接口 compute 方法
        byte[] input = new byte[10];//初始化用户调用合约的方法和入参
        Long deadline = new Date(System.currentTimeMillis() + 1000 * 60 * 3).getTime();
        final org.web3j.abi.datatypes.Function function = new org.web3j.abi.datatypes.Function(
                "compute",
                Arrays.<Type>asList(new DynamicBytes(input),
                        new Uint256(deadline)),
                Collections.<TypeReference<?>>emptyList());
        String data = FunctionEncoder.encode(function);

        long chainId = 1L;
        BigInteger nonce = BigInteger.valueOf(1);
        BigInteger gasPrice = BigInteger.valueOf(210000);
        BigInteger gasLimit = BigInteger.valueOf(210000);
        String to = "oracle合约地址";
        BigInteger value = new BigInteger("1e16");
        RawTransaction rawTransaction = RawTransaction.createTransaction( nonce, gasPrice, gasLimit, to, value, data);

        Web3j web3j = Web3j.build(new HttpService("http://127.0.0.1:8545"));
        Credentials credentials = Credentials.create("私钥");
        RawTransactionManager rawTransactionManager = new RawTransactionManager(web3j, credentials);
        EthSendTransaction ethSendTransaction = rawTransactionManager.signAndSend(rawTransaction);
        String txHash = ethSendTransaction.getTransactionHash();

        //3、调用合约接口 callback 方法
        //过程同2 调用compute方法

    } catch (Exception e) {
        e.printStackTrace();
    }

}
