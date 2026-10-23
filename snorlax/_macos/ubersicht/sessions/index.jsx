// sessions panel: live + exited zellij sessions. click to attach, x to delete exited.
// toggle: hyper+z (aerospace). backend: sessions.sh
import { run, css } from "uebersicht";

const SH = "$HOME/dotfiles/snorlax/_macos/ubersicht/sessions/sessions.sh";
const NAME = /^[A-Za-z0-9._-]+$/;

export const command = `${SH} list`;
export const refreshFrequency = 30000;

export const initialState = { output: "", showExited: false, confirm: null };

export const updateState = (e, prev) => {
  switch (e.type) {
    case "UB/COMMAND_RAN": return { ...prev, output: e.output, error: e.error };
    case "TOGGLE_EXITED":  return { ...prev, showExited: !prev.showExited, confirm: null };
    case "CONFIRM":        return { ...prev, confirm: e.name };
    default:               return prev;
  }
};

// run an action, then redraw from its output instead of waiting for the next tick
const act = (dispatch, verb, name) => {
  if (!NAME.test(name)) return;
  run(`${SH} ${verb} ${name}`).then((output) => dispatch({ type: "UB/COMMAND_RAN", output }));
};

// grove
const c = {
  glass: "rgba(19,36,42,0.25)", border: "rgba(255,255,255,0.2)", hover: "rgba(42,63,70,0.35)",
  fg: "#e4ebe4", dim: "#8098a0", muted: "#5a7880", teal: "#58b0b8", rose: "#e878a8",
};

export const className = css`
  position: fixed; top: 0; left: 0; right: 0; bottom: 0; pointer-events: none;
  font-family: "JetBrainsMono Nerd Font", "JetBrains Mono", monospace;
`;

const panel = css`
  pointer-events: auto; position: absolute; left: 48px; top: 80px; width: 280px;
  padding: 14px 10px; border-radius: 20px; color: ${c.fg};
  background: ${c.glass}; border: 1px solid ${c.border};
  -webkit-backdrop-filter: blur(15px); backdrop-filter: blur(15px);
`;
const head = css`
  display: flex; justify-content: space-between; align-items: baseline;
  padding: 0 10px 8px; font-size: 12px; letter-spacing: .08em; color: ${c.dim};
`;
const row = css`
  display: flex; align-items: center; gap: 10px; padding: 7px 10px;
  border-radius: 12px; font-size: 13px; cursor: pointer; user-select: none;
  &:hover { background: ${c.hover}; }
`;
const dot = (on) => css`
  width: 7px; height: 7px; border-radius: 50%; flex: none;
  background: ${on ? c.teal : "transparent"}; border: 1px solid ${on ? c.teal : c.muted};
`;
const label = css`flex: 1; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;`;
const age = css`font-size: 11px; color: ${c.muted};`;
const del = (armed) => css`
  font-size: 11px; padding: 1px 6px; border-radius: 8px;
  color: ${armed ? c.fg : c.muted}; background: ${armed ? c.rose : "transparent"};
  &:hover { color: ${c.fg}; }
`;
const section = css`
  ${row}; margin-top: 6px; font-size: 11px; color: ${c.dim}; letter-spacing: .06em;
`;

const Row = ({ s, live, confirm, dispatch }) => (
  <div className={row} onClick={() => act(dispatch, "attach", s.name)}>
    <span className={dot(live)} />
    <span className={label} style={{ color: live ? c.fg : c.dim }}>{s.name}</span>
    <span className={age}>{s.age}</span>
    {!live && (
      <span
        className={del(confirm === s.name)}
        onClick={(e) => {
          e.stopPropagation();
          confirm === s.name ? act(dispatch, "delete", s.name)
                             : dispatch({ type: "CONFIRM", name: s.name });
        }}
      >{confirm === s.name ? "delete?" : "×"}</span>
    )}
  </div>
);

export const render = ({ output, error, showExited, confirm }, dispatch) => {
  let data = { live: [], exited: [] };
  try { if (output) data = JSON.parse(output); } catch (_) {}
  return (
    <div className={panel} onMouseLeave={() => confirm && dispatch({ type: "CONFIRM", name: null })}>
      <div className={head}><span>sessions</span><span>{data.live.length} live</span></div>
      {error && <div className={row} style={{ color: c.rose }}>{String(error).slice(0, 80)}</div>}
      {data.live.map((s) => <Row key={s.name} s={s} live confirm={confirm} dispatch={dispatch} />)}
      {data.live.length === 0 && <div className={row} style={{ color: c.muted, cursor: "default" }}>no live sessions</div>}
      {data.exited.length > 0 && (
        <div className={section} onClick={() => dispatch({ type: "TOGGLE_EXITED" })}>
          {showExited ? "▾" : "▸"} exited ({data.exited.length})
        </div>
      )}
      {showExited && data.exited.map((s) => <Row key={s.name} s={s} live={false} confirm={confirm} dispatch={dispatch} />)}
    </div>
  );
};
