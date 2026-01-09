# StacksReserve Protocol

A Bitcoin-native decentralized stablecoin protocol built on Stacks (BTC L2) with Bitcoin finality.

## Overview

StacksReserve is a decentralized finance protocol enabling the creation of USDx - a USD-pegged stablecoin collateralized by Bitcoin ecosystem assets. The protocol combines Bitcoin's security with DeFi innovation through:

- **Bitcoin Finality**: Leverages Stacks L2 anchored to Bitcoin blocks
- **Multi-Collateral Vaults**: Accepts STX and xBTC (wrapped BTC) as collateral
- **Robust Stability Mechanisms**: Overcollateralization requirements + liquidation engine
- **Transparent Governance**: Community-controlled protocol parameters

## Key Features

- 🛡️ **Minimum 200% Collateralization Ratio** for new vaults
- ⚡ **Real-Time Price Feeds** via decentralized oracle network
- 🔥 **Auto-Liquidation** at 150% collateral ratio with 10% penalty
- 📈 **Dynamic Stability Fees** (currently 2% APY)
- 🔒 **Non-Custodial Design** - Users always control their assets

## Architecture

### Core Components

1. **Vault Management**
   - Creates/manages collateralized debt positions (CDPs)
   - Handles collateral deposits/withdrawals
   - Calculates real-time collateral ratios

2. **Oracle Module**
   - Aggregates price feeds from multiple sources
   - Enforces maximum price age (1 hour)
   - Confidence-weighted price validation

3. **Liquidation Engine**
   - Continuous monitoring of vault health factors
   - Incentivized liquidation mechanism
   - Penalty distribution system

4. **USDx Token (SIP-010)**
   - Fully compliant stablecoin implementation
   - Transparent mint/burn mechanics
   - Wallet-integration ready

5. **Risk Management**
   - Configurable safety parameters
   - Emergency shutdown mechanism
   - Protocol-level collateral buffers

### Technical Stack

- **Smart Contracts**: Clarity Language (Stacks L2)
- **Oracle Integration**: Chainlink + Stacks-native oracles
- **Frontend**: React + Hiro Web Components
- **Indexing**: Stacks Blockchain API + Subgraph

## Usage

### Create Vault (CLI)

```bash
clarinet console
>> (contract-call? .stacksreserve create-vault stx-amount xbtc-amount)
```

### Mint USDx

```bash
>> (contract-call? .stacksreserve mint-usdx vault-id amount)
```

### Repay Debt

```bash
>> (contract-call? .stacksreserve burn-usdx vault-id amount)
```

### Monitor Vault

```bash
>> (contract-call? .stacksreserve get-vault vault-id)
```

## Security

### Key Mechanisms

- **Overcollateralization**: Minimum 200% initial ratio
- **Liquidation Protection**: 10% buffer below 150% threshold
- **Price Safeguards**:
  - Multi-source oracle feeds
  - Confidence interval checks
  - Maximum price age enforcement

## Contributing

1. Fork repository
2. Create feature branch
3. Submit PR with detailed description
4. Pass all CI checks
