import { createClient } from '@supabase/supabase-js';

export const supabase = createClient(
  'https://eeodyjmlbzwjnfsvlurx.supabase.co',
  'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImVlb2R5am1sYnp3am5mc3ZsdXJ4Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzY3MTU1MjIsImV4cCI6MjA5MjI5MTUyMn0.dV6GFlGYbN7hyeO0cAifysrIx24Beg08XV5hsB-lWT8'
);
