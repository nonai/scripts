#!/bin/bash -e

function die()
{
        echo "Error: $1" >&2
        exit 1;
}

function cleanup()
{
        [ -d "$TMPDIR" ] && rm -rf "$TMPDIR"
        exit $1
}

DEBDIR="${LOCAL_DIR}/deb"
[ ! -f "$DEBDIR/DEBIAN/control" ] && die "Invalid package directory $DEBDIR specified"

TARGET_DIR="${LOCAL_DIR}/packages"
[ ! -d "$TARGET_DIR" ] && mkdir $TARGET_DIR

EPOCH_TIME=`date +%s`
sed -i -e "s/_PACKAGE_/$PACKAGE/g" -e "s/_VERSION_/${EPOCH_TIME}-${GITREVISION}/g" $DEBDIR/DEBIAN/control

# Package the final product
dpkg-deb -b "$DEBDIR" "$TARGET_DIR" || cleanup 1

# cleanup
cleanup 0
