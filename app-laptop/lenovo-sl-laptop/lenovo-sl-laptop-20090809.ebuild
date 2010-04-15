# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI="2"

inherit linux-info linux-mod

DESCRIPTION="Driver for Lenovo ThinkPad SL laptops."
HOMEPAGE="http://github.com/tetromino/lenovo-sl-laptop/tree/master"
SRC_URI="http://dev.gentoo.org/~nelchael/distfiles/${P}.tar.bz2"
LICENSE="GPL-2"

SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=""
RDEPEND=""

CONFIG_CHECK="HWMON BACKLIGHT_CLASS_DEVICE RFKILL"

MODULE_NAMES="${PN}(acpi)"
BUILD_TARGETS="module"

S="${WORKDIR}/${PN}"

src_install() {
	linux-mod_src_install
	dodoc README
}
