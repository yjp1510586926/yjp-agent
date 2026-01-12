# /gas - Gas 优化建议命令

分析指定的 Solidity 合约或 Web3 交互代码，提供 Gas 优化建议：

1. **存储优化**
   - 变量打包建议
   - 使用 mapping vs array
   - 避免重复 SLOAD

2. **循环优化**
   - 缓存数组长度
   - 避免循环内的存储操作

3. **函数优化**
   - external vs public
   - calldata vs memory
   - 短路求值

请分析: $ARGUMENTS
