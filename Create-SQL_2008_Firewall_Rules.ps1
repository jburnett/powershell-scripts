# Create the SQL Server firewall rules
netsh firewall set portopening tcp 1433 "SQL Service (Database Engine)" ENABLE subnet
netsh firewall set portopening tcp 1434 "SQL Server Browser" ENABLE subnet
netsh firewall set portopening tcp 2382 "SQL Analysis Services Redirector" ENABLE subnet
netsh firewall set portopening tcp 2383 "SQL Analysis Services" ENABLE subnet
netsh firewall set portopening tcp 80 "SQL Server Reporting Services" ENABLE subnet

# Display the resultant open ports (all, not just SQL Server)
netsh firewall show portopening