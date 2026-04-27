# Maintainer: Sefa Eyeoglu <contact@scrumplex.net>
# Contributor: Philip Abernethy <chais.z3r0@gmail.com>

pkgname=tshock
pkgver=6.1.0
# Because of tag 4.2200 is 4.2.2.1228 and tag 4.2202 is 4.2.2.0224 epoch must be 1
epoch=1
pkgrel=3
pkgdesc="Terraria Server administration modification that runs on the open source TerrariaAPI."
arch=(x86_64)
url="https://github.com/Pryaxis/TShock"
license=("GPL-3.0-or-later")
depends=("dotnet-runtime-9.0" "tmux")
makedepends=("dotnet-sdk-9.0")
provides=($pkgname)
conflicts=($pkgname)
install="${pkgname}.install"
source=("${pkgname}::git+https://github.com/Pryaxis/TShock.git#tag=v${pkgver}"
        "${pkgname}.sh"
        'default.conf'
        "${pkgname}@.service"
        "${pkgname}.tmpfiles"
        "${pkgname}.sysusers")
sha512sums=('1a3d5a128c6e697bfd3fdd7d04a0d07098facb0b9ee0802cc58768674553ba885ce33a6eadb770997bff9ed7e78ab7cef8214d9ae8b332ef6039478d18fa0594'
            '26c8ef23aba7431d70d8c3b7ad77fdc47d24061bc41e140453f27fd7cea1b43d7a6562f6a0fa5724e60bcd61af4f6c807f4d05c9f63fc30fe9a1f0c004909710'
            '1381a44cac93190bc2e5b1928cacb6bc410394def5a46086fa3bcb2dc123473974293639c15f7cbf96f2c8c90f6e0519d5f7f386ae18c885c7964309d55b230e'
            '7c1788f21664f038c32da6c0cbe817404a83f81b7b8be07bb0483d5ffd35991a07b647b18d7aa316db369edd4e7eab21c1b81ab3b45aa2c3692c6c63673a3fdb'
            '5421393d134f9954855dc2bdc64179ba1ac3afbd6949937153bb36e1f0b4086389935545484a84c96949def1be14066fa5728c870c63c0eea29c225f063e0d6a'
            '14aee94f6a0053a99bb2c76eb5fd851619f430399807b9af81f3fbeb3ca761de81842eb835407ae3d8c29327b54c7cf45a2c5cd25dd32a815b7ccba3e494d9e6')

backup=("etc/conf.d/${pkgname}/default.conf")

prepare() {
    cd "${pkgname}"
    git submodule update --init
}

build() {
    cd "${pkgname}/TShockLauncher"
    rm -rf output/
    dotnet publish -o output -r linux-x64 -f net9.0 -c Release --self-contained false
}

package() {
    install -Dm755 "${srcdir}/${pkgname}.sh" "${pkgdir}/usr/bin/tshock"
    install -Dm644 "${srcdir}/default.conf" "${pkgdir}/etc/conf.d/${pkgname}/default.conf"
    install -Dm644 "${srcdir}/${pkgname}.sysusers" "${pkgdir}/usr/lib/sysusers.d/${pkgname}.conf"
    install -Dm644 "${srcdir}/${pkgname}.tmpfiles" "${pkgdir}/usr/lib/tmpfiles.d/${pkgname}.conf"
    install -Dm644 "${srcdir}/${pkgname}@.service" "${pkgdir}/usr/lib/systemd/system/${pkgname}@.service"
    mkdir -p "${pkgdir}/opt"
    cp -ar "${srcdir}/${pkgname}/TShockLauncher/output" "${pkgdir}/opt/${pkgname}"
}
