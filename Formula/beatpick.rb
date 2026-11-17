class Beatpick < Formula
  include Language::Python::Virtualenv

  desc "Select Apple Music tracks by confirmed audio tempo coverage"
  homepage "https://github.com/ph-wolf/beatpick"
  url "https://github.com/ph-wolf/beatpick/releases/download/v0.2.1/beatpick-0.2.1.tar.gz"
  version "0.2.1"
  sha256 "2f4c6470254e590b7a2cc4ab034f0012824469baf06e188cdd0cc5921004c2b8"
  license "MIT"

  depends_on :macos
  depends_on "ffmpeg"
  depends_on "numpy"
  depends_on "python@3.14"
  depends_on "scipy"

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  def install
    virtualenv_install_with_resources(system_site_packages: false)
    (share/"beatpick").install "skill", "config.example.yaml"
  end

  def caveats
    <<~EOS
      Start your first analysis:
        beatpick run
      If no configuration exists, an interactive run creates ~/.beatpick/config.yaml
      and continues with analysis. Existing configuration is never overwritten.
      Noninteractive calls require an existing config or an explicit CLI selection.

      Optional Codex skill (inspect an existing destination before replacing it):
        mkdir -p ~/.agents/skills
        ln -s #{opt_share}/beatpick/skill ~/.agents/skills/beatpick
      The skill and CLI update together; personal state is not changed by upgrades.
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/beatpick --version")
    assert_match "--no-config", shell_output("#{bin}/beatpick --help")
    assert_match "--duplicate-marker", shell_output("#{bin}/beatpick --help")
    assert_path_exists share/"beatpick/skill/SKILL.md"
    system libexec/"bin/python", "-c", <<~PYTHON
      import numpy as np
      from scipy import signal
      import yaml
      from beatpick import metadata
      from beatpick.configuration import locate
      from types import SimpleNamespace
      assert locate(SimpleNamespace(no_config=True)) is None
      assert signal.correlate(np.array([1, 2]), np.array([1, 2])).max() == 5
      assert metadata.comment_value('Note', True, 'example-marker') == 'Note\\nexample-marker'
      assert yaml.safe_load('enabled: true')['enabled'] is True
    PYTHON
  end
end
