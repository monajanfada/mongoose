*** Settings ***
Resource                     ../../resources/keywords.resource

*** Variables ***

${account_id}                   ${1}
${cluster_id}                   ${1} 
${secure}                       ${False}
${network_id}                   ${60}
${hd_path}                      m/44'/60'/0'/0/0
${destination}                  0xb67788f714cBD3fb99A0Af1f91434bc9E8d008d2
${amount}                       10000000
${chain_id}                     ${1}
${gas_limit}                    0
${max_fee_per_gas}              0
${max_inclusion_fee_per_gas}    0
${nonce}                        ${0} 
${use_eip1559}                  ${False}
    
*** Keywords ***
When Sending Transaction Information for Etherium 
    Set Json Body

Set Json Body
    ${evm}         Create Dictionary              chain_id=${chain_id}          gas_limit=${gas_limit}  
    ...            max_fee_per_gas=${max_fee_per_gas}                           max_inclusion_fee_per_gas=${max_inclusion_fee_per_gas} 
    ...            contract_address=${EMPTY}      data=${EMPTY}                 nonce=${nonce}       use_eip1559=${use_eip1559}
    ${data}        Create Dictionary              account_id=${account_id}      cluster_id=${cluster_id}   
    ...            secure=${secure}               network_id=${network_id}      hd_path=${hd_path}   
    ...            destination=${destination}     amount=${amount}              evm=${evm}
    Set Test Variable                              ${data}

Then the made service is signed and the signature is returned 
    Check Signed Address

Check Signed Address
    [Arguments]             ${HOST_STAGE}=${HOST_STAGE}
    ${response}=   POST     ${HOST_STAGE}/api/v1/sign         json=${data} 
    Set Test Variable       ${response}
    Check Respone Body
    
Check Respone Body
    Should Be Equal As Numbers    ${response.status_code}      200
    Log                           ${response.json()}   
    Set Test Variable             ${response_body}             ${response.json()}    
    ${raw_Etherium}=              Get From Dictionary          ${response_body['data']}    signed
    Set Test Variable             ${raw_tx_hex}                ${raw_Etherium}
    Check Signature

Check Signature
    ${tx_dict}                  Decode Raw Transaction       ${raw_tx_hex}
