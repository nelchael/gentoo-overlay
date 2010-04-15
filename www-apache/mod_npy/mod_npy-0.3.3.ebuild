# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit apache-module

DESCRIPTION="Alternative way of using Python for dynamic web content."
HOMEPAGE="http://mod-npy.sourceforge.net/"
LICENSE="ZLIB"
SRC_URI="mirror://sourceforge/mod-npy/${P}.tar.bz2"

KEYWORDS="~amd64 ~x86"
IUSE="profile"
SLOT="0"

# See apache-module.eclass for more information.
# APACHE2_MOD_CONF=""
# APACHE2_MOD_DEFINE=""

need_apache2

src_compile() {

	local myconf=
	use profile && myconf="${myconf} --enable-profile"

	econf ${myconf} || die "econf failed"
	emake || die "emake failed"

}

src_install() {

	apache2_src_install

	insinto ${APACHE2_MODULES_CONFDIR}
	doins "${S}/conf/99_mod_npy.conf"

	dodoc "${S}/ChangeLog"

}
