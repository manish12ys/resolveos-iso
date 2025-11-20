#!/bin/bash

# Build ResolveOS ISO with automatic responses to prompts
# Answers: default (all) for xorg-apps, 1 for iptables, 2 for pipewire-jack, 2 for audacity

(
  echo ""        # default=all for xorg-apps
  echo "1"       # iptables
  echo "2"       # pipewire-jack  
  echo "2"       # audacity for ladspa-host
) | sudo mkarchiso -v -w work -o out .
