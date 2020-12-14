#!/bin/bash
echo  "ALL ALL=(ALL:ALL)  NOPASSWD:ALL"  >>/etc/sudoers
echo "%sudo ALL=(ALL:ALL) ALL"   >>/etc/sudoers
