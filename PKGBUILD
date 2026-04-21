# Maintainer: Sefa Eyeoglu <contact@scrumplex.net>
# Contributor: Philip Abernethy <chais.z3r0@gmail.com>

_pkgname=tshock
pkgname=${_pkgname}
pkgver=6.1.0
# Because of tag 4.2200 is 4.2.2.1228 and tag 4.2202 is 4.2.2.0224 epoch must be 1
epoch=1
pkgrel=1
pkgdesc="Terraria Server administration modification that runs on the open source TerrariaAPI."
arch=(x86_64)
url="https://github.com/Pryaxis/TShock"
license=("GPL-3.0-or-later")
depends=("dotnet-runtime-9.0" "tmux")
makedepends=("dotnet-sdk-9.0")
provides=($_pkgname)
conflicts=($_pkgname)
install="${pkgname}.install"
source=("${_pkgname}::git+https://github.com/Pryaxis/TShock.git#tag=v${pkgver}"
        "tshock.sh"
        "default.conf"
        "service"
        "tmpfiles"
        "sysusers")
sha512sums=('1a3d5a128c6e697bfd3fdd7d04a0d07098facb0b9ee0802cc58768674553ba885ce33a6eadb770997bff9ed7e78ab7cef8214d9ae8b332ef6039478d18fa0594'
            'ad9f588d76e19b5ac2576163390d5e923568a83bea302a1bdfd2e68481521317248d28f33492e0a187390c9aba10ce547f5aed3066c3bf78e9b6c21f0a506154'
            '27153a4649414ce78284fa12deb1bae3fa06b9732d56e81b522186f098c3fc0f51f262700b0177bbe946a8edb2f1d23b0a027e44b61c953b2d2b0db25f21c88f'
            '7c1788f21664f038c32da6c0cbe817404a83f81b7b8be07bb0483d5ffd35991a07b647b18d7aa316db369edd4e7eab21c1b81ab3b45aa2c3692c6c63673a3fdb'
            'a04b458932bb3882b9d40f9b5a9074b681e60cb3284635d1efb7e54293f39df334e7ae526dabf50f633ecdde980f287a939d3ea6eb0d4098663fbda21af70a65'
            '5752f8453fbb4d973ebe71bba371ae7b0ddd2313ccd17de89b3942d024e295805324085640756e7118e4cc76abee675f5e253526261cb62cb76b0bc155aca317')

backup=("etc/conf.d/${_pkgname}/default.conf")

prepare() {
    cd "$_pkgname"
    git submodule update --init
}

build() {
    cd "$_pkgname/TShockLauncher"
    rm -rf output/
    dotnet publish -o output -r linux-x64 -f net9.0 -c Release --self-contained false
}

package() {
    install -Dm755 "${srcdir}/tshock.sh" "${pkgdir}/usr/bin/tshock"
    install -Dm644 "${srcdir}/default.conf" "${pkgdir}/etc/conf.d/${_pkgname}/default.conf"
    install -Dm644 "${srcdir}/sysusers" "$pkgdir/usr/lib/sysusers.d/${_pkgname}.conf"
    install -Dm644 "${srcdir}/tmpfiles" "$pkgdir/usr/lib/tmpfiles.d/${_pkgname}.conf"
    install -Dm644 "${srcdir}/service" "${pkgdir}/usr/lib/systemd/system/tshock@.service"
    mkdir -p "${pkgdir}/opt"
    cp -ar "${srcdir}/${_pkgname}/TShockLauncher/output" "${pkgdir}/opt/${_pkgname}"
}
