# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

inherit toolchain-funcs multilib

DESCRIPTION="Pidgin notification plugin that uses KDE notifications"
HOMEPAGE="http://bitbucket.org/nelchael/pidgin-knotification/overview"
SRC_URI="http://bitbucket.org/nelchael/${PN}/get/${PV}.tar.bz2 -> ${P}.tar.bz2"

LICENSE="ZLIB"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"

RDEPEND="net-im/pidgin
		x11-libs/qt-dbus:4"
DEPEND="${RDEPEND}
		dev-util/pkgconfig"

S="${WORKDIR}/nelchael-${P}"

src_compile() {
	CXX=$(tc-getCC) emake
}

src_install() {
	dodir "/usr/$(get_libdir)/pidgin"
	cp "${PN}.so" "${D}/${ROOT}/usr/$(get_libdir)/pidgin/" || die "cp failed"

	dodoc README
}
