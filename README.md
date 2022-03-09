# Treehole🦉

A flutter app which you can say anything to it.

## supabase setup SQL

1. profiles table

```sql
create table profiles (
  id uuid references auth.users not null,
  username varchar unique,
  avatar_url text,
  joy float not null DEFAULT 0.2,
  mild float not null DEFAULT 0.2,
  disgust float not null DEFAULT 0.2,
  depressed float not null DEFAULT 0.2,
  anger float not null DEFAULT 0.2,
  primary key (id),
  unique(username),
  constraint username_length check (char_length(username) >= 3)
);

alter table
  profiles enable row level security;

create policy "Public profiles are viewable by everyone." on profiles for
select
  using (true);

create policy "Users can insert their own profile." on profiles for
insert
  with check (auth.uid() = id);

create policy "Users can update own profile." on profiles for
update
  using (auth.uid() = id);

-- Set up Storage!
insert into
  storage.buckets (id, name)
values
  ('avatars', 'avatars');

create policy "Avatar images are publicly accessible." on storage.objects for
select
  using (bucket_id = 'avatars');

create policy "Anyone can upload an avatar." on storage.objects for
insert
  with check (bucket_id = 'avatars');

create policy "Anyone can update an avatar." on storage.objects for
update
  with check (bucket_id = 'avatars');
```

2. posts table

```sql
create table posts (
  id uuid not null,
  author_id uuid references profiles.id not null,
  content text not null,
  created_at timestamp with time zone DEFAULT timezone('utc' :: text, now()) NOT NULL,
  joy float not null DEFAULT 0,
  mild float not null DEFAULT 0,
  disgust float not null DEFAULT 0,
  depressed float not null DEFAULT 0,
  anger float not null DEFAULT 0,
  permission int not null default 0,
  primary key (id)
);

alter table
  posts enable row level security;

create policy "Public posts are viewable by everyone." on posts for
select
  using (true);

create policy "Users can insert their own posts." on posts for
insert
  with check (auth.uid() = id);

create policy "Users can update own posts." on posts for
update
  using (auth.uid() = id);
```

3. follow table

```sql
CREATE TABLE follow (
  following_id uuid references profiles not null,
  followed_id uuid references profiles not null,
  created_at timestamp with time zone DEFAULT timezone('utc' :: text, now()) NOT NULL,
  primary key (following_id, followed_id),
  constraint can_not_follow_self check (following_id != followed_id)
);

alter table
  follow enable row level security;

create policy "Follow relationship are viewable by following and followed." on follow for
select
  using (
    auth.uid() = following_id
    or auth.uid() = followed_id
  );

create policy "Users can follow anyone." on follow for
insert
  with check (true);

create policy "Follow relationship can be deleted by following." on follow for delete using (auth.uid() = following_id);
```

4. likes table

```sql
CREATE TABLE likes (
  user_id uuid references profiles not null,
  post_id uuid references posts not null,
  created_at timestamp with time zone DEFAULT timezone('utc' :: text, now()) NOT NULL,
  primary key (user_id, post_id)
);

alter table
  likes enable row level security;

create policy "Like relationship are viewable by everyone." on likes for
select
  using (true);

create policy "Users can like any posts." on likes for
insert
  with check (true);

create policy "Like relationship can be deleted by user." on likes for delete using (auth.uid() = user_id);
```

5. pals view

```sql
create
or replace view pals as
select
  follow.following_id as user_id,
  follow.followed_id as pal_id
from
  follow
  join follow rfollow on follow.following_id = rfollow.followed_id
  and follow.followed_id = rfollow.following_id;
```

6. notification view

```sql
create
or replace view notifications as
select
  0 as kind,
  follow.following_id as sender_id,
  follow.followed_id as receiver_id,
  follow.created_at as created_at,
  profiles.username as sender_username,
  profiles.avatar_url as sender_avatar_url,
  (
    (
      select
        count(*)
      from
        pals
      where
        pals.pal_id = follow.following_id
    ) :: int > 0
  ) :: boolean as is_followed -- only for follow
from
  follow
  join profiles on follow.following_id = profiles.id;
```

7. feed_posts function

```sql
CREATE
OR REPLACE FUNCTION feed_posts(user_id uuid, page int) RETURNS TABLE (
  id uuid,
  created_at timestamp with time zone,
  author_id uuid,
  content text,
  permission int,
  username varchar,
  avatar_url text,
  like_count int,
  is_liked boolean
) LANGUAGE plpgsql AS $func$
BEGIN
  RETURN QUERY
  select
    posts.id,
    posts.created_at,
    posts.author_id,
    posts.content,
    posts.permission,
    profiles.username,
    profiles.avatar_url,
    (select count(*) from likes where likes.post_id = posts.id)::int as like_count,
    ((select count(*) from likes where likes.post_id = posts.id and likes.user_id = $1)::int > 0)::boolean as is_liked
  from posts
  join profiles on profiles.id = posts.author_id
  where (posts.author_id in (select pals.pal_id from pals where $1 = pals.user_id) and posts.permission > 0) or posts.author_id = $1
  order by created_at desc
  limit 10 offset 10 * $2;
END
$func$;
```

8. match_pal function

```sql
CREATE
OR REPLACE FUNCTION match_pal(user_id uuid) RETURNS TABLE (
  id uuid,
  username varchar,
  avatar_url text,
  joy float,
  mild float,
  disgust float,
  depressed float,
  anger float
) LANGUAGE plpgsql AS $func$
DECLARE
  user_joy float := (select profiles.joy from profiles where profiles.id = $1);
  user_mild float := (select profiles.mild from profiles where profiles.id = $1);
  user_disgust float := (select profiles.disgust from profiles where profiles.id = $1);
  user_depressed float := (select profiles.depressed from profiles where profiles.id = $1);
  user_anger float := (select profiles.anger from profiles where profiles.id = $1);
  emotion_range float := 0.2;
BEGIN
  RETURN QUERY
  select
    profiles.id,
    profiles.username,
    profiles.avatar_url,
    profiles.joy,
    profiles.mild,
    profiles.disgust,
    profiles.depressed,
    profiles.anger
  from profiles
  where profiles.id != $1
  and profiles.joy <= user_joy + emotion_range and profiles.joy >= user_joy - emotion_range
  and profiles.mild <= user_mild + emotion_range and profiles.mild >= user_mild - emotion_range
  and profiles.disgust <= user_disgust + emotion_range and profiles.disgust >= user_disgust - emotion_range
  and profiles.depressed <= user_depressed + emotion_range and profiles.depressed >= user_depressed - emotion_range
  and profiles.anger <= user_anger + emotion_range and profiles.anger >= user_anger - emotion_range;
END
$func$;
```

9. my_liked_posts function

```sql
CREATE
OR REPLACE FUNCTION my_liked_posts(user_id uuid, page int) RETURNS TABLE (
  id uuid,
  created_at timestamp with time zone,
  author_id uuid,
  content text,
  permission int,
  username varchar,
  avatar_url text,
  like_count int
) LANGUAGE plpgsql AS $func$
BEGIN
  RETURN QUERY
  select
    posts.id,
    posts.created_at,
    posts.author_id,
    posts.content,
    posts.permission,
    profiles.username,
    profiles.avatar_url,
    (select count(*) from likes where likes.post_id = posts.id)::int as like_count
  from posts
  join profiles on profiles.id = posts.author_id
  join likes on likes.post_id = posts.id
  where likes.user_id = $1
  order by created_at desc
  limit 10 offset 10 * $2;
END
$func$;
```

10. my_posts function

```sql
CREATE
OR REPLACE FUNCTION my_posts(user_id uuid, page int) RETURNS TABLE (
  id uuid,
  created_at timestamp with time zone,
  author_id uuid,
  content text,
  permission int,
  username varchar,
  avatar_url text,
  like_count int,
  is_liked boolean
) LANGUAGE plpgsql AS $func$
BEGIN
  RETURN QUERY
  select
    posts.id,
    posts.created_at,
    posts.author_id,
    posts.content,
    posts.permission,
    profiles.username,
    profiles.avatar_url,
    (select count(*) from likes where likes.post_id = posts.id)::int as like_count,
    ((select count(*) from likes where likes.post_id = posts.id and likes.user_id = $1)::int > 0)::boolean as is_liked
  from posts
  join profiles on profiles.id = posts.author_id
  where posts.author_id = $1
  order by created_at desc
  limit 10 offset 10 * $2;
END
$func$;
```

11. paged_notification function

```sql
CREATE
OR REPLACE FUNCTION paged_notifications(user_id uuid, page int) RETURNS TABLE (
  kind int,
  sender_id uuid,
  receiver_id uuid,
  sender_username varchar,
  sender_avatar_url text,
  created_at timestamp with time zone,
  is_followed boolean
) LANGUAGE plpgsql AS $func$
BEGIN
  RETURN QUERY
  select
    notifications.kind,
    notifications.sender_id,
    notifications.receiver_id,
    notifications.sender_username,
    notifications.sender_avatar_url,
    notifications.created_at,
    notifications.is_followed
  from notifications
  where notifications.receiver_id = $1
  order by created_at desc
  limit 10 offset 10 * $2;
END
$func$;
```

12. search_posts function

```sql
CREATE OR REPLACE FUNCTION search_posts(user_id uuid, keyword text, page int)
  RETURNS TABLE (
    id uuid,
    created_at timestamp with time zone,
    author_id uuid,
    content text,
    permission int,
    username varchar,
    avatar_url text,
    like_count int,
    is_liked boolean
  )
  LANGUAGE plpgsql AS
$func$
BEGIN
  RETURN QUERY
  select
    posts.id,
    posts.created_at,
    posts.author_id,
    posts.content,
    posts.permission,
    profiles.username,
    profiles.avatar_url,
    (select count(*) from likes where likes.post_id = posts.id)::int as like_count,
    ((select count(*) from likes where likes.post_id = posts.id and likes.user_id = $1)::int > 0)::boolean as is_liked
  from posts
  join profiles on profiles.id = posts.author_id
  where posts.content ilike concat('%', $2, '%') and posts.permission > 2
  order by created_at desc
  limit 10 offset 10 * $3;
END
$func$;
```

13. today_posts function

```sql
CREATE
OR REPLACE FUNCTION today_posts(user_id uuid) RETURNS TABLE (
  id uuid,
  joy float,
  mild float,
  disgust float,
  depressed float,
  anger float
) LANGUAGE plpgsql AS $func$
BEGIN
  RETURN QUERY
  select
    posts.id,
    posts.joy,
    posts.mild,
    posts.disgust,
    posts.depressed,
    posts.anger
  from posts
  where posts.author_id = $1 and posts.created_at > now() - interval '1 day';
END
$func$;
```

## roadmap

- [x] 注册、登录
- [x] 个人信息
- [x] 黑暗模式
- [x] 发布推文
  - [ ] 推文加密存储
  - [ ] 上传图片
- [x] 我的推文
- [x] 订阅推文
- [x] 搜索推文
- [x] 点赞、我的点赞
- [x] 下拉加载更多
- [x] 推文权限设置
- [ ] 推文内容分析
  - [x] mock
  - [ ] lstm 算法
  - [ ] 客户端实现
- [x] 修改头像、用户名、密码
- [x] 用户简介页
- [x] 情绪模型
- [ ] ~~性格模型~~
- [x] 今日心情
- [x] 匹配好友
- [x] 添加好友
- [x] 取消好友关系
- [x] 消息通知
- [ ] 条件搜索
