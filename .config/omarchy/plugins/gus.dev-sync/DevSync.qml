import QtQuick
import Quickshell
import qs.Commons
import qs.Ui

BarWidget {
  id: root
  moduleName: "gus.dev-sync"

  implicitWidth: button.implicitWidth
  implicitHeight: button.implicitHeight

  BarIconButton {
    id: button
    anchors.fill: parent
    bar: root.bar
    text: ""
    slotSize: Style.bar.statusSlot
    fontSize: Style.font.caption
    tooltipText: "Sync all projects with main (safe, skips unsaved work)"
    onPressed: if (root.bar) root.bar.run("omarchy-launch-terminal dev-sync --pause")
  }
}
