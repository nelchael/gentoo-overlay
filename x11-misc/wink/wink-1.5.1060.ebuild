# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit eutils

DESCRIPTION="Wink is a tutorial and presentation creation software."
HOMEPAGE="http://www.debugmode.com/wink/"
SRC_URI="http://yet.another.linux-nerd.com/wink/download/wink15.tar.gz"

LICENSE="Wink"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"

RDEPEND="amd64? ( app-emulation/emul-linux-x86-gtklibs
		app-emulation/emul-linux-x86-compat )
	x86? ( x11-libs/gtk+:2
		virtual/libstdc++:3.3 )"
DEPEND="${RDEPEND}
	app-arch/unzip"

src_unpack() {
	mkdir "${S}" || die
	cd "${S}"
	unpack ${A}
	unpack ./installdata.tar.gz
	rm -f ./installdata.tar.gz installer.sh

	unzip -q Resources/winkcust.xrs 'winkcust.xrs$winkicon.png' || die
	mv 'winkcust.xrs$winkicon.png' 'wink-icon.png' || die
}

src_prepare() {
	sed -i -e 's,expat.so.0,expat.so.1,' wink
}

src_install() {
	dodoc *.txt Docs/*.pdf
	rm -rf *.txt Docs

	doicon 'wink-icon.png'
	rm -rf 'wink-icon.png'

	dodir "/opt/wink"
	dodir "/usr/bin"
	cp -Ra * "${D}/opt/wink/" || die

	make_wrapper "wink" "/opt/wink/wink"
	make_desktop_entry "/usr/bin/wink" "Wink" "wink-icon.png" "AudioVideo"
}
