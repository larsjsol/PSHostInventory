using module .\PSHostInventory.psm1

$Inventories = @()
$Inventories += [DummyInventory]::new("Test inventory")
$Inventories += [OpenDCIMInventory]::new("DCIM", "http://example.com", "s3cr3t")

$InventoryItems = @()
$Summary = @{}
foreach ($Inventory in $Inventories)
{
    $Items = $Inventory.GetInventoryItems()
    $Summary.Add($Inventory.Name, $Items.Count)
    $InventoryItems += $Items
}

$InventoryItems| format-table FQDN, IpAddresses, @{ Label="Inventory"; Expression={$_.Inventory.Name} }, TicketReference, Description
$Summary | format-table @{ Label="Inventory"; Expression={$_.Name} }, @{ Label="Number of items"; Expression={$_.Value} }
