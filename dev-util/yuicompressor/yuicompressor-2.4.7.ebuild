# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit java-utils-2

# This is binary package, as YUI compressor replaces few classes from Rhino,
# packaging this the right way will be a PITA.

DESCRIPTION="Tool that supports the compression of both JavaScript and CSS files"
HOMEPAGE="http://yuilibrary.com/projects/yuicompressor/"
SRC_URI="http://yui.zenfs.com/releases/yuicompressor/${P}.zip"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="app-arch/unzip
	>=virtual/jre-1.5"
RDEPEND=">=virtual/jre-1.5"

src_install() {
	java-pkg_newjar "build/${P}.jar" "${PN}.jar"
	java-pkg_dolauncher "${PN}"
}
