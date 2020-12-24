# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit desktop multilib savedconfig toolchain-funcs

DESCRIPTION="simple terminal implementation for X"
HOMEPAGE="https://st.suckless.org/"
SRC_URI="https://dl.suckless.org/st/${P}.tar.gz"

LICENSE="MIT-with-advertising"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 hppa ~ppc64 x86"
IUSE="boxdraw scrollback externalpipe anysize transparency blinkingcursor clipboard font2 visualbell2 ligatures"

RDEPEND="
	>=sys-libs/ncurses-6.0:0=
	media-libs/fontconfig
	ligatures? ( media-libs/harfbuzz )
	x11-libs/libX11
	x11-libs/libXft
"
DEPEND="
	${RDEPEND}
	virtual/pkgconfig
	x11-base/xorg-proto
"

src_prepare() {
	default

	sed -i \
		-e "/^X11LIB/{s:/usr/X11R6/lib:/usr/$(get_libdir)/X11:}" \
		-e '/^STLDFLAGS/s|= .*|= $(LDFLAGS) $(LIBS)|g' \
		-e '/^X11INC/{s:/usr/X11R6/include:/usr/include/X11:}' \
		config.mk || die
	sed -i \
		-e '/tic/d' \
		Makefile || die

	eapply "${FILESDIR}/patches.diff"
	eapply_user

	if use boxdraw; then
		sed -i -e 's/BOXDRAWFLAGS =.*/BOXDRAWFLAGS = -DBOXDRAW/g' config.mk || die
	else
		sed -i -e 's/BOXDRAWFLAGS =.*/BOXDRAWFLAGS = /g' config.mk || die
	fi
	if use scrollback; then
		sed -i -e 's/SCROLLBACKFLAGS =.*/SCROLLBACKFLAGS = -DSCROLLBACK/g' config.mk || die
	else
		sed -i -e 's/SCROLLBACKFLAGS =.*/SCROLLBACKFLAGS = /g' config.mk || die
	fi
	if use externalpipe; then
		sed -i -e 's/EXTERNALPIPEFLAGS =.*/EXTERNALPIPEFLAGS = -DEXTERNALPIPE/g' config.mk || die
	else
		sed -i -e 's/EXTERNALPIPEFLAGS =.*/EXTERNALPIPEFLAGS = /g' config.mk || die
	fi
	if use anysize; then
		sed -i -e 's/ANYSIZEFLAGS =.*/ANYSIZEFLAGS = -DANYSIZE/g' config.mk || die
	else
		sed -i -e 's/ANYSIZEFLAGS =.*/ANYSIZEFLAGS = /g' config.mk || die
	fi
	if use transparency; then
		sed -i -e 's/ALPHAFLAGS =.*/ALPHAFLAGS = -DALPHA/g' config.mk || die
	else
		sed -i -e 's/ALPHAFLAGS =.*/ALPHAFLAGS = /g' config.mk || die
	fi
	if use blinkingcursor; then
		sed -i -e 's/BLINKINGCURSORFLAGS =.*/BLINKINGCURSORFLAGS = -DBLINKINGCURSOR/g' config.mk || die
	else
		sed -i -e 's/BLINKINGCURSORFLAGS =.*/BLINKINGCURSORFLAGS = /g' config.mk || die
	fi
	if use clipboard; then
		sed -i -e 's/CLIPBOARDFLAGS =.*/CLIPBOARDFLAGS = -DCLIPBOARD/g' config.mk || die
	else
		sed -i -e 's/CLIPBOARDFLAGS =.*/CLIPBOARDFLAGS = /g' config.mk || die
	fi
	if use font2; then
		sed -i -e 's/FONT2FLAGS =.*/FONT2FLAGS = -DFONT2/g' config.mk || die
	else
		sed -i -e 's/FONT2FLAGS =.*/FONT2FLAGS = /g' config.mk || die
	fi
	if use visualbell2; then
		sed -i -e 's/VISUALBELL2FLAGS =.*/VISUALBELL2FLAGS = -DVISUALBELL2/g' config.mk || die
	else
		sed -i -e 's/VISUALBELL2FLAGS =.*/VISUALBELL2FLAGS = /g' config.mk || die
	fi
	if use ligatures; then
		sed -i -e 's/LIGATURESFLAGS =.*/LIGATURESFLAGS = -DLIGATURES/g' config.mk || die
		sed -i -e 's/LIGATURESLIBS =.*/LIGATURESLIBS = `$(PKG_CONFIG) --libs harfbuzz`/g' config.mk || die
	else
		sed -i -e 's/LIGATURESFLAGS =.*/LIGATURESFLAGS = /g' config.mk || die
		sed -i -e 's/LIGATURESLIBS =.*/LIGATURESLIBS = /g' config.mk || die
	fi

	restore_config config.h
}

src_configure() {
	sed -i \
		-e "s|pkg-config|$(tc-getPKG_CONFIG)|g" \
		config.mk || die

	tc-export CC
}

src_install() {
	emake DESTDIR="${D}" PREFIX="${EPREFIX}"/usr install

	dodoc TODO

	make_desktop_entry ${PN} simpleterm utilities-terminal 'System;TerminalEmulator;' ''

	save_config config.h
}

pkg_postinst() {
	if ! [[ "${REPLACING_VERSIONS}" ]]; then
		elog "Please ensure a usable font is installed, like"
		elog "    media-fonts/corefonts"
		elog "    media-fonts/dejavu"
		elog "    media-fonts/urw-fonts"
	fi
}
