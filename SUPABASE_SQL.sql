-- ============================================================
-- NEUROLATINVET 2026 — Script SQL para Supabase
-- Ejecuta esto completo en el SQL Editor de tu proyecto
-- ============================================================

-- 1. USUARIOS
create table if not exists usuarios (
  id uuid default gen_random_uuid() primary key,
  username text unique not null,
  password text not null,
  name text not null,
  role text not null check (role in ('admin', 'evaluador', 'candidato')),
  created_at timestamptz default now()
);

-- 2. CONFIGURACIÓN DEL DIPLOMADO
create table if not exists config (
  id int primary key default 1,
  nombre_diplomado text not null default 'Diplomatura Neurolatinvet 2026',
  fases jsonb not null default '[
    {"id":1,"nombre":"Educación Recibida","descripcion":"Títulos, diplomados, cursos y formación académica recibida","deadline":"2026-06-30"},
    {"id":2,"nombre":"Educación Impartida","descripcion":"Docencia, talleres, conferencias y actividades educativas impartidas","deadline":"2026-07-31"},
    {"id":3,"nombre":"Publicaciones Científicas","descripcion":"Artículos, libros, capítulos y trabajos científicos publicados","deadline":"2026-08-31"}
  ]'::jsonb,
  updated_at timestamptz default now()
);

-- 3. POSTULACIONES
create table if not exists postulaciones (
  id uuid default gen_random_uuid() primary key,
  user_id uuid references usuarios(id) on delete cascade,
  user_name text not null,
  status text not null default 'en_proceso',
  fases jsonb not null default '{}'::jsonb,
  created_at timestamptz default now(),
  updated_at timestamptz default now()
);

-- 4. EVALUACIONES
create table if not exists evaluaciones (
  id uuid default gen_random_uuid() primary key,
  post_id uuid references postulaciones(id) on delete cascade,
  evaluador_id uuid references usuarios(id) on delete cascade,
  evaluador_name text not null,
  scores jsonb not null default '{}'::jsonb,
  total int not null default 0,
  comentario text default '',
  created_at timestamptz default now(),
  unique(post_id, evaluador_id)
);

-- 5. DATOS INICIALES
-- Config por defecto (solo si no existe)
insert into config (id, nombre_diplomado) values (1, 'Diplomatura Neurolatinvet 2026')
on conflict (id) do nothing;

-- Usuarios iniciales
insert into usuarios (username, password, name, role) values
  ('admin',      'admin123', 'Administrador', 'admin'),
  ('evaluador1', 'eval123',  'Evaluador 1',   'evaluador'),
  ('candidato1', 'cand123',  'Candidato Demo','candidato')
on conflict (username) do nothing;

-- 6. DESHABILITAR RLS (Row Level Security) para simplicidad
-- En producción avanzada podrías habilitarlo, pero para esta app el control es manual
alter table usuarios      disable row level security;
alter table config        disable row level security;
alter table postulaciones disable row level security;
alter table evaluaciones  disable row level security;
