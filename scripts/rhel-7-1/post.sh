#!/bin/sh

# remove this system from subscription-manager
subscription-manager remove --all
subscription-manager unregister
subscription-manager clean
