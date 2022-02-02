#!/usr/bin/env bash
#================================================================
# HEADER
#================================================================
#% SYNOPSIS
#+    check_ubuntu_version.sh
#%
#% DESCRIPTION
#%    For use in upgrade process - check which version is currently installed.
#%
#================================================================
#- IMPLEMENTATION
#-    author          Carsten Agger
#-    copyright       Copyright 2020, Magenta Aps
#-    license         BSD/MIT
#-    email           info@magenta.dk
#-
#================================================================
#  HISTORY
#     2021/04/14 : carstena : script created.
#
#================================================================
# END_OF_HEADER
#================================================================

set -ex


lsb_release -a



