# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-wireless/b43-fwcutter/b43-fwcutter-012.ebuild,v 1.1 2009/09/30 18:02:09 josejx Exp $

inherit toolchain-funcs

DESCRIPTION="Firmware Tool for Broadcom 43xx based wireless network devices using the mac80211 wireless stack"
HOMEPAGE="http://bu3sch.de/b43/fwcutter"
SRC_URI="http://dev.gentoo.org/~nelchael/distfiles/${PN}-20100326.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"

IUSE=""
DEPEND=""
RDEPEND=""

S="${WORKDIR}/fwcutter"

src_compile() {
	emake CC="$(tc-getCC)" || die "emake failed"
}

src_install() {
	# Install fwcutter
	exeinto /usr/bin
	doexe ${PN}
	doman ${PN}.1
	dodoc README
}

pkg_postinst() {
	einfo
	einfo "Firmware may be downloaded from http://linuxwireless.org."
	einfo "This version of fwcutter works with all b43 driver versions."
	einfo

	einfo "Please read this forum thread for help and troubleshooting:"
	einfo "http://forums.gentoo.org/viewtopic-t-409194.html"
	einfo
}
