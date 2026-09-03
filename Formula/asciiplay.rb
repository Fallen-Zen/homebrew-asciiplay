class Asciiplay < Formula
  desc "Shape-matched ASCII art from images and video"
  homepage "https://github.com/Fallen-Zen/asciiplay"
  url "https://github.com/Fallen-Zen/asciiplay/archive/refs/tags/v1.0.1.tar.gz"
  sha256 "6abc4ed29829401ad97944d2dafb6f11e99782c40518cf9905793ac502ea4ef6"
  license "MIT"
  head "https://github.com/Fallen-Zen/asciiplay.git", branch: "main"

  depends_on "cmake" => :build
  depends_on "ffmpeg"

  def install
    # ASCIIPLAY_NATIVE stays off: a bottle is built once and installed on many
    # machines, so CPU-specific tuning would fault on older hardware.
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/asciiplay --version")

    system Formula["ffmpeg"].opt_bin/"ffmpeg", "-v", "error", "-f", "lavfi",
           "-i", "testsrc=size=96x96:duration=1", "-frames:v", "1", "t.png"
    out = shell_output("#{bin}/asciiplay --ascii --cols 24 t.png")
    assert_match(/\S/, out)
  end
end
