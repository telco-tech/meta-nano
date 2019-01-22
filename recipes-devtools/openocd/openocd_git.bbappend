# append to recipes from meta-openembedded
FILESEXTRAPATHS_prepend := "${THISDIR}/${P}:${THISDIR}/${PN}:"

BBCLASSEXTEND += "native"

SRC_URI += " file://fslqspi.patch "
