#!/bin/bash

if ! lsmod | grep acpi_call &> /dev/null ; then
  modprobe acpi_call  # loading acpi_call kernel module if not loaded
fi

function get_powerplan {
  echo '\_SB.PCI0.LPC0.EC0.STMD' | cat >/proc/acpi/call
  stmd=$(cat /proc/acpi/call | cut -d '' -f1)

  echo '\_SB.PCI0.LPC0.EC0.QTMD' | cat >/proc/acpi/call
  qtmd=$(cat /proc/acpi/call | cut -d '' -f1)

  if [[ $stmd == '0x0' && $qtmd == '0x0' ]] ; 
    then echo 'Extreme Performance'
  elif [[ $stmd == '0x0' && $qtmd == '0x1' ]] ; 
    then echo 'Battery Saving'
  elif [[ $stmd == '0x1' && $qtmd == '0x0' ]] ; 
    then echo 'Intelligent Cooling'
  fi
}

function set_powerplan () {
  case $1 in 
    1)
      echo '\_SB.PCI0.LPC0.EC0.VPC0.DYTC 0x000FB001' | cat >/proc/acpi/call ;; # intelligent cooling
    2)
      echo '\_SB.PCI0.LPC0.EC0.VPC0.DYTC 0x0012B001' | cat >/proc/acpi/call ;; # extreme performance
    3)
      echo '\_SB.PCI0.LPC0.EC0.VPC0.DYTC 0x0013B001' | cat >/proc/acpi/call ;; # battery saving
  esac
}

function get_battery_mode () {
  echo '\_SB.PCI0.LPC0.EC0.BTSG' | cat >/proc/acpi/call
  bt_consv=$(cat /proc/acpi/call | cut -d '' -f1)

  echo '\_SB.PCI0.LPC0.EC0.FCGM' | cat >/proc/acpi/call
  rpd_charge=$(cat /proc/acpi/call | cut -d '' -f1)

  if [[ $bt_consv == '0x0' && $rpd_charge == '0x0' ]] ; 
    then echo 'Default'
  elif [[ $bt_consv == '0x0' && $rpd_charge == '0x1' ]] ; 
    then echo 'Rapid Charge'
  elif [[ $bt_consv == '0x1' && $rpd_charge == '0x0' ]] ; 
    then echo 'Battery Conservation'
  fi
}

function set_battery_mode () {
  case $1 in 
    1)
      echo '\_SB.PCI0.LPC0.EC0.VPC0.SBMC 0x05' | cat >/proc/acpi/call # turn off battery conservation
      echo '\_SB.PCI0.LPC0.EC0.VPC0.SBMC 0x08' | cat >/proc/acpi/call ;; # turn off rapid charge
    2)
      echo '\_SB.PCI0.LPC0.EC0.VPC0.SBMC 0x08' | cat >/proc/acpi/call # turn off rapid charge
      echo '\_SB.PCI0.LPC0.EC0.VPC0.SBMC 0x03' | cat >/proc/acpi/call ;; # turn on battery conservation
    3)
      echo '\_SB.PCI0.LPC0.EC0.VPC0.SBMC 0x05' | cat >/proc/acpi/call # turn off battery conservation
      echo '\_SB.PCI0.LPC0.EC0.VPC0.SBMC 0x07' | cat >/proc/acpi/call ;; # turn on rapid charge
  esac   
}

function print_help {
  echo 'List of available commands:
  get_powerplan - get current power scheme
  set_powerplan - set new power scheme
    1 - intelligent cooling
    2 - extreme performance
    3 - battery saving
  get_battery_mode - get current battery mode
  set_battery_mode - set new battery mode
    1 - default
    2 - battery conservation
    3 - rapid charge'
}

case $1 in 
  get_powerplan)
    get_powerplan ;;
  set_powerplan)
    set_powerplan $2 ;;
  get_battery_mode)
    get_battery_mode ;;
  set_battery_mode)
    set_battery_mode $2 ;;
  *)
    print_help ;;
esac