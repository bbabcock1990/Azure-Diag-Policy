<#
.SYNOPSIS
    Automated process of adding all Diag Settings to the Built In Audit Diag Azure Policy.
.DESCRIPTION
    This script is intended to automatically add all diag settings to the
    buil-in Azure Policy 'Audit Diagnostic Settings'
    
.NOTES
    Script is offered as-is with no warranty, expressed or implied.
    Test it before you trust it
    Author      : Brandon Babcock
    Website     : https://www.linkedin.com/in/brandonbabcock1990/
    Version     : 1.0.0.0 Initial Build
#>

### Variables ###
$subscriptionName='ahead-azure-internallab'
$managementGroupName='Azure_Internal_Group'
$policyDisplayName='Audit-Diag-Settings-BB' #Cant Exceed 24 characters
$useManagementGroupScope='False' #Set to 'False' if you want to scope at Subscription Level

# Get a reference to the built-in policy definition that will be assigned
$definition = Get-AzPolicyDefinition | Where-Object { $_.Properties.DisplayName -eq 'Audit diagnostic setting' }

if ($useManagementGroupScope -ne 'True') {

# Get a reference to the subscription that will be the scope of the assignment
$sub = Get-AzSubscription -SubscriptionName $subscriptionName

# Create the policy assignment with the built-in definition against your subscription
New-AzPolicyAssignment -Name $policyDisplayName -DisplayName $policyDisplayName -Scope ('/subscriptions/'+$sub.Id) -PolicyDefinition $definition -PolicyParameter .\PolicyTypes.json

}
else
{

# Get a reference to the management group that will be the scope of the assignment
$mgmtGroup = Get-AzManagementGroup $managementGroupName

# Create the policy assignment with the built-in definition against your management grouip
New-AzPolicyAssignment -Name $policyDisplayName -DisplayName $policyDisplayName -Scope $mgmtGroup.Id -PolicyDefinition $definition -PolicyParameter .\PolicyTypes.json


}