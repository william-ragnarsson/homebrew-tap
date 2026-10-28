class WallpaperHeadlines < Formula
  desc "Menu bar app that puts today's news front page on your desktop"
  homepage "https://github.com/william-ragnarsson/wallpaper-headlines"
  url "https://github.com/william-ragnarsson/wallpaper-headlines/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "eb1387cb12056371cd4d16330427330397e29956a9498ba9862daa05a6e705f4"
  license "MIT"
  head "https://github.com/william-ragnarsson/wallpaper-headlines.git", branch: "main"

  depends_on macos: :sonoma

  def install
    # The app's own build: swift build (native build system), then the bundle.
    system "sh", "app/bundle.sh", "--disable-sandbox"
    prefix.install "app/build/WallpaperHeadlines.app"
    # `wallpaper-headlines` opens the app; opt always points at the newest version.
    (bin/"wallpaper-headlines").write <<~SH
      #!/bin/sh
      exec /usr/bin/open "#{opt_prefix}/WallpaperHeadlines.app"
    SH
  end

  def caveats
    <<~EOS
      Open the app with:
        wallpaper-headlines
      To open it at login, add this app to System Settings > General > Login Items:
        #{opt_prefix}/WallpaperHeadlines.app
      Update it from the app's Settings, or with:
        brew upgrade wallpaper-headlines
    EOS
  end

  test do
    assert_predicate prefix/"WallpaperHeadlines.app/Contents/MacOS/WallpaperHeadlines", :executable?
    assert_path_exists prefix/"WallpaperHeadlines.app/Contents/Resources/web/public/index.html"
  end
end
