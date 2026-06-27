import type { PluginAPI } from "@ampcode/plugin";

export default function (amp: PluginAPI) {
  function setStatus(status: string) {
    //pi.exec("workmux", ["set-window-status", status]).catch(() => { });
    amp.$`workmux set-window-status ${status}`.catch(() => {});
  }

  amp.on("agent.start", async () => {
    setStatus("working");
  });

  amp.on("agent.end", async () => {
    setStatus("done");
  });
}
