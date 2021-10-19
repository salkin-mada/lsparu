# Maintainer: Niklas Adam <salkinmada@protonmail.com>
pkgname=lsparu
pkgver=0.0.1
pkgrel=1
pkgdesc="A fzf TUI for paru"
arch=("any")
url="https://github.com/salkin-mada/lsparu"
license=("GPL3")
depends=("fzf" "paru" "bash" )
source=("$pkgname-$pkgver.tar.gz::$url/archive/refs/tags/$pkgver.tar.gz")
sha256sums=('SKIP')

package() {
  install -Dm775 "$srcdir/$pkgname-$pkgver/lsparu" "$pkgdir/usr/bin/lsparu"
  install -Dm775 "$srcdir/$pkgname-$pkgver/lsparu-query" "$pkgdir/usr/bin/lsparu-query"
}
