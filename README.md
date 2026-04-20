# Diplomatura Neurolatinvet 2026 — Portal de Postulación

## PASO 1 — Configurar Supabase (base de datos)

1. Ve a https://supabase.com/dashboard/project/eeodyjmlbzwjnfsvlurx/sql/new
2. Copia y pega todo el contenido del archivo **SUPABASE_SQL.sql**
3. Haz clic en **Run** (botón verde)
4. Deberías ver: "Success. No rows returned"

---

## PASO 2 — Subir el proyecto a GitHub

1. Ve a https://github.com y crea una cuenta si no tienes
2. Crea un repositorio nuevo llamado `neurolatinvet`
3. Descarga e instala GitHub Desktop: https://desktop.github.com
4. Clona el repositorio vacío en tu computadora
5. Copia todos los archivos de esta carpeta dentro del repositorio
6. En GitHub Desktop: escribe un mensaje ("primer commit") y haz clic en **Commit** y luego **Push**

---

## PASO 3 — Publicar en Vercel (gratis)

1. Ve a https://vercel.com y crea una cuenta con tu GitHub
2. Haz clic en **Add New Project**
3. Selecciona el repositorio `neurolatinvet`
4. En **Environment Variables** agrega estas dos:
   - `REACT_APP_SUPABASE_URL` = `https://eeodyjmlbzwjnfsvlurx.supabase.co`
   - `REACT_APP_SUPABASE_ANON_KEY` = `sb_publishable_NduiAxB_oihBee12NYDdHQ_03ANGPo_`
5. Haz clic en **Deploy**
6. En 2-3 minutos tendrás tu link público: `neurolatinvet.vercel.app`

---

## Usuarios iniciales

| Rol        | Usuario     | Contraseña |
|------------|-------------|------------|
| Admin      | admin       | admin123   |
| Evaluador  | evaluador1  | eval123    |
| Candidato  | candidato1  | cand123    |

Puedes crear más usuarios desde el panel de Administración → Usuarios.

---

## Estructura del proyecto

```
neurolatinvet/
├── public/
│   └── index.html
├── src/
│   ├── App.js          ← App principal
│   ├── supabase.js     ← Conexión a base de datos
│   └── index.js        ← Punto de entrada
├── .env                ← Variables de entorno (NO subir a GitHub público)
├── package.json
├── SUPABASE_SQL.sql    ← Script para crear las tablas
└── README.md
```

## ⚠️ Importante

- El archivo `.env` contiene tus claves. Si tu repositorio es **público**, 
  NO subas el `.env`. En su lugar usa las variables de entorno de Vercel.
- En Vercel las variables se configuran en el paso 4 de arriba.
