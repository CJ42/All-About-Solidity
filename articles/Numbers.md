# Solidity Tutorial : all about Literal Numbers

## Integers numbers

Integers in Solidity can be **signed** or **unsigned**.

An int8 will accept values positive and negative values ranging from -128 to 128.

An uint8 will accept values only positive values ranging from 0 to 256
By default, the type int and uint assigns 256 bytes. However, you can specify the number of bytes by range of 8, ranging from 8 to 256.

Because the idea behind these articles is "all about", we must describe everything ! ^^ The table below summaries all the minimum and maximum values for every single possible type of int and uint.

_picture here_
Assign precisely the number of bytes to an integer can enable to use less gas and takes up less storage space on the EVM.

---

## Fixed point numbers

Use the keyword fixed or ufixed.

## Arithmetic Overflow and Underflow

As we have seen, integers are a fixed-size data type and an integer variable has a certain range of numbers it can represents.

If you try to add a number over the range of your integer (eg: 256 for an uint8 that can hold a value up to 255), the result will be overflowed. In this scenario, the value of the variable will be simply 0.

[Show an example here with Remix code]

## Warning about numbers

Never use a floating point number in a Financial System because of potentially unexpected behaviour.

|   Type    | Max Value                                                                                                 |
| :-------: | :-------------------------------------------------------------------------------------------------------- |
|  `uint8`  | `255`                                                                                                     |
| `uint16`  | `65 535`                                                                                                  |
| `uint24`  | `16 777 215`                                                                                              |
| `uint32`  | `4 294 967 295`                                                                                           |
| `uint40`  | `1 099 511 627 775`                                                                                       |
| `uint48`  | `281 474 976 710 655`                                                                                     |
| `uint56`  | `72 057 594 037 927 935`                                                                                  |
| `uint64`  | `18 446 744 073 709 551 615`                                                                              |
| `uint72`  | `4 722 366 482 869 645 213 695`                                                                           |
| `uint80`  | `1 208 925 819 614 629 174 706 175`                                                                       |
| `uint88`  | `309 485 009 821 345 068 724 781 055`                                                                     |
| `uint96`  | `79 228 162 514 264 337 593 543 950 335`                                                                  |
| `uint104` | `20 282 409 603 651 670 423 947 251 286 015`                                                              |
| `uint112` | `5 192 296 858 534 827 628 530 496 329 220 095`                                                           |
| `uint120` | `1 329 227 995 784 915 872 903 807 060 280 344 575`                                                       |
| `uint128` | `340 282 366 920 938 463 463 374 607 431 768 211 455`                                                     |
| `uint136` | `87 112 285 931 760 246 646 623 899 502 532 662 132 735`                                                  |
| `uint144` | `22 300 745 198 530 623 141 535 718 272 648 361 505 980 415`                                              |
| `uint152` | `5 708 990 770 823 839 524 233 143 877 797 980 545 530 986 495`                                           |
| `uint160` | `1 461 501 637 330 902 918 203 684 832 716 283 019 655 932 542 975`                                       |
| `uint168` | `374 144 419 156 711 147 060 143 317 175 368 453 031 918 731 001 855`                                     |
| `uint176` | `95 780 971 304 118 053 647 396 689 196 894 323 976 171 195 136 475 135`                                  |
| `uint184` | `24 519 928 653 854 221 733 733 552 434 404 946 937 899 825 954 937 634 815`                              |
| `uint192` | `6 277 101 735 386 680 763 835 789 423 207 666 416 102 355 444 464 034 512 895`                           |
| `uint200` | `1 606 938 044 258 990 275 541 962 092 341 162 602 522 202 993 782 792 835 301 375`                       |
| `uint208` | `411 376 139 330 301 510 538 742 295 639 337 626 245 683 966 408 394 965 837 152 255`                     |
| `uint216` | `105 312 291 668 557 186 697 918 027 683 670 432 318 895 095 400 549 111 254 310 977 535`                 |
| `uint224` | `26 959 946 667 150 639 794 667 015 087 019 630 673 637 144 422 540 572 481 103 610 249 215`              |
| `uint232` | `6 901 746 346 790 563 787 434 755 862 277 025 452 451 108 972 170 386 555 162 524 223 799 295`           |
| `uint240` | `1 766 847 064 778 384 329 583 297 500 742 918 515 827 483 896 875 618 958 121 606 201 292 619 775`       |
| `uint248` | `452 312 848 583 266 388 373 324 160 190 187 140 051 835 877 600 158 453 279 131 187 530 910 662 655`     |
| `uint256` | `115 792 089 237 316 195 423 570 985 008 687 907 853 269 984 665 640 564 039 457 584 007 913 129 639 935` |
