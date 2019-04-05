|  Variable Type | Key Type  | Value Type |
|:---------------:|:---------:|:-----------:|
| `int / uint`  | :heavy_check_mark:  | :heavy_check_mark:  |
| `string`  | :heavy_check_mark:  | :heavy_check_mark:  |
| `byte / bytes`  | :heavy_check_mark:  | :heavy_check_mark:  |
| `address`  | :heavy_check_mark:  | :heavy_check_mark:  |
| `struct`  | :x: |  :heavy_check_mark: |
| `mapping`  | :x:  | :heavy_check_mark:  |
| `enum`  | :x:  | :heavy_check_mark:  |
| `contract`  |  :x: | :heavy_check_mark:  |
| fixed-sized array `T[k]`  | :heavy_check_mark:  | :heavy_check_mark:  |
| dynamic-sized array `T[]`  | :x:  |  :heavy_check_mark: |
| multi-dimentional array `T[][]` (not sure here) |  :x: | :heavy_check_mark:  |
| `variable` | :x: | :x: |
*<sub><sup>For arrays, `T` refers to Type and `k` to the length of the array.</sup></sub>
