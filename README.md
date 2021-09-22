# Mochi: Defi-based DAOs 🍙

Similar to [Trident 🔱 AMM protocol](https://github.com/sushiswap/trident), Mochi is a factory system for deploying organizational contracts, or "DAOs", based on popular designs, like [Moloch](https://github.com/MolochVentures/moloch) 'club style' orgs and ['multi-sigs'](https://github.com/gnosis/MultiSigWallet). 

To start, Mochi orgs utilize the [BentoBox](https://github.com/sushiswap/bentobox) vault as a backend solution to reduce the cost of settling tokens, making it easy to plug into lending apps, like [Kashi lending](https://github.com/sushiswap/kashi-lending), and to further take advantage of passive yield opportunities, like flash lending and [strategies](https://github.com/sushiswap/bentobox-strategies) that natively operate on BentoBox.

## [MochiMol](contracts/mol/v2/MochiMol.sol) 👹

[Moloch DAO v2](https://github.com/MolochVentures/moloch/blob/master/contracts/Moloch.sol) has been implemented on top of BentoBox. In this way, all tokens held in treasury generate yields without needing further actions or proposals, and can be put to work as collateral in Kashi or any other Bento-based app.

Additional optimizations include:
- multi-summoning for members, simplifying the steps to assign initial allocations
- instant summoning of a [Minion-like](https://github.com/raid-guild/moloch-minion) contract that executes arbitrary calls and can hold ETH/NFTs, [`suChef`](contracts/mol/v2/SuChef.sol) 

## MochiSig ✍️ [WIP]

Gnosis-inspired multi-signature operator contract.

# Legal Frameworks ⚖️

This repo will collect resources to allow Mochi orgs to deploy and grow with better legal predictability.
