# Trade Log

A personal trading journal for Zerodha F&O, positional and delivery trades. It's a static site (GitHub Pages) with your data in your own Supabase database.

- **Import** Zerodha Console tradebook CSVs (Equity and F&O). Trades are rebuilt from every buy and sell; uploading overlapping dates never duplicates anything, and re-imports keep your stops, tags, notes and screenshots.
- **Log trades** by hand with entry, stop, target and exit, plus strategy, emotion and mistake tags.
- **Chart screenshots** on any trade, stored privately in Supabase Storage.
- **Dashboard**: net P&L after charges, win rate, profit factor, expectancy, R-multiples, equity curve with maximum and current drawdown, daily P&L calendar, monthly P&L, and breakdowns by strategy, instrument and mistake.
- **Charges** follow Zerodha's charge list after the 1 April 2026 STT increase; every rate can be changed in the app.
- **Backup**: download all trades as a JSON file and restore them any time.

## Files

| File | What it is |
|---|---|
| `index.html` | The whole app |
| `config.js` | Your Supabase project URL and anon key |
| `schema.sql` | Database tables, privacy rules and the screenshots bucket |

## Setup (about 10 minutes)

1. **Create the database.** At supabase.com, create a free project (region: Mumbai). Open **SQL Editor → New query**, paste all of `schema.sql`, and click **Run**.
2. **Add your keys.** In Supabase, open **Project Settings → API**. On GitHub, open `config.js`, click the pencil icon, paste the **Project URL** and the **anon public** key, and commit.
3. **Turn on GitHub Pages.** Repo **Settings → Pages → Source: Deploy from a branch → `main` / `(root)` → Save**. Your site will be at `https://<username>.github.io/<repo>/` within a minute or two.
4. **Allow sign-in links back to your site.** In Supabase, open **Authentication → URL Configuration**. Set **Site URL** to your GitHub Pages address, and add the same address under **Redirect URLs**.
5. **Sign in.** Open your site, enter your email, and click the link that arrives.
6. **Lock it to you.** After your first sign-in, go to **Authentication → Sign In / Providers** in Supabase and turn off **Allow new users to sign up**. Even before that, nobody else can see your trades: every row and screenshot is tied to your account.

The anon key in `config.js` is designed to be public. Your data is protected by sign-in and the row-level security rules in `schema.sql`, not by hiding that key. Never put the **service_role** key in this repo.

If `config.js` still has the placeholder values, the app still works but saves trades only in that browser.
