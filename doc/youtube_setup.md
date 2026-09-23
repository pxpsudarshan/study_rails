# YouTube subtitle import

Enable YouTube Data API v3 in Google Cloud. Configure Google Auth Platform,
add the channel owner's Google account as a test user, and create a Web
application OAuth client. Under Data Access add the scope:

`https://www.googleapis.com/auth/youtube.force-ssl`

Google requires this broad permission for caption downloads; NIHO only lists
and downloads captions. Students do not need to authorize Google to play a video.
Only administrators and power users manage videos. Google connections remain personal
to each manager. Published lessons are shared with learners in the applicable channel
(including global lessons), without exposing the manager's Google credentials.

For local development, register this exact authorized redirect URI:

`http://localhost:3000/youtube/callback`

Edit Rails credentials locally (do not put secrets in source code or chat):

```sh
EDITOR="code --wait" ruby bin/rails credentials:edit
```

Merge this into the existing credentials without removing other settings:

```yaml
youtube:
  client_id: YOUR_CLIENT_ID
  client_secret: YOUR_CLIENT_SECRET
  redirect_uri: http://localhost:3000/youtube/callback
```

Alternatively set `YOUTUBE_CLIENT_ID`, `YOUTUBE_CLIENT_SECRET`, and
`YOUTUBE_REDIRECT_URI` in the server environment. Restart Rails after configuring.
For production, use the real HTTPS callback URL in both Google and NIHO.
Keep the Rails master key and secret_key_base stable: stored Google tokens are
encrypted with a key derived from the application's secret_key_base.

Run `ruby bin/rails db:migrate`, then open `/admin/video_lessons` and click
**Connect YouTube**. Do not navigate to the callback manually. After authorizing,
choose **Import from YouTube**, enter a title and video URL, find subtitles,
select a language, and import. **Refresh YouTube subtitles** replaces the saved
transcript only after a successful download and parse. Uploaded SRT/VTT files
remain supported.

The Google account must be able to edit the video. Downloads may fail when the
API is disabled, quota is exhausted, subtitles are still processing, or access
was revoked. Google OAuth projects in External/Testing mode can issue refresh
tokens that expire after seven days; reconnect during testing. Follow Google's
publishing/verification requirements before production use.

Disconnect removes locally stored credentials. Users can additionally revoke
NIHO from their Google Account's third-party connections.

References:
- https://developers.google.com/youtube/v3/guides/auth/server-side-web-apps
- https://developers.google.com/youtube/v3/docs/captions/download


## Video maintenance and study

Master maintenance > Video maintenance uses `video_genres` for a title and optional
subtitle (self-reference), description, order, channel and visibility. Existing
`video_lessons` are the content records, each belonging to one category. Both
models use the existing operator auditing and soft-deletion conventions.

Create a category, optionally add a subtitle, then import or upload a lesson in
All videos. Imports and migrated lessons are drafts. Edit the lesson to assign
its category and clear the draft checkbox. A hidden parent category also hides
all lessons under its subtitles. Deleting a category soft-deletes its descendants
and lessons. A maximum of two category levels is supported.

Learners use `/video_lessons` to search published titles, filter categories and
study with the interactive transcript. Management actions and OAuth connection
routes reject student accounts. A company manager can only manage their channel;
a manager without a company channel can manage the whole video catalog.
