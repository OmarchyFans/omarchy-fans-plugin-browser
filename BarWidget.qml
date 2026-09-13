import QtQuick
import Quickshell
import qs.Commons
import qs.Ui

// Bar button for the plugin browser. One click opens a terminal running
// `omarchy-plugin-browser`, the searchable marketplace TUI. The heavy UI and
// every install path live in that script (and in `omarchy-plugin-audit`), so
// this widget stays a thin, side-effect-free launcher: no network, no plugin
// data parsed inside the long-lived shell process.
//
// Nothing is looked up on PATH and no shell string is built: the terminal is an
// absolute path, the script is this plugin's own checkout run by an absolute
// bash, the argv is fixed, and the child gets a fixed system PATH.
BarWidget {
  id: root
  moduleName: "io.github.modpunk.plugin-browser"

  implicitWidth: button.implicitWidth
  implicitHeight: button.implicitHeight

  readonly property string home: Quickshell.env("HOME") || ""
  // This file's folder as a plain path. Qt.resolvedUrl gives a file:// URL.
  readonly property string pluginDir: {
    var url = Qt.resolvedUrl(".").toString()
    return decodeURIComponent(url.replace(/^file:\/\//, "")).replace(/\/$/, "")
  }

  function launch() {
    Quickshell.execDetached({
      command: [
        "/usr/bin/xdg-terminal-exec",
        "--app-id=io.github.modpunk.plugin-browser",
        "--title=Plugin Browser",
        "-e",
        "/usr/bin/bash", root.pluginDir + "/bin/omarchy-plugin-browser"
      ],
      environment: { "PATH": "/usr/local/bin:/usr/bin:/bin:/usr/share/omarchy/bin" },
      workingDirectory: root.home
    })
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
