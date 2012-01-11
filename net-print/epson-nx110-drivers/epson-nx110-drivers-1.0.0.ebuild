# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit rpm

DESCRIPTION="Driver (and PPDs) for Epson Stylus NX110, NX115, SX110, SX115, TX110, TX111, TX112, TX113, TX115, TX117 and TX119"
HOMEPAGE="http://avasys.jp/eng/linux_driver/download/lsb/epson-inkjet/escp/"
SRC_URI="http://linux.avasys.jp/drivers/lsb/epson-inkjet/stable/RPMS/x86_64/epson-inkjet-printer-stylus-nx110-series-1.0.0-1lsb3.2.x86_64.rpm"

LICENSE="Epson-Driver"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="net-print/cups"
RDEPEND="${DEPEND}"

S="${WORKDIR}/opt/epson-inkjet-printer-stylus-nx110-series"

src_install() {
	dodir "/opt/${PN}/lib64"
	insinto "/opt/${PN}/lib64"
	doins lib64/*.so.*
	chmod 755 "${D}/opt/${PN}/lib64/lib"*

	dodir "/opt/${PN}/filter"
	insinto "/opt/${PN}/filter"
	doins cups/lib/filter/epson_inkjet_printer_filter
	chmod 755 "${D}/opt/${PN}/filter/epson_inkjet_printer_filter"

	insinto "/usr/share/cups/model"
	doins ppds/Epson/*.ppd.gz

	insinto "/usr/libexec/cups/filter"
	dosym \
		"/opt/${PN}/filter/epson_inkjet_printer_filter" \
		"/usr/libexec/cups/filter/epson_inkjet_printer_filter"

	dodir "/etc/ld.so.conf.d/"
	echo "/opt/${PN}/lib64" > "${D}/etc/ld.so.conf.d/${PN}"

	dodoc doc/AUTHORS doc/README doc/Manual.txt
}
