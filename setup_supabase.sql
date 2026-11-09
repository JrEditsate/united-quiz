create table if not exists public.quiz_results (
  id bigint generated always as identity primary key,
  player_name text not null check (char_length(player_name) between 2 and 30),
  score integer not null check (score between 0 and 400 and score % 10 = 0),
  correct_count integer not null check (correct_count between 0 and 40),
  duration_seconds integer not null check (duration_seconds between 1 and 400),
  created_at timestamptz not null default now(),
  constraint quiz_score_matches_correct check (score = correct_count * 10)
);

alter table public.quiz_results enable row level security;

drop policy if exists "Public can read leaderboard" on public.quiz_results;
create policy "Public can read leaderboard"
on public.quiz_results for select to anon using (true);

drop policy if exists "Public can submit quiz result" on public.quiz_results;
create policy "Public can submit quiz result"
on public.quiz_results for insert to anon
with check (
  char_length(player_name) between 2 and 30
  and score between 0 and 400
  and score % 10 = 0
  and correct_count between 0 and 40
  and score = correct_count * 10
  and duration_seconds between 1 and 400
);

grant select, insert on public.quiz_results to anon;
grant usage, select on sequence public.quiz_results_id_seq to anon;
