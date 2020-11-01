# Lenovo Ideapad 15 14ARE05 Power Management

A small 'Lenovo Vantage substitute' script for managing power levels on Ideapad 15 14ARE05.
Original guide on power management:  
https://wiki.archlinux.org/index.php/Lenovo_IdeaPad_5_14are05#System_Performance_Mode

Tested on Arch Linux.

**Requires acpi_call.**

## Usage:

get_powerplan - get current power scheme 


set_powerplan - set new power scheme  
1 - intelligent cooling  
2 - extreme performance  
3 - battery saving  


get_battery_mode - get current battery mode  


set_battery_mode - set new battery mode  
1 - default  
2 - battery conservation  
3 - rapid charge  