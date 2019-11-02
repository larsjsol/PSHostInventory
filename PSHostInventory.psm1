Class InventoryItem
{
    [String]$FQDN
    [IPAddress[]]$IpAddresses
    [String]$TicketReference
    [String]$Description
    [Inventory]$Inventory

    InventoryItem() {}
    InventoryItem([String]$FQDN, [IPAddress[]]$IpAddresses, [String]$TicketReference, [String]$Description, [Inventory]$Inventory)
    {
        $this.FQDN, $this.IpAddresses, $this.TicketReference, $this.Description, $this.Inventory = $FQDN, $IpAddresses, $TicketReference, $Description, $Inventory
    }
}

Class Inventory
{
    [String]$Name = "Unnamed"
    [String]$TypeName = "Base Inventory"
    hidden [InventoryItem[]]$Items = $()

    Inventory() {}
    Inventory([String]$Name)
    {
        $this.Name = $Name
    }

    Refresh()
    {
        # default implementation simply creates an empty list
        $this.Items = @()
    }

    [InventoryItem[]] GetInventoryItems()
    {
        if ($this.Items.Count -eq 0)
        {
            $this.Refresh()
        }
        return $this.Items
    }
}

Class DummyInventory : Inventory
{
    [String]$TypeName = "Dummy Inventory"

    DummyInventory(){}
    DummyInventory([string]$Name) : base ($Name) {}

    Refresh()
    {
        $items = @()
        $this.Items += [InventoryItem]::new("test.lol.no", "192.168.0.1", "TEST-1001", "Test av lol", $this)
        $this.Items += [InventoryItem]::new("test.megalol.no", @("192.168.0.2", "10.0.02"), "TEST-2001", "Test av megalol 2000", $this)
    }
}

class OpenDCIMInventory : Inventory
{
    [String]$TypeName = "openDCIM"
    [Uri]$APIURI
    [String]$APIKey

    OpenDCIMInventory(){}
    OpenDCIMInventory([string]$Name, [Uri]$APIURI, [String]$APIKey) : base ($Name)
    {
        $this.APIURI, $this.APIKey = $APIURI, $APIKey
    }
}
