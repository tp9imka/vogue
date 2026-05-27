# docs/ — GitHub Pages site

Source for the public site published at
<https://tp9imka.github.io/vogue/>.

- `index.md` — landing page.
- `privacy.md` — the privacy policy (the URL App Store / Play want).
- `_config.yml` — Jekyll site config.

## Enabling Pages (one-time, in GitHub repo Settings)

1. Repo → **Settings → Pages**.
2. **Source**: Deploy from a branch.
3. **Branch**: `main`, folder `/docs`. **Save**.
4. Wait a minute; Pages publishes the site.
5. Verify the privacy URL loads:
   <https://tp9imka.github.io/vogue/privacy/>

Once published, paste that URL into App Store Connect /
Play Console as the "Privacy Policy URL".

## Updating the policy

Edit `docs/privacy.md` and merge to `main`. Pages auto-rebuilds on
push. The repo-root `PRIVACY.md` is kept in sync manually — they are
the same text, just one for the website and one for the repo.
