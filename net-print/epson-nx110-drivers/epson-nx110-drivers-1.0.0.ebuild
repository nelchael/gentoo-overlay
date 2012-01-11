# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4
WANT_AUTOMAKE="1.10"

inherit autotools rpm flag-o-matic

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
		-e "s,CUPS_SERVER_DIR=.*$,CUPS_SERVER_DIR=/usr/libexec/cups,g" \
		-e "s,CORE_RESOURCE_PATH=.*$,CORE_RESOURCE_PATH=/usr/share/${PN}/resource,g" \
		configure.ac

	eautoreconf

	chmod +x ./configure

	local DATA_DIR="${WORKDIR}/epson-inkjet-printer-stylus-nx110-series-${PV}"
	cd "${DATA_DIR}/ppds"
	sed -i \
		-e "s,/opt/epson-inkjet-printer-stylus-nx110-series/cups/lib/filter/epson_inkjet_printer_filter,/usr/libexec/cups/filter/epson_inkjet_printer_filter,g" \
		-e "s,/opt/epson-inkjet-printer-stylus-nx110-series,/usr/share/${PN},g" \
		*.ppd
}

src_configure() {
	# The filter *NEEDS* to link agains libstdc++ to succesfully load libraries
	# at runtime, ugly.
	append-ldflags $(no-as-needed)
	econf
}

src_install() {
	emake DESTDIR="${D}" install

	rm -rf "${D}/usr/doc"

	local DATA_DIR="${WORKDIR}/epson-inkjet-printer-stylus-nx110-series-${PV}"

	# Those precompiled libraries *NEED* to go to /usr/lib*, not anywhere else,
	# filter checks for exact paths.
	if use x86; then
		dodir "/usr/lib"
		insinto "/usr/lib"
		doins "${DATA_DIR}/lib/"*
	elif use amd64; then
		dodir "/usr/lib64"
		insinto "/usr/lib64"
		doins "${DATA_DIR}/lib64/"*
	fi

	dodir "/usr/share/cups/model"
	insinto "/usr/share/cups/model"
	doins "${DATA_DIR}/ppds/"*.ppd

	dodir "/usr/share/${PN}/watermark"
	insinto "/usr/share/${PN}/watermark"
	doins "${DATA_DIR}/watermark/"*.EID

	dodir "/usr/share/${PN}/resource"
	insinto "/usr/share/${PN}/resource"
	doins "${DATA_DIR}/resource/"*.data

	dodoc "${DATA_DIR}/AUTHORS" "${DATA_DIR}/README" "${DATA_DIR}/Manual.txt"
}
