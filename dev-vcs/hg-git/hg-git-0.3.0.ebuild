# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-vcs/hg-git/hg-git-0.2.6.ebuild,v 1.7 2011/05/22 14:33:31 josejx Exp $

EAPI="3"
PYTHON_DEPEND="2"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="3.* *-jython"

inherit distutils

# Used for snapshots:
#REVISION="fa3edeec7ed1"

DESCRIPTION="push and pull from a Git server using Mercurial"
HOMEPAGE="http://hg-git.github.com/ http://pypi.python.org/pypi/hg-git"

if [[ -n "${REVISION}" ]]; then
	# Snapshot
	SRC_URI="https://bitbucket.org/durin42/hg-git/get/${REVISION}.tar.bz2 -> ${P}.tar.bz2"
	S="${WORKDIR}/durin42-${PN}-${REVISION}/"
else
	# Tagged release
	SRC_URI="https://bitbucket.org/durin42/hg-git/get/${PV}.tar.bz2 -> ${P}.tar.bz2"
	S="${WORKDIR}/durin42-${P}/"
fi

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

RDEPEND=">=dev-vcs/mercurial-1.9
		>=dev-python/dulwich-0.8.0"
DEPEND="${RDEPEND}
	dev-python/setuptools"

PYTHON_MODNAME="hggit"
