import QtQuick
import Quickshell
import qs.Commons
import qs.Ui

// Bar button for the plugin browser. One click opens a terminal running
// `omarchy-plugin-browser`, the searchable marketplace TUI. The heavy UI and
// every install path live in that script (and in `omarchy-plugin-audit`), so
// this widget stays a thin, side-effect-free launcher — no network, no plugin
// data parsed inside the long-lived shell process.
//
// The launch string is a fixed literal, so routing it through bar.run
// (`bash -lc <command>`) carries no injection surface; the login shell is what
// puts ~/.local/bin (where install.sh symlinks the tools) on PATH.
BarWidget {
  id: root
  moduleName: "io.github.modpunk.plugin-browser"

  implicitWidth: button.implicitWidth
  implicitHeight: button.implicitHeight

  function launch() {
    if (root.bar && typeof root.bar.run === "function")
      root.bar.run("omarchy-launch-tui omarchy-plugin-browser")
  }

  BarIconButton {
    id: button
    anchors.fill: parent
    bar: root.bar
    text: ""                    // nf-fa-puzzle_piece
    slotSize: Style.bar.statusSlot
    fontSize: Style.font.caption
    tooltipText: "Browse & audit plugins"
    onPressed: root.launch()
  }
}
