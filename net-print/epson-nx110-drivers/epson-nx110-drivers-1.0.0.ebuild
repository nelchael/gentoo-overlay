# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4
WANT_AUTOMAKE="1.10"

inherit autotools rpm

DESCRIPTION="Driver (and PPDs) for Epson Stylus NX110, NX115, SX110, SX115, TX110, TX111, TX112, TX113, TX115, TX117 and TX119"
HOMEPAGE="http://avasys.jp/eng/linux_driver/download/lsb/epson-inkjet/escp/"
SRC_URI="http://linux.avasys.jp/drivers/lsb/epson-inkjet/stable/SRPMS/epson-inkjet-printer-stylus-nx110-series-1.0.0-1lsb3.2.src.rpm"

LICENSE="Epson-Driver"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="net-print/cups"
RDEPEND="${DEPEND}"

S="${WORKDIR}/epson-inkjet-printer-filter-${PV}"

src_unpack() {
	rpm_unpack ${A}

	unpack "./epson-inkjet-printer-filter-${PV}.tar.gz"
	unpack "./epson-inkjet-printer-stylus-nx110-series-${PV}.tar.gz"
}

src_prepare() {
	sed -i \
		-e 's,CUPS_SERVER_DIR=.*$,CUPS_SERVER_DIR=/usr/libexec/cups,g' \
		configure.ac

	eautoreconf

	chmod +x ./configure
}

src_install() {
	emake DESTDIR="${D}" install

	rm -rf "${D}/usr/doc"

	local DATA_DIR="${WORKDIR}/epson-inkjet-printer-stylus-nx110-series-${PV}"

	dodir "/opt/${PN}/lib32"
	insinto "/opt/${PN}/lib32"
	doins "${DATA_DIR}/lib/"*

	dodir "/opt/${PN}/lib64"
	insinto "/opt/${PN}/lib64"
	doins "${DATA_DIR}/lib64/"*

	dodir "/etc/ld.so.conf.d/"
	echo "/opt/${PN}/lib32" >> "${D}/etc/ld.so.conf.d/${PN}.conf"
	echo "/opt/${PN}/lib64" >> "${D}/etc/ld.so.conf.d/${PN}.conf"

	dodir "/usr/share/cups/model"
	insinto "/usr/share/cups/model"
	doins "${DATA_DIR}/ppds/"*.ppd

	dodoc "${DATA_DIR}/AUTHORS" "${DATA_DIR}/README" "${DATA_DIR}/Manual.txt"
}
