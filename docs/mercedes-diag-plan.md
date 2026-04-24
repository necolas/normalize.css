# Mercedes Diagnostic & Coding Tool — Personal / Workshop Edition

> **Note:** This document is unrelated to `normalize.css` itself. It was
> produced in a Claude Code session whose harness pinned the working
> branch to this repository; the content is the clarified requirements
> and architecture for a separate desktop application project the user
> is planning. It lives here only as a durable record of that session's
> deliverable. The actual project, when it starts, belongs in its own
> repository.

## Context

The user wants a Windows/macOS desktop application for Mercedes-Benz
diagnostics, variant coding, feature activation/deactivation, and "small
coding" — similar in spirit to MBTools, but scoped as a **personal /
workshop internal tool** for cars the user owns or services with the
owner's consent. Not redistributed, not sold.

This scope was chosen after an earlier discussion ruled out a commercial
clone, because a commercial product would require redistributing Mercedes
proprietary coding artefacts (SMR-D, CBF, .aed) which are Daimler IP.
Personal/workshop use on the user's own machine with files the user
already has is a very different legal situation and is the path we're
taking.

### Hard out-of-scope (will not implement, even in personal scope)

- **Anti-theft / VIN-lock write or reset on Audio20 / COMAND / NTG
  head units.** The dominant real-world use is reactivating stolen
  units; not building this.
- **Redistributing Mercedes proprietary files** (SMR-D, CBF, .aed,
  Xentry databases) inside the application binary or installer.
  The app reads files the user already has locally.
- **SCN online coding** (requires Mercedes backend credentials and
  cryptographic signatures — not feasible anyway).

### In scope

- Diagnostics: read/clear DTCs (with human-readable text where
  available), live data / PIDs, freeze-frame, actuator/routine tests,
  ECU identification, session & security access (seed/key where the
  user has the algorithm).
- Small coding and feature enable/disable via writing Data
  Identifiers (DIDs) — driven either by user-supplied maps or by
  interpreting SMR-D / CBF / .aed files the user loads locally.
- Service functions (service reset, SBC/EPB, DPF regen where
  documented, steering-angle calibration, etc.) on ECUs that accept
  standard UDS routine controls.
- Target vehicles: both pre-2015 (K-line / CAN, KWP2000 + UDS) and
  2015+ (DoIP over Ethernet).

## Tech stack (confirmed)

- **Language/UI:** C# with **Avalonia UI 11** (cross-platform
  Windows/macOS/Linux, native feel, modern MVVM via
  CommunityToolkit.Mvvm). Rejected .NET MAUI for desktop because
  Avalonia is more mature for Windows+macOS desktop today.
- **Runtime:** .NET 8 LTS.
- **DI / logging:** Microsoft.Extensions.Hosting, Serilog.
- **Testing:** xUnit + FluentAssertions; protocol layers tested with
  recorded ISO-TP traces.
- **Packaging:** MSIX (Windows) and `.app` bundle via
  `dotnet publish -r osx-arm64/osx-x64` with a notarised DMG.

## Proposed solution architecture

Layered, with each layer swappable and unit-testable in isolation.

```
+---------------------------------------------+
|  UI (Avalonia, MVVM)                        |  MercedesDiag.App
+---------------------------------------------+
|  Application services (coding engine,       |  MercedesDiag.Services
|  session orchestration, job queue)          |
+---------------------------------------------+
|  Diagnostic protocol stack                  |  MercedesDiag.Uds
|  - UDS (ISO 14229)                          |  MercedesDiag.Kwp
|  - KWP2000 (ISO 14230)                      |
|  - OBD-II mode 01-0A                        |
+---------------------------------------------+
|  Transport layer                            |  MercedesDiag.Transport
|  - ISO-TP (ISO 15765-2) over CAN            |
|  - DoIP (ISO 13400) over TCP/UDP            |
|  - K-line framing                           |
+---------------------------------------------+
|  Hardware abstraction (IAdapter)            |  MercedesDiag.Hal
|  - ENET / DoIP (sockets, no driver)         |
|  - J2534 (P/Invoke into vendor DLL)         |
|  - PCAN-Basic (P/Invoke)                    |
|  - SocketCAN (Linux only, future)           |
|  - ELM327 / STN (serial) - for bring-up     |
|  - C3/C4 MUX in passthrough mode            |
+---------------------------------------------+
```

`IAdapter` exposes a raw frame interface (send/receive 11/29-bit CAN
frames, or DoIP payloads). The ISO-TP / DoIP layer sits above and
presents a request/response API to the protocol stack. The protocol
stack never talks to hardware directly.

### Coding engine

A separate `MercedesDiag.Coding` assembly with pluggable
`ICodingProvider` implementations:

1. **UserYamlProvider** — simplest; user writes YAML describing
   `ecuName → did → bit/byte → featureName`. This is the "clean"
   provider that needs no proprietary formats and is enough for many
   everyday coding tasks. Build this first.
2. **AedProvider** — loads `.aed` files the user already has on disk
   and exposes their options as a tree. Reader only; no files shipped.
3. **CbfProvider / SmrdProvider** — later milestones. These are
   non-trivial (CBF is essentially a compiled ODX variant with its
   own VM for seed/key and conversion functions). Start with a
   partial reader for common opcodes; extend as real use demands.

The UI never hard-codes ECU knowledge — it renders whatever the
coding provider produces.

## Phased delivery

**M0 — Project skeleton (1–2 days of work)**
- New git repo (a fresh repo e.g. `mercedes-diag`, *not* this one).
- Avalonia solution with the project layout above, CI building on
  Windows + macOS, Serilog wired up, xUnit scaffolding.
- A "Hello ECU" screen that does nothing yet.

**M1 — Talk to one car over ENET (DoIP)**
- Implement DoIP transport (vehicle identification, routing
  activation, diagnostic message).
- Implement minimum UDS: `0x10` DiagnosticSessionControl, `0x22`
  ReadDataByIdentifier, `0x27` SecurityAccess (no algorithms yet),
  `0x19` ReadDTCInformation, `0x14` ClearDiagnosticInformation,
  `0x11` ECUReset, `0x31` RoutineControl.
- UI: ECU list, connect, read identification, read DTCs, clear DTCs.
- Verified on a 2015+ Mercedes via OBD-II ENET cable.

**M2 — Pre-2015 vehicles over CAN**
- PCAN adapter backend (P/Invoke to `PCANBasic.dll` / `libpcan`).
- ISO-TP implementation (single-frame, first-frame/consecutive-frame,
  flow-control).
- KWP2000-on-CAN service mapping (many services are UDS-compatible;
  a few like `0x1A` need a KWP-specific path).
- J2534 adapter backend (P/Invoke; Windows only for v1).

**M3 — Live data & coding (read-only first)**
- Periodic DID polling with a graph/gauge view.
- Coding tree UI driven by `UserYamlProvider`. Read current values
  and display them; do *not* write yet.
- Ship a small library of hand-written YAML for a few ECUs the user
  confirms on their own cars.

**M4 — Coding writes**
- `0x2E` WriteDataByIdentifier with a mandatory "confirm + backup"
  flow: the app always reads and saves current DID values to a JSON
  backup file before any write, and offers one-click restore.
- Security access framework: pluggable seed/key algorithms loaded
  from user-supplied DLLs or scripts (not shipped).

**M5 — .aed support**
- Loader for `.aed` files; render their option tree in the coding UI.
- Parity with the YAML provider on write/backup flow.

**M6 — C3/C4 passthrough and extras**
- Treat the MUX as a CAN/K-line gateway over its network interface
  (no proprietary protocol use).
- Optional SMR-D / CBF partial reader — only if real use demands it.

## Critical files (to be created in the new repo)

- `src/MercedesDiag.Hal/IAdapter.cs` — hardware abstraction
- `src/MercedesDiag.Hal/Doip/DoipAdapter.cs`
- `src/MercedesDiag.Hal/Pcan/PcanAdapter.cs`
- `src/MercedesDiag.Hal/J2534/J2534Adapter.cs`
- `src/MercedesDiag.Transport/IsoTp/IsoTpChannel.cs`
- `src/MercedesDiag.Transport/Doip/DoipChannel.cs`
- `src/MercedesDiag.Uds/UdsClient.cs` — high-level UDS service API
- `src/MercedesDiag.Coding/ICodingProvider.cs`
- `src/MercedesDiag.Coding/Yaml/UserYamlProvider.cs`
- `src/MercedesDiag.Coding/Aed/AedProvider.cs`
- `src/MercedesDiag.Services/DiagnosticSession.cs`
- `src/MercedesDiag.Services/CodingWriteSafety.cs` — backup & restore
- `src/MercedesDiag.App/` — Avalonia UI (Views, ViewModels)
- `tests/MercedesDiag.Uds.Tests/` — recorded-trace-driven tests
- `docs/SAFETY.md` — out-of-scope items (anti-theft, SCN) restated
  in repo so future contributors / future-you don't drift

## Libraries / tools to evaluate (not committed yet)

- **Avalonia.ReactiveUI** vs **CommunityToolkit.Mvvm** — pick one.
- **PCAN-Basic.NET** (Peak official binding) for PCAN.
- **Any-J2534 wrappers**: there is no good open binding; we'll
  P/Invoke the vendor DLL directly.
- **SharpPcap** — only if we later want to sniff DoIP on a lab PC.
- **YamlDotNet** — coding definitions.
- **MessagePack** — for backup file format.

## Verification plan

- **Unit tests**: ISO-TP, DoIP framing, UDS service encode/decode use
  recorded binary traces as fixtures. Run in CI on every PR.
- **Integration tests** behind a `[Trait("Hardware","Real")]` gate,
  run manually against a real ECU: connect over ENET, read VIN from
  `0x22 0xF1 0x90`, read and clear a pending DTC, write-then-restore
  a harmless DID (e.g. a user-configurable welcome string on a
  non-critical ECU).
- **Safety test**: every write path must refuse to run unless a
  backup file for that ECU's coding was written in the same session.
  This is itself unit-tested.
- **Manual end-to-end**: on the user's own test vehicle, reproduce
  a known coding change (e.g. enable/disable a convenience feature
  the user has documented), verify behaviour, then restore.

## Open items to resolve before starting M0

- Repo location: new GitHub repo name (e.g. `mercedes-diag`) and
  visibility (private recommended for personal workshop use).
- Which ENET cable / J2534 device / PCAN model the user actually
  has on the bench for M1 testing.
- Whether the user wants the UI in English only or multi-language
  from day one (Arabic + French were hinted at).
