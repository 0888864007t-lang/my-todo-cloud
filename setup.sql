-- Chạy file này trong Supabase → SQL Editor → New query → Run
create table lists (
  id uuid primary key,
  user_id uuid not null default auth.uid() references auth.users on delete cascade,
  name text not null
);
create table tasks (
  id uuid primary key,
  user_id uuid not null default auth.uid() references auth.users on delete cascade,
  text text not null,
  done boolean not null default false,
  star boolean not null default false,
  myday date,
  due date,
  list text not null default 'tasks',
  created bigint not null
);
-- Mỗi người dùng chỉ đọc/ghi được dữ liệu của chính mình
alter table lists enable row level security;
alter table tasks enable row level security;
create policy "own lists" on lists for all using (user_id = auth.uid()) with check (user_id = auth.uid());
create policy "own tasks" on tasks for all using (user_id = auth.uid()) with check (user_id = auth.uid());
-- Bật đồng bộ thời gian thực
alter publication supabase_realtime add table tasks, lists;
