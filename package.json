import { useState, useEffect, useRef, createContext, useContext } from "react";
import { supabase } from "./supabase";

// ─── CONTEXTO GLOBAL ──────────────────────────────────────────────────────────
const AppContext = createContext(null);

const CRITERIOS = [
  { id: "formacion",     label: "Formación Académica",          max: 30 },
  { id: "docencia",      label: "Docencia e Impacto Educativo",  max: 25 },
  { id: "publicaciones", label: "Publicaciones Científicas",     max: 25 },
  { id: "documentacion", label: "Completitud Documental",        max: 20 },
];

function isDeadlinePassed(d) { return new Date(d) < new Date(); }
function calcTotal(scores) { return Object.values(scores).reduce((a, b) => a + Number(b), 0); }
function statusColor(s) {
  return { pendiente: "#F59E0B", enviado: "#3B82F6", evaluado: "#8B5CF6", en_proceso: "#6366F1" }[s] || "#6B7280";
}

// ─── UI ATOMS ─────────────────────────────────────────────────────────────────
function Badge({ children, color }) {
  return <span style={{ background: color + "22", color, border: `1px solid ${color}44`, borderRadius: 6, padding: "2px 10px", fontSize: 11, fontWeight: 700, textTransform: "uppercase", letterSpacing: 1 }}>{children}</span>;
}
function Card({ children, style = {} }) {
  return <div style={{ background: "rgba(255,255,255,0.04)", border: "1px solid rgba(255,255,255,0.09)", borderRadius: 16, padding: 24, ...style }}>{children}</div>;
}
function Btn({ children, onClick, variant = "primary", small, disabled, loading, style = {} }) {
  const v = {
    primary: { background: "linear-gradient(135deg,#6366F1,#8B5CF6)", color: "#fff" },
    success: { background: "linear-gradient(135deg,#10B981,#059669)", color: "#fff" },
    danger:  { background: "linear-gradient(135deg,#EF4444,#DC2626)", color: "#fff" },
    ghost:   { background: "rgba(255,255,255,0.07)", color: "#C4C4D4", border: "1px solid rgba(255,255,255,0.1)" },
  };
  return (
    <button style={{ border: "none", borderRadius: 10, fontWeight: 700, cursor: (disabled || loading) ? "not-allowed" : "pointer", padding: small ? "7px 16px" : "12px 24px", fontSize: small ? 13 : 14, transition: "all .18s", opacity: (disabled || loading) ? 0.55 : 1, fontFamily: "inherit", ...v[variant], ...style }}
      onClick={onClick} disabled={disabled || loading}>
      {loading ? "Cargando..." : children}
    </button>
  );
}
function Inp({ label, ...props }) {
  return (
    <div style={{ marginBottom: 14 }}>
      {label && <label style={{ display: "block", fontSize: 12, fontWeight: 600, color: "#9CA3AF", marginBottom: 5, letterSpacing: .5 }}>{label}</label>}
      <input {...props} style={{ width: "100%", background: "rgba(255,255,255,0.06)", border: "1px solid rgba(255,255,255,0.14)", borderRadius: 10, padding: "11px 14px", color: "#F3F4F6", fontSize: 14, outline: "none", fontFamily: "inherit", boxSizing: "border-box", ...props.style }} />
    </div>
  );
}
function Txta({ label, ...props }) {
  return (
    <div style={{ marginBottom: 14 }}>
      {label && <label style={{ display: "block", fontSize: 12, fontWeight: 600, color: "#9CA3AF", marginBottom: 5, letterSpacing: .5 }}>{label}</label>}
      <textarea {...props} rows={props.rows || 4} style={{ width: "100%", background: "rgba(255,255,255,0.06)", border: "1px solid rgba(255,255,255,0.14)", borderRadius: 10, padding: "11px 14px", color: "#F3F4F6", fontSize: 14, outline: "none", fontFamily: "inherit", boxSizing: "border-box", resize: "vertical", ...props.style }} />
    </div>
  );
}
function Spinner() {
  return <div style={{ display: "flex", alignItems: "center", justifyContent: "center", minHeight: "100vh", background: "#0F0F1A" }}>
    <div style={{ textAlign: "center" }}>
      <div style={{ width: 48, height: 48, border: "4px solid rgba(99,102,241,0.2)", borderTopColor: "#6366F1", borderRadius: "50%", animation: "spin 0.8s linear infinite", margin: "0 auto 16px" }} />
      <p style={{ color: "#6B7280", fontFamily: "'Sora', sans-serif" }}>Conectando...</p>
      <style>{`@keyframes spin { to { transform: rotate(360deg); } }`}</style>
    </div>
  </div>;
}

// ─── LOGIN ────────────────────────────────────────────────────────────────────
function Login() {
  const { setCurrentUser, config, users } = useContext(AppContext);
  const [form, setForm] = useState({ username: "", password: "" });
  const [error, setError] = useState("");
  const [loading, setLoading] = useState(false);

  async function handle() {
    setLoading(true); setError("");
    const { data, error: err } = await supabase
      .from("usuarios")
      .select("*")
      .eq("username", form.username.trim())
      .eq("password", form.password)
      .single();
    setLoading(false);
    if (err || !data) setError("Usuario o contraseña incorrectos.");
    else setCurrentUser(data);
  }

  return (
    <div style={{ minHeight: "100vh", display: "flex", alignItems: "center", justifyContent: "center", background: "#0F0F1A", fontFamily: "'Sora', sans-serif" }}>
      <div style={{ position: "absolute", inset: 0, pointerEvents: "none" }}>
        <div style={{ position: "absolute", top: "15%", left: "20%", width: 400, height: 400, background: "radial-gradient(circle, rgba(99,102,241,0.15) 0%, transparent 70%)", borderRadius: "50%" }} />
        <div style={{ position: "absolute", bottom: "20%", right: "15%", width: 300, height: 300, background: "radial-gradient(circle, rgba(139,92,246,0.12) 0%, transparent 70%)", borderRadius: "50%" }} />
      </div>
      <div style={{ width: 400, position: "relative", zIndex: 1 }}>
        <div style={{ textAlign: "center", marginBottom: 32 }}>
          <div style={{ width: 64, height: 64, background: "linear-gradient(135deg,#6366F1,#8B5CF6)", borderRadius: 20, display: "flex", alignItems: "center", justifyContent: "center", margin: "0 auto 14px", fontSize: 28 }}>🧠</div>
          <h1 style={{ color: "#F9FAFB", fontSize: 20, fontWeight: 800, margin: 0 }}>{config?.nombre_diplomado || "Portal Neurolatinvet"}</h1>
          <p style={{ color: "#6B7280", fontSize: 13, margin: "8px 0 0" }}>Portal de Postulación y Evaluación</p>
        </div>
        <Card>
          <Inp label="Usuario" value={form.username} onChange={e => setForm({ ...form, username: e.target.value })} placeholder="Tu nombre de usuario" />
          <Inp label="Contraseña" type="password" value={form.password} onChange={e => setForm({ ...form, password: e.target.value })} placeholder="••••••••" onKeyDown={e => e.key === "Enter" && handle()} />
          {error && <p style={{ color: "#EF4444", fontSize: 13, margin: "-6px 0 10px" }}>{error}</p>}
          <Btn onClick={handle} loading={loading} style={{ width: "100%" }}>Ingresar →</Btn>
        </Card>
        <p style={{ textAlign: "center", color: "#4B5563", fontSize: 12, marginTop: 16 }}>Contacta al administrador si no tienes acceso.</p>
      </div>
    </div>
  );
}

// ─── SHELL ────────────────────────────────────────────────────────────────────
function Shell({ children }) {
  const { currentUser, setCurrentUser, config } = useContext(AppContext);
  const rc = { admin: "#F59E0B", evaluador: "#8B5CF6", candidato: "#10B981" };
  const rl = { admin: "Administrador", evaluador: "Evaluador", candidato: "Candidato" };
  return (
    <div style={{ minHeight: "100vh", background: "#0F0F1A", fontFamily: "'Sora', sans-serif", color: "#F3F4F6" }}>
      <header style={{ position: "sticky", top: 0, zIndex: 100, background: "rgba(15,15,26,0.92)", backdropFilter: "blur(20px)", borderBottom: "1px solid rgba(255,255,255,0.07)", padding: "13px 28px", display: "flex", alignItems: "center", justifyContent: "space-between" }}>
        <div style={{ display: "flex", alignItems: "center", gap: 10 }}>
          <span style={{ fontSize: 18 }}>🧠</span>
          <span style={{ fontWeight: 800, fontSize: 14 }}>{config?.nombre_diplomado || "Neurolatinvet"}</span>
        </div>
        <div style={{ display: "flex", alignItems: "center", gap: 12 }}>
          <div style={{ textAlign: "right" }}>
            <p style={{ margin: "0 0 2px", fontWeight: 700, fontSize: 13 }}>{currentUser.name}</p>
            <Badge color={rc[currentUser.role]}>{rl[currentUser.role]}</Badge>
          </div>
          <Btn variant="ghost" small onClick={() => setCurrentUser(null)}>Salir</Btn>
        </div>
      </header>
      <main style={{ maxWidth: 1060, margin: "0 auto", padding: "28px 20px" }}>{children}</main>
    </div>
  );
}

// ─── CANDIDATO ────────────────────────────────────────────────────────────────
function CandidatoView() {
  const { currentUser, config } = useContext(AppContext);
  const fases = config?.fases || [];
  const [postulacion, setPostulacion] = useState(null);
  const [activeTab, setActiveTab] = useState(0);
  const [files, setFiles] = useState({});
  const [formData, setFormData] = useState({});
  const [loading, setLoading] = useState(true);
  const [saving, setSaving] = useState(false);
  const fileRef = useRef();

  useEffect(() => { fetchPost(); }, []);

  async function fetchPost() {
    setLoading(true);
    const { data } = await supabase.from("postulaciones").select("*").eq("user_id", currentUser.id).single();
    setPostulacion(data || null);
    setLoading(false);
  }

  async function enviar(faseId) {
    setSaving(true);
    const payload = { status: "enviado", files: files[faseId] || [], data: formData[faseId] || {}, enviadoAt: new Date().toISOString() };
    const newFases = { ...(postulacion?.fases || {}), [faseId]: payload };

    if (postulacion) {
      await supabase.from("postulaciones").update({ fases: newFases, updated_at: new Date().toISOString() }).eq("id", postulacion.id);
    } else {
      const { data } = await supabase.from("postulaciones").insert({ user_id: currentUser.id, user_name: currentUser.name, status: "en_proceso", fases: newFases }).select().single();
      setPostulacion(data);
    }
    await fetchPost();
    setSaving(false);
    alert(`✅ Fase enviada correctamente.`);
  }

  function handleFile(e, faseId) {
    const f = e.target.files[0];
    if (!f) return;
    if (f.size > 5 * 1024 * 1024) { alert("El archivo no puede superar 5MB."); return; }
    const reader = new FileReader();
    reader.onload = ev => setFiles(p => ({ ...p, [faseId]: [...(p[faseId] || []), { name: f.name, type: f.type, size: f.size, data: ev.target.result }] }));
    reader.readAsDataURL(f);
    e.target.value = "";
  }

  if (loading) return <Spinner />;

  const completadas = postulacion ? Object.values(postulacion.fases || {}).filter(f => f.status === "enviado").length : 0;

  return (
    <div>
      <div style={{ marginBottom: 22 }}>
        <h2 style={{ fontSize: 21, fontWeight: 800, margin: "0 0 4px" }}>Mi Postulación</h2>
        <p style={{ color: "#6B7280", margin: 0, fontSize: 13 }}>Completa cada fase antes de su fecha límite.</p>
      </div>

      <Card style={{ marginBottom: 20, display: "flex", alignItems: "center", gap: 18 }}>
        <div style={{ flex: 1 }}>
          <p style={{ margin: "0 0 7px", fontSize: 12, color: "#9CA3AF", fontWeight: 600 }}>PROGRESO</p>
          <div style={{ height: 7, background: "rgba(255,255,255,0.08)", borderRadius: 99, overflow: "hidden" }}>
            <div style={{ height: "100%", width: `${fases.length ? (completadas / fases.length) * 100 : 0}%`, background: "linear-gradient(90deg,#6366F1,#8B5CF6)", borderRadius: 99, transition: "width .5s" }} />
          </div>
          <p style={{ margin: "5px 0 0", fontSize: 12, color: "#9CA3AF" }}>{completadas} de {fases.length} fases enviadas</p>
        </div>
        <div style={{ textAlign: "center" }}>
          <p style={{ margin: 0, fontSize: 26, fontWeight: 800, color: "#6366F1" }}>{fases.length ? Math.round((completadas / fases.length) * 100) : 0}%</p>
        </div>
      </Card>

      <div style={{ display: "flex", gap: 8, marginBottom: 18, flexWrap: "wrap" }}>
        {fases.map((fase, i) => {
          const enviado = postulacion?.fases?.[fase.id]?.status === "enviado";
          return (
            <button key={fase.id} onClick={() => setActiveTab(i)} style={{ padding: "8px 16px", borderRadius: 10, border: "none", fontFamily: "inherit", fontWeight: 700, fontSize: 12, cursor: "pointer", background: activeTab === i ? "linear-gradient(135deg,#6366F1,#8B5CF6)" : "rgba(255,255,255,0.05)", color: activeTab === i ? "#fff" : "#9CA3AF", outline: enviado ? "2px solid #10B98166" : "none" }}>
              {enviado ? "✅ " : ""}{fase.nombre}
            </button>
          );
        })}
      </div>

      {fases.map((fase, i) => {
        if (i !== activeTab) return null;
        const faseData = postulacion?.fases?.[fase.id];
        const enviado = faseData?.status === "enviado";
        const vencida = isDeadlinePassed(fase.deadline);

        return (
          <Card key={fase.id}>
            <div style={{ display: "flex", justifyContent: "space-between", alignItems: "flex-start", marginBottom: 20, flexWrap: "wrap", gap: 10 }}>
              <div>
                <h3 style={{ margin: "0 0 4px", fontSize: 17, fontWeight: 800 }}>Fase {i + 1}: {fase.nombre}</h3>
                <p style={{ margin: 0, color: "#9CA3AF", fontSize: 13 }}>{fase.descripcion}</p>
              </div>
              <div style={{ textAlign: "right" }}>
                <p style={{ margin: "0 0 3px", fontSize: 11, color: "#6B7280", fontWeight: 600 }}>FECHA LÍMITE</p>
                <p style={{ margin: "0 0 4px", fontWeight: 700, color: vencida ? "#EF4444" : "#F59E0B", fontSize: 14 }}>
                  {new Date(fase.deadline + "T12:00:00").toLocaleDateString("es-ES", { day: "numeric", month: "long", year: "numeric" })}
                </p>
                <Badge color={vencida ? "#EF4444" : "#10B981"}>{vencida ? "Vencida" : "Activa"}</Badge>
              </div>
            </div>

            {enviado ? (
              <div style={{ background: "rgba(16,185,129,0.08)", border: "1px solid rgba(16,185,129,0.2)", borderRadius: 12, padding: 18 }}>
                <p style={{ margin: "0 0 6px", fontWeight: 700, color: "#10B981" }}>✅ Fase enviada correctamente</p>
                <p style={{ margin: "0 0 10px", color: "#6B7280", fontSize: 13 }}>Enviado el {new Date(faseData.enviadoAt).toLocaleString("es-ES")}</p>
                {faseData.files?.map((f, idx) => (
                  <div key={idx} style={{ display: "flex", gap: 8, padding: "6px 10px", background: "rgba(255,255,255,0.04)", borderRadius: 8, marginBottom: 4, alignItems: "center" }}>
                    <span>📎</span><span style={{ fontSize: 13 }}>{f.name}</span>
                    <span style={{ fontSize: 11, color: "#6B7280", marginLeft: "auto" }}>{(f.size / 1024).toFixed(1)} KB</span>
                  </div>
                ))}
              </div>
            ) : vencida ? (
              <div style={{ background: "rgba(239,68,68,0.08)", border: "1px solid rgba(239,68,68,0.2)", borderRadius: 12, padding: 18 }}>
                <p style={{ margin: 0, color: "#EF4444", fontWeight: 700 }}>⏰ El plazo para esta fase ha vencido.</p>
              </div>
            ) : (
              <div>
                <Txta label={`Descripción — ${fase.nombre}`} value={formData[fase.id]?.descripcion || ""} onChange={e => setFormData(p => ({ ...p, [fase.id]: { ...p[fase.id], descripcion: e.target.value } }))} placeholder={`Describe tu ${fase.nombre.toLowerCase()}...`} rows={5} />
                <Inp label="Institución / Entidad" value={formData[fase.id]?.institucion || ""} onChange={e => setFormData(p => ({ ...p, [fase.id]: { ...p[fase.id], institucion: e.target.value } }))} />
                <Inp label="Año(s)" value={formData[fase.id]?.anio || ""} onChange={e => setFormData(p => ({ ...p, [fase.id]: { ...p[fase.id], anio: e.target.value } }))} />

                <p style={{ fontSize: 12, fontWeight: 600, color: "#9CA3AF", marginBottom: 8, letterSpacing: .5 }}>DOCUMENTOS DE SOPORTE (máx. 5MB por archivo)</p>
                <div style={{ border: "2px dashed rgba(255,255,255,0.12)", borderRadius: 12, padding: 18, textAlign: "center", cursor: "pointer" }}
                  onClick={() => { fileRef.current.dataset.fase = fase.id; fileRef.current.click(); }}>
                  <p style={{ margin: 0, color: "#6B7280", fontSize: 13 }}>📎 Haz clic para adjuntar</p>
                  <p style={{ margin: "3px 0 0", color: "#4B5563", fontSize: 12 }}>PDF, imágenes, Word, Excel</p>
                </div>
                <input ref={fileRef} type="file" style={{ display: "none" }} accept=".pdf,.doc,.docx,.xls,.xlsx,.jpg,.jpeg,.png" onChange={e => handleFile(e, Number(fileRef.current.dataset.fase))} />
                {(files[fase.id] || []).map((f, idx) => (
                  <div key={idx} style={{ display: "flex", gap: 8, padding: "8px 12px", background: "rgba(99,102,241,0.08)", borderRadius: 8, marginTop: 6, alignItems: "center" }}>
                    <span>📎</span><span style={{ fontSize: 13, flex: 1 }}>{f.name}</span>
                    <span style={{ fontSize: 11, color: "#6B7280" }}>{(f.size / 1024).toFixed(1)} KB</span>
                    <button onClick={() => setFiles(p => ({ ...p, [fase.id]: p[fase.id].filter((_, j) => j !== idx) }))} style={{ background: "none", border: "none", color: "#EF4444", cursor: "pointer", fontSize: 16 }}>×</button>
                  </div>
                ))}
                <div style={{ marginTop: 18 }}>
                  <Btn onClick={() => enviar(fase.id)} variant="success" loading={saving}>Enviar Fase →</Btn>
                </div>
              </div>
            )}
          </Card>
        );
      })}
    </div>
  );
}

// ─── EVALUADOR ────────────────────────────────────────────────────────────────
function EvaluadorView() {
  const { currentUser, config } = useContext(AppContext);
  const fases = config?.fases || [];
  const [postulaciones, setPostulaciones] = useState([]);
  const [evaluaciones, setEvaluaciones] = useState([]);
  const [selected, setSelected] = useState(null);
  const [scores, setScores] = useState({});
  const [comentario, setComentario] = useState("");
  const [viewFase, setViewFase] = useState(null);
  const [loading, setLoading] = useState(true);
  const [saving, setSaving] = useState(false);

  useEffect(() => { fetchData(); }, []);

  async function fetchData() {
    setLoading(true);
    const [{ data: posts }, { data: evs }] = await Promise.all([
      supabase.from("postulaciones").select("*"),
      supabase.from("evaluaciones").select("*").eq("evaluador_id", currentUser.id),
    ]);
    setPostulaciones(posts || []);
    setEvaluaciones(evs || []);
    setLoading(false);
  }

  function getEval(postId) { return evaluaciones.find(e => e.post_id === postId); }

  async function guardar() {
    setSaving(true);
    const total = calcTotal(scores);
    const existing = getEval(selected.id);
    if (existing) {
      await supabase.from("evaluaciones").update({ scores, total, comentario, created_at: new Date().toISOString() }).eq("id", existing.id);
    } else {
      await supabase.from("evaluaciones").insert({ post_id: selected.id, evaluador_id: currentUser.id, evaluador_name: currentUser.name, scores, total, comentario });
    }
    await supabase.from("postulaciones").update({ status: "evaluado" }).eq("id", selected.id);
    await fetchData();
    setSaving(false);
    alert("✅ Evaluación guardada.");
    setSelected(null);
  }

  if (loading) return <Spinner />;

  const conFases = postulaciones.filter(p => p.fases && Object.keys(p.fases).length > 0);

  if (selected) {
    const ev = getEval(selected.id);
    return (
      <div>
        <button onClick={() => setSelected(null)} style={{ background: "none", border: "none", color: "#6366F1", cursor: "pointer", fontSize: 14, fontWeight: 700, marginBottom: 18, fontFamily: "inherit" }}>← Volver</button>
        <h2 style={{ fontSize: 19, fontWeight: 800, margin: "0 0 16px" }}>Evaluando: {selected.user_name}</h2>
        <Card style={{ marginBottom: 16 }}>
          <h3 style={{ margin: "0 0 12px", fontSize: 14, fontWeight: 700 }}>📁 Documentos del Candidato</h3>
          <div style={{ display: "flex", gap: 8, flexWrap: "wrap", marginBottom: 12 }}>
            {fases.map(f => selected.fases?.[f.id] ? (
              <Btn key={f.id} small variant={viewFase === f.id ? "primary" : "ghost"} onClick={() => setViewFase(viewFase === f.id ? null : f.id)}>Fase {f.id}: {f.nombre}</Btn>
            ) : null)}
          </div>
          {viewFase && selected.fases?.[viewFase] && (
            <div style={{ background: "rgba(255,255,255,0.03)", borderRadius: 12, padding: 14 }}>
              {selected.fases[viewFase].data && Object.entries(selected.fases[viewFase].data).map(([k, v]) => v ? (
                <div key={k} style={{ marginBottom: 7 }}><span style={{ color: "#9CA3AF", fontSize: 11, fontWeight: 600, textTransform: "uppercase" }}>{k}: </span><span style={{ color: "#E5E7EB", fontSize: 13 }}>{v}</span></div>
              ) : null)}
              {selected.fases[viewFase].files?.map((f, i) => (
                <a key={i} href={f.data} download={f.name} style={{ display: "flex", gap: 8, padding: "7px 12px", background: "rgba(99,102,241,0.1)", borderRadius: 8, marginTop: 5, textDecoration: "none", color: "#A5B4FC", alignItems: "center" }}>
                  📎 <span style={{ fontSize: 13 }}>{f.name}</span> <span style={{ fontSize: 11, color: "#6B7280", marginLeft: "auto" }}>⬇ Descargar</span>
                </a>
              ))}
            </div>
          )}
        </Card>
        <Card>
          <h3 style={{ margin: "0 0 16px", fontSize: 14, fontWeight: 700 }}>📊 Puntuación por Criterios</h3>
          {CRITERIOS.map(c => {
            const val = scores[c.id] ?? ev?.scores?.[c.id] ?? 0;
            return (
              <div key={c.id} style={{ marginBottom: 18 }}>
                <div style={{ display: "flex", justifyContent: "space-between", marginBottom: 7 }}>
                  <label style={{ fontSize: 13, fontWeight: 600, color: "#D1D5DB" }}>{c.label}</label>
                  <span style={{ fontSize: 12, color: "#9CA3AF" }}>Máx. {c.max}</span>
                </div>
                <div style={{ display: "flex", alignItems: "center", gap: 10 }}>
                  <input type="range" min={0} max={c.max} value={val} onChange={e => setScores(p => ({ ...p, [c.id]: Number(e.target.value) }))} style={{ flex: 1, accentColor: "#6366F1" }} />
                  <span style={{ fontWeight: 800, fontSize: 19, color: "#6366F1", minWidth: 32, textAlign: "right" }}>{val}</span>
                </div>
                <div style={{ height: 3, background: "rgba(255,255,255,0.06)", borderRadius: 99, overflow: "hidden", marginTop: 4 }}>
                  <div style={{ height: "100%", width: `${(val / c.max) * 100}%`, background: "linear-gradient(90deg,#6366F1,#8B5CF6)", borderRadius: 99 }} />
                </div>
              </div>
            );
          })}
          <div style={{ display: "flex", justifyContent: "space-between", alignItems: "center", padding: "12px 0", borderTop: "1px solid rgba(255,255,255,0.08)", marginBottom: 14 }}>
            <span style={{ fontWeight: 700 }}>TOTAL</span>
            <span style={{ fontWeight: 800, fontSize: 22, color: calcTotal(scores) >= 70 ? "#10B981" : "#F59E0B" }}>{calcTotal(scores)}<span style={{ fontSize: 13, color: "#6B7280" }}> / 100</span></span>
          </div>
          <Txta label="Comentarios y observaciones" value={comentario} onChange={e => setComentario(e.target.value)} placeholder="Observaciones sobre el candidato..." />
          <div style={{ display: "flex", gap: 10 }}>
            <Btn onClick={guardar} variant="success" loading={saving}>Guardar Evaluación</Btn>
            <Btn variant="ghost" onClick={() => setSelected(null)}>Cancelar</Btn>
          </div>
        </Card>
      </div>
    );
  }

  return (
    <div>
      <div style={{ marginBottom: 22 }}>
        <h2 style={{ fontSize: 21, fontWeight: 800, margin: "0 0 4px" }}>Panel de Evaluación</h2>
        <p style={{ color: "#6B7280", margin: 0, fontSize: 13 }}>Revisa y puntúa las postulaciones recibidas.</p>
      </div>
      {conFases.length === 0 ? (
        <Card style={{ textAlign: "center", padding: 56 }}><p style={{ fontSize: 34, marginBottom: 10 }}>📭</p><p style={{ color: "#6B7280" }}>No hay postulaciones enviadas aún.</p></Card>
      ) : (
        <div style={{ display: "grid", gap: 12 }}>
          {conFases.map(p => {
            const ev = getEval(p.id);
            return (
              <Card key={p.id} style={{ display: "flex", alignItems: "center", gap: 14, flexWrap: "wrap" }}>
                <div style={{ width: 42, height: 42, background: "linear-gradient(135deg,#6366F1,#8B5CF6)", borderRadius: 13, display: "flex", alignItems: "center", justifyContent: "center", fontSize: 17, flexShrink: 0 }}>👤</div>
                <div style={{ flex: 1 }}>
                  <p style={{ margin: "0 0 3px", fontWeight: 700 }}>{p.user_name}</p>
                  <p style={{ margin: 0, fontSize: 12, color: "#6B7280" }}>{Object.keys(p.fases || {}).length} fases enviadas</p>
                </div>
                {ev ? <div style={{ textAlign: "right" }}><p style={{ margin: "0 0 3px", fontSize: 17, fontWeight: 800, color: ev.total >= 70 ? "#10B981" : "#F59E0B" }}>{ev.total}/100</p><Badge color="#8B5CF6">Evaluado</Badge></div> : <Badge color="#F59E0B">Pendiente</Badge>}
                <Btn small onClick={() => { setSelected(p); setScores(ev?.scores || {}); setComentario(ev?.comentario || ""); setViewFase(null); }}>{ev ? "Re-evaluar" : "Evaluar"}</Btn>
              </Card>
            );
          })}
        </div>
      )}
    </div>
  );
}

// ─── ADMIN ────────────────────────────────────────────────────────────────────
function AdminView() {
  const { config, setConfig } = useContext(AppContext);
  const [tab, setTab] = useState("dashboard");
  const [users, setUsers] = useState([]);
  const [postulaciones, setPostulaciones] = useState([]);
  const [evaluaciones, setEvaluaciones] = useState([]);
  const [newUser, setNewUser] = useState({ username: "", password: "", name: "", role: "candidato" });
  const [configDraft, setConfigDraft] = useState(config);
  const [savedMsg, setSavedMsg] = useState("");
  const [loading, setLoading] = useState(true);
  const [saving, setSaving] = useState(false);

  useEffect(() => { fetchAll(); }, []);

  async function fetchAll() {
    setLoading(true);
    const [{ data: u }, { data: p }, { data: e }] = await Promise.all([
      supabase.from("usuarios").select("*").order("created_at"),
      supabase.from("postulaciones").select("*").order("created_at"),
      supabase.from("evaluaciones").select("*"),
    ]);
    setUsers(u || []);
    setPostulaciones(p || []);
    setEvaluaciones(e || []);
    setLoading(false);
  }

  async function guardarConfig() {
    setSaving(true);
    await supabase.from("config").update({ nombre_diplomado: configDraft.nombre_diplomado, fases: configDraft.fases, updated_at: new Date().toISOString() }).eq("id", 1);
    setConfig(configDraft);
    setSavedMsg("✅ Guardado correctamente");
    setTimeout(() => setSavedMsg(""), 3000);
    setSaving(false);
  }

  async function crearUser() {
    if (!newUser.username.trim() || !newUser.password.trim() || !newUser.name.trim()) { alert("Completa todos los campos."); return; }
    setSaving(true);
    const { error } = await supabase.from("usuarios").insert({ username: newUser.username.trim(), password: newUser.password, name: newUser.name.trim(), role: newUser.role });
    if (error) { alert("Error: " + (error.message.includes("unique") ? "Ese usuario ya existe." : error.message)); }
    else { setNewUser({ username: "", password: "", name: "", role: "candidato" }); await fetchAll(); alert("✅ Usuario creado."); }
    setSaving(false);
  }

  async function eliminarUser(id) {
    if (!window.confirm("¿Eliminar este usuario?")) return;
    await supabase.from("usuarios").delete().eq("id", id);
    await fetchAll();
  }

  function addFase() { setConfigDraft(p => ({ ...p, fases: [...p.fases, { id: Date.now(), nombre: "Nueva Fase", descripcion: "", deadline: "2026-12-31" }] })); }
  function updFase(id, field, val) { setConfigDraft(p => ({ ...p, fases: p.fases.map(f => f.id === id ? { ...f, [field]: val } : f) })); }
  function delFase(id) { if (!window.confirm("¿Eliminar fase?")) return; setConfigDraft(p => ({ ...p, fases: p.fases.filter(f => f.id !== id) })); }

  const resultados = postulaciones.map(p => {
    const evs = evaluaciones.filter(e => e.post_id === p.id);
    const promedio = evs.length ? Math.round(evs.reduce((a, b) => a + b.total, 0) / evs.length) : null;
    return { ...p, evs, promedio };
  }).sort((a, b) => (b.promedio || 0) - (a.promedio || 0));

  const TABS = [
    { id: "dashboard",    label: "📊 Dashboard" },
    { id: "postulaciones",label: "📋 Postulaciones" },
    { id: "usuarios",     label: "👥 Usuarios" },
    { id: "resultados",   label: "🏆 Resultados" },
    { id: "config",       label: "⚙️ Configuración" },
  ];

  if (loading) return <Spinner />;

  return (
    <div>
      <div style={{ marginBottom: 20 }}>
        <h2 style={{ fontSize: 21, fontWeight: 800, margin: "0 0 3px" }}>Panel de Administración</h2>
        <p style={{ color: "#6B7280", margin: 0, fontSize: 13 }}>{config?.nombre_diplomado}</p>
      </div>

      <div style={{ display: "flex", gap: 7, marginBottom: 20, flexWrap: "wrap" }}>
        {TABS.map(t => (
          <button key={t.id} onClick={() => setTab(t.id)} style={{ padding: "8px 16px", borderRadius: 10, border: "none", fontFamily: "inherit", fontWeight: 700, fontSize: 12, cursor: "pointer", background: tab === t.id ? "linear-gradient(135deg,#6366F1,#8B5CF6)" : "rgba(255,255,255,0.05)", color: tab === t.id ? "#fff" : "#9CA3AF" }}>{t.label}</button>
        ))}
      </div>

      {/* DASHBOARD */}
      {tab === "dashboard" && (
        <div>
          <div style={{ display: "grid", gridTemplateColumns: "repeat(auto-fit,minmax(150px,1fr))", gap: 12, marginBottom: 20 }}>
            {[
              { label: "Candidatos",    val: users.filter(u => u.role === "candidato").length,  icon: "👤", color: "#6366F1" },
              { label: "Postulaciones", val: postulaciones.length,                               icon: "📋", color: "#8B5CF6" },
              { label: "Evaluaciones",  val: evaluaciones.length,                               icon: "📊", color: "#10B981" },
              { label: "Evaluadores",   val: users.filter(u => u.role === "evaluador").length,  icon: "⚖️", color: "#F59E0B" },
            ].map(s => (
              <Card key={s.label} style={{ textAlign: "center", padding: 16 }}>
                <p style={{ margin: "0 0 5px", fontSize: 22 }}>{s.icon}</p>
                <p style={{ margin: "0 0 2px", fontSize: 26, fontWeight: 800, color: s.color }}>{s.val}</p>
                <p style={{ margin: 0, fontSize: 11, color: "#6B7280", fontWeight: 600 }}>{s.label}</p>
              </Card>
            ))}
          </div>
          <Card>
            <h3 style={{ margin: "0 0 14px", fontWeight: 700, fontSize: 14 }}>📅 Fases del Concurso</h3>
            {(config?.fases || []).map((f, i) => {
              const v = isDeadlinePassed(f.deadline);
              return (
                <div key={f.id} style={{ display: "flex", alignItems: "center", gap: 12, padding: "11px 0", borderBottom: "1px solid rgba(255,255,255,0.06)" }}>
                  <div style={{ width: 30, height: 30, background: v ? "rgba(239,68,68,0.15)" : "rgba(99,102,241,0.15)", borderRadius: 8, display: "flex", alignItems: "center", justifyContent: "center", fontWeight: 800, color: v ? "#EF4444" : "#6366F1", fontSize: 12 }}>{i + 1}</div>
                  <div style={{ flex: 1 }}>
                    <p style={{ margin: 0, fontWeight: 700, fontSize: 13 }}>{f.nombre}</p>
                    <p style={{ margin: 0, fontSize: 11, color: "#6B7280" }}>{f.descripcion}</p>
                  </div>
                  <div style={{ textAlign: "right" }}>
                    <p style={{ margin: "0 0 3px", fontSize: 12, fontWeight: 700, color: v ? "#EF4444" : "#F59E0B" }}>
                      {new Date(f.deadline + "T12:00:00").toLocaleDateString("es-ES", { day: "numeric", month: "short", year: "numeric" })}
                    </p>
                    <Badge color={v ? "#EF4444" : "#10B981"}>{v ? "Vencida" : "Activa"}</Badge>
                  </div>
                </div>
              );
            })}
          </Card>
        </div>
      )}

      {/* POSTULACIONES */}
      {tab === "postulaciones" && (
        <div style={{ display: "grid", gap: 10 }}>
          {postulaciones.length === 0
            ? <Card style={{ textAlign: "center", padding: 50 }}><p style={{ color: "#6B7280" }}>No hay postulaciones aún.</p></Card>
            : postulaciones.map(p => (
              <Card key={p.id} style={{ display: "flex", alignItems: "center", gap: 14, flexWrap: "wrap" }}>
                <div style={{ flex: 1 }}>
                  <p style={{ margin: "0 0 3px", fontWeight: 700 }}>{p.user_name}</p>
                  <p style={{ margin: 0, fontSize: 12, color: "#6B7280" }}>{Object.keys(p.fases || {}).length} fases · {new Date(p.created_at).toLocaleDateString("es-ES")}</p>
                </div>
                <Badge color={statusColor(p.status)}>{p.status}</Badge>
              </Card>
            ))}
        </div>
      )}

      {/* USUARIOS */}
      {tab === "usuarios" && (
        <div>
          <Card style={{ marginBottom: 16 }}>
            <h3 style={{ margin: "0 0 14px", fontWeight: 700, fontSize: 14 }}>➕ Crear Nuevo Usuario</h3>
            <div style={{ display: "grid", gridTemplateColumns: "1fr 1fr", gap: 10 }}>
              <Inp label="Nombre completo" value={newUser.name} onChange={e => setNewUser(p => ({ ...p, name: e.target.value }))} placeholder="Ej: Dr. Juan Pérez" />
              <Inp label="Usuario (login)" value={newUser.username} onChange={e => setNewUser(p => ({ ...p, username: e.target.value }))} placeholder="Ej: jperez" />
              <Inp label="Contraseña" value={newUser.password} onChange={e => setNewUser(p => ({ ...p, password: e.target.value }))} placeholder="Mínimo 4 caracteres" />
              <div style={{ marginBottom: 14 }}>
                <label style={{ display: "block", fontSize: 12, fontWeight: 600, color: "#9CA3AF", marginBottom: 5 }}>ROL</label>
                <select value={newUser.role} onChange={e => setNewUser(p => ({ ...p, role: e.target.value }))} style={{ width: "100%", background: "rgba(255,255,255,0.06)", border: "1px solid rgba(255,255,255,0.14)", borderRadius: 10, padding: "11px 14px", color: "#F3F4F6", fontSize: 14, fontFamily: "inherit" }}>
                  <option value="candidato">Candidato</option>
                  <option value="evaluador">Evaluador</option>
                  <option value="admin">Administrador</option>
                </select>
              </div>
            </div>
            <Btn onClick={crearUser} variant="success" loading={saving}>✅ Crear Usuario</Btn>
          </Card>
          <Card>
            <h3 style={{ margin: "0 0 14px", fontWeight: 700, fontSize: 14 }}>👥 Usuarios Registrados ({users.length})</h3>
            <div style={{ display: "grid", gap: 8 }}>
              {users.map(u => (
                <div key={u.id} style={{ display: "flex", alignItems: "center", gap: 12, padding: "10px 14px", background: "rgba(255,255,255,0.03)", borderRadius: 10, border: "1px solid rgba(255,255,255,0.06)" }}>
                  <div style={{ width: 34, height: 34, background: { admin: "rgba(245,158,11,0.15)", evaluador: "rgba(139,92,246,0.15)", candidato: "rgba(16,185,129,0.15)" }[u.role], borderRadius: 9, display: "flex", alignItems: "center", justifyContent: "center", fontSize: 14 }}>
                    {u.role === "admin" ? "⚙️" : u.role === "evaluador" ? "⚖️" : "👤"}
                  </div>
                  <div style={{ flex: 1 }}>
                    <p style={{ margin: "0 0 1px", fontWeight: 700, fontSize: 13 }}>{u.name}</p>
                    <p style={{ margin: 0, fontSize: 11, color: "#6B7280" }}>@{u.username}</p>
                  </div>
                  <Badge color={{ admin: "#F59E0B", evaluador: "#8B5CF6", candidato: "#10B981" }[u.role]}>{u.role}</Badge>
                  {u.username !== "admin" && <Btn small variant="danger" onClick={() => eliminarUser(u.id)}>Eliminar</Btn>}
                </div>
              ))}
            </div>
          </Card>
        </div>
      )}

      {/* RESULTADOS */}
      {tab === "resultados" && (
        <Card>
          <h3 style={{ margin: "0 0 4px", fontWeight: 700 }}>🏆 Ranking de Candidatos</h3>
          <p style={{ margin: "0 0 16px", color: "#6B7280", fontSize: 12 }}>Promedio de puntajes de todos los evaluadores</p>
          {resultados.length === 0
            ? <p style={{ color: "#6B7280", textAlign: "center", padding: 28 }}>Sin evaluaciones todavía.</p>
            : resultados.map((r, idx) => (
              <div key={r.id} style={{ display: "flex", alignItems: "center", gap: 12, padding: "12px 0", borderBottom: "1px solid rgba(255,255,255,0.06)" }}>
                <span style={{ fontWeight: 800, fontSize: 16, color: [,"#F59E0B","#9CA3AF","#CD7F32"][idx+1] || "#4B5563", minWidth: 24 }}>#{idx+1}</span>
                <div style={{ flex: 1 }}>
                  <p style={{ margin: "0 0 2px", fontWeight: 700, fontSize: 13 }}>{r.user_name}</p>
                  <p style={{ margin: 0, fontSize: 11, color: "#6B7280" }}>{r.evs.length} evaluación(es)</p>
                </div>
                {r.promedio !== null
                  ? <div style={{ textAlign: "center" }}><p style={{ margin: 0, fontSize: 19, fontWeight: 800, color: r.promedio >= 70 ? "#10B981" : "#F59E0B" }}>{r.promedio}</p><p style={{ margin: 0, fontSize: 10, color: "#6B7280" }}>/ 100</p></div>
                  : <Badge color="#6B7280">Sin evaluar</Badge>}
                <Badge color={r.promedio >= 70 ? "#10B981" : r.promedio !== null ? "#EF4444" : "#6B7280"}>
                  {r.promedio >= 70 ? "Aprobado" : r.promedio !== null ? "No aprobado" : "Pendiente"}
                </Badge>
              </div>
            ))}
        </Card>
      )}

      {/* CONFIGURACIÓN */}
      {tab === "config" && (
        <div>
          <Card style={{ marginBottom: 16 }}>
            <h3 style={{ margin: "0 0 12px", fontWeight: 700, fontSize: 14 }}>🎓 Nombre del Diplomado</h3>
            <Inp label="Nombre que aparece en el portal y en el login" value={configDraft.nombre_diplomado} onChange={e => setConfigDraft(p => ({ ...p, nombre_diplomado: e.target.value }))} />
          </Card>
          <Card style={{ marginBottom: 16 }}>
            <div style={{ display: "flex", justifyContent: "space-between", alignItems: "center", marginBottom: 16 }}>
              <h3 style={{ margin: 0, fontWeight: 700, fontSize: 14 }}>📅 Fases del Concurso</h3>
              <Btn small variant="success" onClick={addFase}>+ Agregar Fase</Btn>
            </div>
            {configDraft.fases.map((f, i) => (
              <div key={f.id} style={{ background: "rgba(255,255,255,0.03)", border: "1px solid rgba(255,255,255,0.07)", borderRadius: 12, padding: 14, marginBottom: 10 }}>
                <div style={{ display: "flex", justifyContent: "space-between", alignItems: "center", marginBottom: 10 }}>
                  <span style={{ fontWeight: 700, color: "#9CA3AF", fontSize: 11, letterSpacing: 1 }}>FASE {i + 1}</span>
                  <Btn small variant="danger" onClick={() => delFase(f.id)}>Eliminar</Btn>
                </div>
                <div style={{ display: "grid", gridTemplateColumns: "1fr 1fr", gap: 10 }}>
                  <Inp label="Nombre" value={f.nombre} onChange={e => updFase(f.id, "nombre", e.target.value)} />
                  <Inp label="Fecha límite" type="date" value={f.deadline} onChange={e => updFase(f.id, "deadline", e.target.value)} />
                </div>
                <Inp label="Descripción" value={f.descripcion} onChange={e => updFase(f.id, "descripcion", e.target.value)} />
              </div>
            ))}
          </Card>
          <div style={{ display: "flex", alignItems: "center", gap: 12 }}>
            <Btn onClick={guardarConfig} loading={saving}>💾 Guardar Cambios</Btn>
            {savedMsg && <span style={{ color: "#10B981", fontWeight: 700, fontSize: 13 }}>{savedMsg}</span>}
          </div>
        </div>
      )}
    </div>
  );
}

// ─── ROOT ─────────────────────────────────────────────────────────────────────
export default function App() {
  const [currentUser, setCurrentUser] = useState(null);
  const [config, setConfig] = useState(null);
  const [loadingApp, setLoadingApp] = useState(true);

  useEffect(() => {
    // Cargar fuente
    const link = document.createElement("link");
    link.href = "https://fonts.googleapis.com/css2?family=Sora:wght@400;600;700;800&display=swap";
    link.rel = "stylesheet";
    document.head.appendChild(link);
    // Cargar config desde Supabase
    loadConfig();
  }, []);

  async function loadConfig() {
    const { data } = await supabase.from("config").select("*").eq("id", 1).single();
    setConfig(data || { nombre_diplomado: "Diplomatura Neurolatinvet 2026", fases: [] });
    setLoadingApp(false);
  }

  if (loadingApp) return <Spinner />;

  const ctx = { currentUser, setCurrentUser, config, setConfig };

  return (
    <AppContext.Provider value={ctx}>
      {!currentUser
        ? <Login />
        : <Shell>
            {currentUser.role === "candidato"  && <CandidatoView />}
            {currentUser.role === "evaluador"  && <EvaluadorView />}
            {currentUser.role === "admin"      && <AdminView />}
          </Shell>}
    </AppContext.Provider>
  );
}
