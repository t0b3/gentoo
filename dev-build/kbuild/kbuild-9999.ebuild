# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools subversion toolchain-funcs

DESCRIPTION="A makefile framework for writing simple makefiles for complex tasks"
HOMEPAGE="https://trac.netlabs.org/kbuild/wiki"
ESVN_REPO_URI="http://svn.netlabs.org/repos/kbuild/trunk"

LICENSE="GPL-3+"
SLOT="0"

BDEPEND="
	sys-apps/texinfo
	app-alternatives/lex
	sys-devel/gettext
	virtual/pkgconfig
	app-alternatives/yacc
"

PATCHES=(
	"${FILESDIR}/${PN}-0.1.9998.3407-unknown_configure_opt.patch"
	"${FILESDIR}/${PN}-0.1.5-gentoo-docdir.patch"
	"${FILESDIR}/${PN}-0.1.9998_pre20110817-kash-link-pthread.patch"
	"${FILESDIR}/${PN}-0.1.9998.3572-fix-bison.patch"
	"${FILESDIR}/${PN}-0.1.9998.3572-fix-lto.patch"
	"${FILESDIR}/${PN}-0.1.9998.3660-int-conversion.patch"
	"${FILESDIR}/${PN}-0.1.9998.3499-fix-CC.patch"
	"${FILESDIR}/${PN}-0.1.9998.3660-gcc-15.patch"
)

pkg_setup() {
	# Package fails with distcc (bug #255371)
	export DISTCC_DISABLE=1
}

src_prepare() {
	default

	if [[ "${PV}" != *9999 ]] ; then
		# Add a file with the svn revision this package was pulled from
		printf '%s\n' "KBUILD_SVN_REV := $(ver_cut 4)" \
			> SvnInfo.kmk || die
	fi

	cd "${S}/src/kmk" || die
	eautoreconf
	cd "${S}/src/sed" || die
	eautoreconf

	sed -e "s@_LDFLAGS\.$(tc-arch)*.*=@& ${LDFLAGS}@g" \
		-e "s@_CFLAGS\.$(tc-arch)*.*=@& ${CFLAGS}@g" \
		-e "s@_CXXFLAGS\.$(tc-arch)*.*=@& ${CXXFLAGS}@g" \
		-i "${S}"/Config.kmk || die #332225
	tc-export CC PKG_CONFIG RANLIB AR # bug #923130: AR must be both here and below
}

src_compile() {
	kBuild/env.sh --full emake -f bootstrap.gmk AUTORECONF=true AR="$(tc-getAR)" \
		|| die "bootstrap failed"
}

src_install() {
	kBuild/env.sh kmk NIX_INSTALL_DIR=/usr PATH_INS="${D}" install \
		|| die "install failed"
}
