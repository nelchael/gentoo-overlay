# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

inherit linux-info linux-mod eutils git

DESCRIPTION="Driver for Lenovo ThinkPad SL laptops."
HOMEPAGE="http://github.com/tetromino/lenovo-sl-laptop/tree/master"
LICENSE="GPL-2"
EGIT_REPO_URI="git://github.com/tetromino/lenovo-sl-laptop"

SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND=""
RDEPEND=""

CONFIG_CHECK="HWMON BACKLIGHT_CLASS_DEVICE"

MODULE_NAMES="${PN}(acpi)"
BUILD_TARGETS="module"

S="${WORKDIR}/${PN}"

src_install() {
	linux-mod_src_install
	dodoc README
}
