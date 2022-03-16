# All About Style and Naming Conventions

|                                    | Naming Style                | Example                                                                                             |
| :--------------------------------- | :-------------------------- | :-------------------------------------------------------------------------------------------------- |
| `contract`, `library`, `interface` | CapWords                    | `SimpleToken`, `SmartBank`, `CertificqteHashRepository`                                             |
| `struct`                           | CapWords                    | `MyCoin`, `Position`                                                                                |
| `enum`                             | CapWords                    | `Frame`, `HashStyle`, `Directions`                                                                  |
| `event`                            | CapWords                    | `Deposit`, `Transfer`, `Approval`, `BeforeTransfer`, ÀfterTransfer`                                 |
| `function`                         | mixedCase                   | `getBalance`, `transfer` , `changeOwner`, `addMember`                                               |
| function(`arguments`)              | mixedCase                   | `account`, `mutex`, `initialSupply`, `senderAddress`, `recipientAddress`, `newOwner`                |
| Local and State `variable`         | mixedCase                   | `totalSupply`, `remainingSupply`, `balancesOf`, `creatorAddress`, `isPreSale`, `tokenExchangeRate`. |
| `constant`                         | UPPER_CASE_WITH_UNDERSCORES | `MAX_BLOCKS`, `TOKEN_NAME`, `TOKEN_TICKER`, `CONTRACT_VERSION`                                      |
| `modifier`                         | mixedCase                   | `onlyBy`, `onlyAfter`, `onlyDuringThePreSale`                                                       |
