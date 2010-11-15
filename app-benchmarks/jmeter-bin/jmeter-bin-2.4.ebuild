# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-benchmarks/jmeter/jmeter-2.0.1-r4.ebuild,v 1.2 2008/10/24 20:36:23 maekke Exp $

DESCRIPTION="Load test and measure performance on HTTP/FTP services and databases."
HOMEPAGE="http://jakarta.apache.org/jmeter"
SRC_URI="mirror://apache/jakarta/jmeter/binaries/jakarta-jmeter-${PV}.tgz"
LICENSE="Apache-2.0"

SLOT="0"
IUSE="doc"
KEYWORDS="~amd64 ~x86"

DEPEND=">=virtual/jdk-1.4"
RDEPEND=">=virtual/jre-1.4"

S="${WORKDIR}/jakarta-jmeter-${PV}/"

src_prepare() {
	cd "${S}/bin/"
	rm -f *.bat *.cmd
}

src_install() {
	dodir /opt/${PN}
	cp -aR * "${D}/opt/${PN}/"
	use doc || rm -fR "${D}/opt/${PN}/docs"
	dobin "${FILESDIR}/jmeter"
	chmod 755 "${D}/usr/bin/jmeter"
}
