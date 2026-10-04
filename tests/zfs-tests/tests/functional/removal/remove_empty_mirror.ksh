#! /bin/ksh -p
# SPDX-License-Identifier: CDDL-1.0
#
# This file and its contents are supplied under the terms of the
# Common Development and Distribution License ("CDDL"), version 1.0.
# You may only use this file in accordance with the terms of version
# 1.0 of the CDDL.
#
# A full copy of the text of the CDDL should have accompanied this
# source.  A copy of the CDDL is also available via the Internet at
# https://opensource.org/license/CDDL-1.0.
#

#
# Copyright (c) 2026 by Dylan Cochran. All rights reserved.
#

. $STF_SUITE/include/libtest.shlib
. $STF_SUITE/tests/functional/removal/removal.kshlib

DISKDIR=$(mktemp -d)
DISK1="$DISKDIR/dsk1"
DISK2="$DISKDIR/dsk2"
DISK3="$DISKDIR/dsk3"
DISK4="$DISKDIR/dsk4"
DISK5="$DISKDIR/dsk5"
DISK6="$DISKDIR/dsk6"
DISKS="$DISK1 $DISK2 $DISK3 $DISK4 $DISK5 $DISK6"

log_must mkfile $(($MINVDEVSIZE * 2)) $DISK1
log_must mkfile $(($MINVDEVSIZE * 2)) $DISK2
log_must mkfile $(($MINVDEVSIZE * 2)) $DISK3
log_must mkfile $(($MINVDEVSIZE * 2)) $DISK4
log_must mkfile $(($MINVDEVSIZE * 2)) $DISK5
log_must mkfile $(($MINVDEVSIZE * 2)) $DISK6

function cleanup
{
	default_cleanup_noexit
	log_must rm -rf $DISKDIR
}

log_must default_setup_noexit "raidz $DISK1 $DISK2 $DISK3"
log_onexit cleanup

# Attempt to add dedup table volume.
log_must zpool add -f $TESTPOOL mirror $DISK4 $DISK5

# Attempt to remove dedup special device.
log_must zpool remove $TESTPOOL mirror-1
log_must wait_for_removal $TESTPOOL


log_pass "Removal will succeed for empty top level dedup vdev."
