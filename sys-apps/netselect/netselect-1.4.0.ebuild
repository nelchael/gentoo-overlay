# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit bash-completion

DESCRIPTION="Network selection utility"
HOMEPAGE="http://bitbucket.org/nelchael/netselect/"
SRC_URI="http://dev.gentoo.org/~nelchael/distfiles/${P}.tar.bz2"

RESTRICT="mirror"

LICENSE="ZLIB"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

DEPEND=""
RDEPEND=""

S="${WORKDIR}/${PN}"

src_install() {
	dodir /etc/netselect
	dodir /sbin
	keepdir /etc/netselect/postset.d

	cd "${S}"
	cp netselect "${D}/sbin/" || die "cp failed"
	cp netselect.conf "${D}/etc/netselect" || die "cp failed"

	dobashcompletion bc/netselect
}
