-- Menambahkan Storage Buckets untuk Bengkelin App

-- 1. Buat bucket untuk bengkel_profiles (public)
insert into storage.buckets (id, name, public) 
values ('bengkel_profiles', 'bengkel_profiles', true)
on conflict (id) do update set public = true;

-- 2. Buat bucket untuk bengkel_documents (public, karena aplikasi mengambil URL publik untuk dokumen)
insert into storage.buckets (id, name, public) 
values ('bengkel_documents', 'bengkel_documents', true)
on conflict (id) do update set public = true;



-- ----------------------------------------------------
-- Policies untuk bengkel_profiles
-- ----------------------------------------------------
-- Siapapun bisa melihat foto profil
create policy "Public Access Bengkel Profiles"
on storage.objects for select
using (bucket_id = 'bengkel_profiles');

-- User terautentikasi bisa mengunggah foto (ke folder mereka sendiri)
create policy "Auth Insert Bengkel Profiles"
on storage.objects for insert
to authenticated
with check (bucket_id = 'bengkel_profiles');

-- User bisa update dan delete foto mereka sendiri
create policy "Auth Update Bengkel Profiles"
on storage.objects for update
to authenticated
using (bucket_id = 'bengkel_profiles' and (auth.uid()::text = (string_to_array(name, '/'))[1]));

create policy "Auth Delete Bengkel Profiles"
on storage.objects for delete
to authenticated
using (bucket_id = 'bengkel_profiles' and (auth.uid()::text = (string_to_array(name, '/'))[1]));

-- ----------------------------------------------------
-- Policies untuk bengkel_documents
-- ----------------------------------------------------
-- Siapapun bisa melihat dokumen (karena butuh public URL)
create policy "Public Access Bengkel Documents"
on storage.objects for select
using (bucket_id = 'bengkel_documents');

-- User terautentikasi bisa mengunggah dokumen
create policy "Auth Insert Bengkel Documents"
on storage.objects for insert
to authenticated
with check (bucket_id = 'bengkel_documents');

-- User bisa update dan delete dokumen mereka sendiri
create policy "Auth Update Bengkel Documents"
on storage.objects for update
to authenticated
using (bucket_id = 'bengkel_documents' and (auth.uid()::text = (string_to_array(name, '/'))[1]));

create policy "Auth Delete Bengkel Documents"
on storage.objects for delete
to authenticated
using (bucket_id = 'bengkel_documents' and (auth.uid()::text = (string_to_array(name, '/'))[1]));
