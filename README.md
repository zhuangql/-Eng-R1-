# -Eng-R1-

一、mandatory task：
1、oracle合约的 compute 和 callback接口实现请见 Oracle.sol文件（可编译过）

2、gateway的java代码实现，请见callOracle.java文件（注意：java文件只提供了代码实现逻辑，编译不过）

3、模拟用户调用合约的compute函数并return结果，即用合约调用 Oracle合约的 compute接口，时间不足，在此不做实现。


二、optional task:
选择的 task 2，大概实现请见 Oracle.sol 中的 compute函数

1、链下签名，使用类似uniswap中实现的签名方式，通过nonce保证签名只有一次有效。就可以防止恶意的gateway取走用户预存的ETH。

2、用户预存ETH，可以先当作用户质押ETH到Oracle，同时Oracle记录质押余额。每调用接口后，扣减用户质押的ETH作为手续费，在返回结果给用户。