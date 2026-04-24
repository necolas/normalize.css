# Session artifacts

Unrelated to `normalize.css` itself. These files were produced in a
Claude Code session whose harness pinned the working branch to this
repository; they're the deliverables of that session's work on a
separate project and live here only because this was the one repo
the sandbox could push to.

## Current state: M1.1 committed (.NET 10 upgrade)

- `bench-mercedes-m1.1.bundle` — **latest, full history (M0 + M1 + M1.1).**
  Three commits: M0 scaffold, M1 DoIP+UDS+DTC work, M1.1 .NET 10 upgrade.
  Use this for a fresh import.
- `bench-mercedes-m1-to-m1.1.bundle` — incremental, M1.1 commit only.
  Use this if you already pushed M0+M1 to your GitHub repo and just
  want to add the upgrade commit.

### Already pushed M0+M1 to GitHub (your case right now)

From your local `Bench-mercedes` checkout on your Mac:

```bash
cd ~/path/to/Bench-mercedes
git pull /path/to/artifacts/bench-mercedes-m1-to-m1.1.bundle main
git push origin main
```

Then rerun the build from the repo root:

```bash
dotnet restore
dotnet build
dotnet test
dotnet run --project src/MercedesDiag.App
```

The SDK-version error should be gone — the project now targets
`net10.0` and drops the `global.json` pin, so your installed
`10.0.202` SDK will be picked up automatically.

### Fresh import (empty Bench-mercedes repo)

```bash
git clone artifacts/bench-mercedes-m1.1.bundle Bench-mercedes
cd Bench-mercedes
git remote set-url origin https://github.com/rohite1983/Bench-mercedes.git
git push -u origin main
```

## Historical

- `bench-mercedes-m1.bundle` / `bench-mercedes-m1.tar.gz` — M0+M1
  snapshot (pre .NET 10 upgrade). Kept for reference.
- `bench-mercedes-m0-to-m1.bundle` — incremental M1 commit on top
  of M0. Kept for reference.
- `bench-mercedes-m0.bundle` / `bench-mercedes-m0.tar.gz` — the
  original M0 scaffold. Prefer the M1.1 bundles above.

## After import: verify on your machine

```bash
dotnet restore
dotnet build
dotnet test
dotnet run --project src/MercedesDiag.App
```

You should see the Avalonia window open with connection fields,
an ECU dropdown, and empty DTC grid. If `dotnet build` fails, paste
the errors into the next session and I'll fix them.
