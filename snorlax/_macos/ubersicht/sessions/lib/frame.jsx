// widget frame v1: drag, collapse to an icon chip, locked-ratio resize, position memory.
// source of truth: ~/dotfiles/snorlax/_macos/ubersicht/kit/frame.jsx
// vendored into each widget's lib/ by kit/sync.sh. edit the source, then sync. never edit a copy.
// spec: ~/miu-brain/projects/widget-frame/widget-frame.md
//
// a widget wires it up like this:
//   const FRAME = { prefs, origin: {left, top}, scale: {min, max, step, default}, mode: "zoom" | "none",
//                   glyph, title, surface: {bg, blur, border, shadow, radius, fg, chipBg?, chipBorder?} };
// chipBg / chipBorder: a folded chip must stay findable, so faint glass can get a denser chip.
//   initialState: { ..., frame: frameDefaults(FRAME) }
//   init:         (dispatch) => frameInit(FRAME, dispatch)
//   updateState:  frameReduce(FRAME, event, prev) || <the widget's own reducer>
//   render:       <Frame cfg={FRAME} frame={state.frame} dispatch={dispatch}>...</Frame>
// mark drag handles with data-frame-handle. double-clicking a handle collapses.
import { React, run } from "uebersicht";

const { useRef, useState, useLayoutEffect, useEffect } = React;

const CHIP = 36; // chip edge, px. constant across widgets and scales
const CHIP_RADIUS = 12;
const EASE = "cubic-bezier(.2, .8, .2, 1)";
const MS = { fadeOut: 120, morph: 240, fadeIn: 140 };
const DRAG_THRESHOLD = 3; // px before a press on a handle or chip counts as a drag
const FONT = '"JetBrainsMono Nerd Font", "JetBrainsMono NF", "JetBrains Mono", Menlo, monospace';

const num = (v, d) => (typeof v === "number" && isFinite(v) ? v : d);
const clamp = (v, lo, hi) => Math.max(lo, Math.min(hi, v));
const tidy = (v) => Math.round(v * 1000) / 1000; // 0.30000000000000004 -> 0.3
const snap = (cfg, s) => tidy(clamp(Math.round(s / cfg.scale.step) * cfg.scale.step, cfg.scale.min, cfg.scale.max));
const reducedMotion = () => {
  try { return window.matchMedia("(prefers-reduced-motion: reduce)").matches; } catch (_) { return false; }
};
const ms = (n) => (reducedMotion() ? 0 : n);

// ---- state ------------------------------------------------------------------

export const frameDefaults = (cfg) => ({ x: 0, y: 0, scale: cfg.scale.default, collapsed: false, loaded: false });

// returns the next widget state for FRAME/* events, null for everything else
export const frameReduce = (cfg, e, prev) => {
  if (!e || typeof e.type !== "string" || e.type.indexOf("FRAME/") !== 0) return null;
  const f = prev.frame || frameDefaults(cfg);
  if (e.type === "FRAME/LOAD") {
    const p = e.prefs || {};
    return {
      ...prev,
      frame: { x: num(p.x, f.x), y: num(p.y, f.y), scale: snap(cfg, num(p.scale, f.scale)), collapsed: p.collapsed === true, loaded: true },
    };
  }
  if (e.type === "FRAME/SET") {
    const n = { ...f, ...(e.patch || {}) };
    return { ...prev, frame: { ...n, x: Math.round(num(n.x, f.x)), y: Math.round(num(n.y, f.y)), scale: snap(cfg, num(n.scale, f.scale)) } };
  }
  return prev;
};

// ---- persistence ------------------------------------------------------------
// numbers and booleans only, so the json is safe inside single quotes.

export const frameInit = (cfg, dispatch) =>
  run(`cat "${cfg.prefs}" 2>/dev/null || true`)
    .then((out) => {
      let prefs = {};
      try { prefs = JSON.parse(out || "{}"); } catch (_) {}
      dispatch({ type: "FRAME/LOAD", prefs });
    })
    .catch(() => dispatch({ type: "FRAME/LOAD", prefs: {} }));

const save = (cfg, f) => {
  const json = JSON.stringify({ x: Math.round(f.x), y: Math.round(f.y), scale: tidy(f.scale), collapsed: !!f.collapsed });
  const dir = cfg.prefs.replace(/\/[^/]*$/, "");
  return run(`mkdir -p "${dir}" && printf '%s' '${json}' > "${cfg.prefs}"`).catch(() => {});
};

// ---- component --------------------------------------------------------------

const CSS = `
.wf-root { position: absolute; pointer-events: auto; transition: opacity 200ms linear; }
.wf-surface { position: relative; box-sizing: border-box; transition: background-color 240ms linear, border-color 240ms linear; }
.wf-root [data-frame-handle] { cursor: grab; }
.wf-ctl { position: absolute; opacity: 0; transition: opacity 140ms linear; }
.wf-root:hover .wf-ctl, .wf-ctl.on { opacity: 1; }
.wf-root:hover .wf-readout:not(.on) { opacity: 0; } /* scale readout only while resizing */
.wf-fold {
  top: -7px; right: -7px; width: 18px; height: 18px; border-radius: 50%;
  display: flex; align-items: center; justify-content: center;
  font: 12px/1 ${FONT}; cursor: pointer; z-index: 2;
}
.wf-grip { right: 0; bottom: 0; width: 16px; height: 16px; cursor: nwse-resize; z-index: 2; }
.wf-grip::before {
  content: ""; position: absolute; right: 5px; bottom: 5px; width: 5px; height: 5px;
  border-right: 1.5px solid currentColor; border-bottom: 1.5px solid currentColor;
}
.wf-readout { right: 20px; bottom: 4px; font: 10px/1 ${FONT}; pointer-events: none; z-index: 2; }
.wf-chip {
  width: ${CHIP}px; height: ${CHIP}px; display: flex; align-items: center; justify-content: center;
  font: 17px/1 ${FONT}; cursor: pointer; user-select: none;
}
`;

export const Frame = ({ cfg, frame, dispatch, children }) => {
  const f = frame || frameDefaults(cfg);
  const s = cfg.surface || {};
  const fg = s.fg || "#e4ebe4";

  const rootRef = useRef(null);
  const surfRef = useRef(null);
  const bodyRef = useRef(null);
  const chipRef = useRef(null);
  const live = useRef(f); // latest frame for handlers created in earlier renders
  live.current = f;
  const busy = useRef(false); // a collapse/expand is running
  const morphFrom = useRef(null); // surface rect captured just before the view swap

  const [view, setView] = useState(f.collapsed ? "chip" : "full");
  const [resizing, setResizing] = useState(false);

  // follow outside changes (prefs load) unless a transition owns the view
  useEffect(() => {
    if (!busy.current) setView(f.collapsed ? "chip" : "full");
  }, [f.collapsed]);

  const commit = (patch) => {
    const next = { ...live.current, ...patch };
    live.current = next; // later reads in the same tick see it before react re-renders
    dispatch({ type: "FRAME/SET", patch });
    save(cfg, next);
    return next;
  };

  // nudge back inside the window after expanding, resizing, or loading on a smaller display
  const keepOnScreen = () => {
    const el = surfRef.current;
    if (!el) return null;
    const r = el.getBoundingClientRect();
    const dx = Math.max(0, -r.left) + Math.min(0, window.innerWidth - r.right);
    const dy = Math.max(0, -r.top) + Math.min(0, window.innerHeight - r.bottom);
    if (!dx && !dy) return null;
    return commit({ x: live.current.x + dx, y: live.current.y + dy });
  };

  useEffect(() => {
    if (f.loaded) keepOnScreen();
  }, [f.loaded]);

  // ---- collapse / expand: fade out, swap, morph the surface, fade in ----

  const radiusAt = (v) => (v === "chip" ? CHIP_RADIUS : (s.radius || 0) * (live.current.scale / cfg.scale.default));

  const toggle = () => {
    if (busy.current || !surfRef.current) return;
    busy.current = true;
    const toChip = view === "full";
    const leaving = toChip ? bodyRef.current : chipRef.current;
    const swap = () => {
      morphFrom.current = surfRef.current.getBoundingClientRect();
      setView(toChip ? "chip" : "full");
    };
    const d = ms(toChip ? MS.fadeOut : MS.fadeOut * 0.6);
    if (leaving && d) {
      leaving.animate([{ opacity: 1 }, { opacity: 0 }], { duration: d, easing: "ease-in", fill: "forwards" }).finished.then(swap, swap);
    } else swap();
  };

  useLayoutEffect(() => {
    const el = surfRef.current;
    const r0 = morphFrom.current;
    if (!el || !r0) return;
    morphFrom.current = null;
    const r1 = el.getBoundingClientRect();
    const toChip = view === "chip";
    const entering = toChip ? chipRef.current : bodyRef.current;
    const d = ms(MS.morph);
    el.style.overflow = "hidden";
    const morph = el.animate(
      [
        { width: `${r0.width}px`, height: `${r0.height}px`, borderRadius: `${radiusAt(toChip ? "full" : "chip")}px` },
        { width: `${r1.width}px`, height: `${r1.height}px`, borderRadius: `${radiusAt(view)}px` },
      ],
      { duration: d, easing: EASE }
    );
    if (entering) {
      entering.animate([{ opacity: 0 }, { opacity: 1 }], {
        duration: ms(MS.fadeIn),
        delay: d * (toChip ? 0.45 : 0.6),
        easing: "ease-out",
        fill: "backwards",
      });
    }
    const done = () => {
      el.style.overflow = "";
      busy.current = false;
      commit({ collapsed: toChip });
      if (!toChip) keepOnScreen();
    };
    morph.finished.then(done, done);
  }, [view]);

  // ---- drag: move by style while dragging, one dispatch + save on release ----

  const startDrag = (e, onTap) => {
    if (e.button !== 0 || busy.current) return;
    const root = rootRef.current;
    const el = surfRef.current;
    if (!root || !el) return;
    e.preventDefault(); // no text selection; click and dblclick still fire
    const x0 = e.clientX;
    const y0 = e.clientY;
    const start = live.current;
    const rect = el.getBoundingClientRect();
    const baseLeft = rect.left - start.x; // where the surface sits at offset 0
    const baseTop = rect.top - start.y;
    let moved = false;
    let nx = start.x;
    let ny = start.y;
    const onMove = (ev) => {
      const dx = ev.clientX - x0;
      const dy = ev.clientY - y0;
      if (!moved && Math.abs(dx) + Math.abs(dy) < DRAG_THRESHOLD) return;
      if (!moved) {
        moved = true;
        document.body.style.cursor = "grabbing";
      }
      nx = Math.round(clamp(start.x + dx, -baseLeft, window.innerWidth - rect.width - baseLeft));
      ny = Math.round(clamp(start.y + dy, -baseTop, window.innerHeight - rect.height - baseTop));
      root.style.transform = `translate(${nx - start.x}px, ${ny - start.y}px)`;
    };
    const onUp = () => {
      window.removeEventListener("mousemove", onMove);
      window.removeEventListener("mouseup", onUp);
      document.body.style.cursor = "";
      if (!moved) {
        if (onTap) onTap();
        return;
      }
      // land on the new spot before react re-renders, so nothing flickers back
      root.style.transform = "";
      root.style.left = `${cfg.origin.left + nx}px`;
      root.style.top = `${cfg.origin.top + ny}px`;
      // the release would also fire a click on whatever is under the pointer
      const eat = (ce) => { ce.stopPropagation(); ce.preventDefault(); };
      window.addEventListener("click", eat, { capture: true, once: true });
      setTimeout(() => window.removeEventListener("click", eat, { capture: true }), 0);
      commit({ x: nx, y: ny });
    };
    window.addEventListener("mousemove", onMove);
    window.addEventListener("mouseup", onUp);
  };

  const onRootDown = (e) => {
    if (view !== "full") return;
    const t = e.target;
    if (t && t.closest && t.closest("[data-frame-handle]") && !t.closest("[data-frame-nodrag]")) startDrag(e);
  };
  const onRootDouble = (e) => {
    const t = e.target;
    if (view === "full" && t && t.closest && t.closest("[data-frame-handle]") && !t.closest("[data-frame-nodrag]")) toggle();
  };

  // ---- resize: locked ratio, snapped, dispatch only when the step changes ----

  const startResize = (e) => {
    if (e.button !== 0 || busy.current) return;
    e.preventDefault();
    e.stopPropagation();
    const rect = surfRef.current.getBoundingClientRect();
    const x0 = e.clientX;
    const y0 = e.clientY;
    const s0 = live.current.scale;
    let cur = s0;
    setResizing(true);
    const onMove = (ev) => {
      const grow = ((ev.clientX - x0) / rect.width + (ev.clientY - y0) / rect.height) / 2;
      const next = snap(cfg, s0 * (1 + grow));
      if (next !== cur) {
        cur = next;
        dispatch({ type: "FRAME/SET", patch: { scale: next } });
      }
    };
    const onUp = () => {
      window.removeEventListener("mousemove", onMove);
      window.removeEventListener("mouseup", onUp);
      setResizing(false);
      commit({ scale: cur });
      requestAnimationFrame(keepOnScreen);
    };
    window.addEventListener("mousemove", onMove);
    window.addEventListener("mouseup", onUp);
  };

  const resetScale = (e) => {
    e.stopPropagation();
    commit({ scale: cfg.scale.default });
    requestAnimationFrame(keepOnScreen);
  };

  // ---- render ----

  const chip = view === "chip";
  const surfaceStyle = {
    background: (chip && s.chipBg) || s.bg,
    WebkitBackdropFilter: s.blur ? `blur(${s.blur}px)` : undefined,
    backdropFilter: s.blur ? `blur(${s.blur}px)` : undefined,
    border: (chip && s.chipBorder) || s.border,
    boxShadow: s.shadow,
    borderRadius: `${radiusAt(view)}px`,
  };
  const ctlStyle = { color: fg };
  const badgeStyle = { ...ctlStyle, background: s.badgeBg || "rgba(19, 36, 42, 0.85)", border: s.border || "1px solid rgba(255, 255, 255, 0.2)" };
  const stop = (e) => e.stopPropagation();

  return (
    <div
      ref={rootRef}
      className="wf-root"
      style={{ left: cfg.origin.left + f.x, top: cfg.origin.top + f.y, opacity: f.loaded ? 1 : 0 }}
      onMouseDown={onRootDown}
      onDoubleClick={onRootDouble}
    >
      <style>{CSS}</style>
      <div ref={surfRef} className="wf-surface" style={surfaceStyle}>
        {view === "full" ? (
          <div ref={bodyRef} style={cfg.mode === "zoom" ? { zoom: f.scale } : undefined}>
            {children}
          </div>
        ) : (
          <div ref={chipRef} className="wf-chip" style={{ color: fg }} title={cfg.title} onMouseDown={(e) => startDrag(e, toggle)}>
            {cfg.glyph}
          </div>
        )}
      </div>
      {view === "full" && [
        <div key="fold" className="wf-ctl wf-fold" style={badgeStyle} title="collapse" onMouseDown={stop} onClick={toggle}>
          −
        </div>,
        <div
          key="grip"
          className={`wf-ctl wf-grip${resizing ? " on" : ""}`}
          style={ctlStyle}
          title="drag to resize, double-click to reset"
          onMouseDown={startResize}
          onDoubleClick={resetScale}
        />,
        <span key="readout" className={`wf-ctl wf-readout${resizing ? " on" : ""}`} style={ctlStyle}>
          {f.scale}×
        </span>,
      ]}
    </div>
  );
};

// full-screen, click-through container for the widget root. use as the widget's className.
export const frameClassName = { top: 0, left: 0, width: "100%", height: "100%", pointerEvents: "none" };
