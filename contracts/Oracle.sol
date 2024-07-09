// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

// Uncomment this line to use console.log
// import "hardhat/console.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Oracle is Ownable {

    uint public input;

    mapping(address => uint) userNonce;
    address public WETH;

    uint private unlocked = 1;
    modifier lock() {
        require(unlocked == 1, 'Oracle: LOCKED');
        unlocked = 0;
        _;
        unlocked = 1;
    }

    modifier ensure(uint deadline) {
        require(deadline >= block.timestamp, 'Oracle: EXPIRED');
        _;
    }

    function compute(bytes[] calldata data, uint deadline, string memory signature, uint nonce, address user) external payable ensure(deadline) lock() returns (bytes[] memory results) {

        require(msg.value >= 0.01 ether, "Oracle: Insufficient fund");
        require(userNonce[user] == nonce, "Oracle: Insufficient fund");
        userNonce[user]++;
        _safeTransferFrom(WETH, user, address(this), 0.01 ether);

        //验签

        results = new bytes[](data.length);
        for (uint256 i = 0; i < data.length; i++) {
            (bool success, bytes memory result) = address(this).delegatecall(data[i]);

            if (!success) {
                // Next 5 lines from https://ethereum.stackexchange.com/a/83577
                if (result.length < 68) revert();
                assembly {
                    result := add(result, 0x04)
                }
                revert(abi.decode(result, (string)));
            }

            results[i] = result;
        }

        if (msg.value > 0.01 ether) _safeTransferETH(msg.sender, msg.value - 0.01 ether);
        
    }

    function _safeTransferETH(address to, uint256 value) internal {
        (bool success, ) = to.call{value: value}(new bytes(0));
        require(success, 'STE');
    }

    function _safeTransferFrom(
        address token,
        address from,
        address to,
        uint256 value
    ) internal {
        // bytes4(keccak256(bytes('transferFrom(address,address,uint256)')));
        (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x23b872dd, from, to, value));
        require(
            success && (data.length == 0 || abi.decode(data, (bool))),
            'TransferHelper::transferFrom: transferFrom failed'
        );
    }

    function callback(uint input_, uint deadline) external payable onlyOwner() ensure(deadline) {
        input = input_;
    }

}
