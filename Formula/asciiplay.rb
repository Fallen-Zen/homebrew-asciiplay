class Asciiplay < Formula
  desc "Shape-matched ASCII art from images and video"
  homepage "https://github.com/Fallen-Zen/asciiplay"
  url "https://github.com/Fallen-Zen/asciiplay/archive/refs/tags/v1.0.2.tar.gz"
  sha256 "a12605d98ccd891d8728dfd2d688c0df081c8971971d7ed51e97a01c637a1dc2"
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

    system formula_opt_bin("ffmpeg")/"ffmpeg", "-v", "error", "-f", "lavfi",
           "-i", "testsrc=size=96x96:duration=1", "-frames:v", "1", "t.png"
    out = shell_output("#{bin}/asciiplay --ascii --cols 24 t.png")
    assert_match(/\S/, out)
  end
end
