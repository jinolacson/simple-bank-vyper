# Objective: Implement the missing parts of the contract
# The contract is missing event information, state variables and functions bodies

# It might be easier to write the Vyper contract at vyper.online to 
# get syntax highlighting and paste your complete contract here 

# Vyper docs - https://vyper.readthedocs.io/en/latest/

#
# Events must be declared at the top of the file
# https://vyper.readthedocs.io/en/latest/logging.html

Enrolled: event({ accountAddress: indexed(address)  })

# The DepositMade event should log an accountAddress and an amount (in wei)
DepositMade: event ({ accountAddress: indexed(address), amount: wei_value})

# Declare an event called 'Withdrawal' that logs an accountAddress, withdrawAmount, and the new balance of the account

Withdrawal: event({ accountAddress: indexed(address), withdrawAmount: wei_value, _value: wei_value })

#
# State variables
# https://vyper.readthedocs.io/en/latest/structure-of-a-contract.html#state-variables

# Declare 3 state varaibles: 
# - userBalances (a public mapping of address to integer)
# - enrolled (a public mapping of address to boolean)
# - owner (a public address)

userBalances: public(map(address, wei_value))
enrolled: public(map(address, bool))
owner: public(address)

#
# Functions
# https://vyper.readthedocs.io/en/latest/structure-of-a-contract.html#functions

# @notice set the contract creator as the owner
@public
def __init__():
	self.owner = msg.sender

# @notice Get balance
# @return The balance of the user
# @dev Use the keyword that indicates the state is not changed

@public
@constant
def balances() -> wei_value:
	return self.balance

# @notice Enroll a customer with the bank
# @return The users enrolled status
# @dev Emit the appropriate event

@public
def enroll() -> bool:
	self.enrolled[msg.sender] = True
	log.Enrolled(msg.sender)
	return self.enrolled[msg.sender]

# @notice Deposit ether into bank
# @return The balance of the user after the deposit is made
# Add the appropriate keyword so that this function can receive ether
# @dev Use the appropriate global variables to get the transaction sender and value
# Emit the appropriate event    

@public
@payable 
def deposit() -> wei_value:
	assert self.enrolled[msg.sender] == True
	self.userBalances[msg.sender] = self.userBalances[msg.sender] + msg.value
	log.DepositMade(msg.sender, msg.value)
	return self.userBalances[msg.sender]

# @notice Withdraw ether from bank
# @dev This does not return any excess ether sent to it
# @param withdrawAmount amount you want to withdraw
# @return The balance remaining for the user
# @dev Emit the appropriate event    

@public
def withdraw(withdrawAmount: wei_value) -> wei_value:
	assert self.userBalances[msg.sender] >= withdrawAmount
	self.userBalances[msg.sender] -= withdrawAmount
	log.Withdrawal(msg.sender,withdrawAmount,self.userBalances[msg.sender])
	return self.userBalances[msg.sender]

# With no fallback function specified, a fallback is automatically generated that will revert any transaction that it processes. This is not the case in Solidity.
