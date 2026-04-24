# Session state — resume here next time

## Where we are — M2.9 shipped (J2534 device auto-discovery via registry)

- **Scratch repo**: `/tmp/bench-mercedes` (rebuilt each sandbox session
  from the latest cumulative bundle — commits are unsigned there, see
  signing note at the bottom).
- **Delivery branch on this repo**: `claude/clarify-project-requirements-Qz5IO`.
  Each increment lands here as a `bench-mercedes-mX.Y-to-mX.Z.bundle`
  in `/artifacts/`.
- **User's real repo**: `https://github.com/rohite1983/Bench-mercedes`
  (private) on his Mac at `/Users/mohammedouchrif/Bench-mercedes`.
- **Plan file**: `docs/mercedes-diag-plan.md` on this branch.
- **Hard out-of-scope** (do not drift): anti-theft/VIN-lock write on
  head units; redistribution of Mercedes proprietary files; SCN.

## Milestone timeline shipped so far

| Commit  | Label  | What it did                                               |
|---------|--------|-----------------------------------------------------------|
| 31a4bc6 | M0     | Avalonia solution scaffold                                |
| 7d6da3b | M1     | DoIP transport + UDS services + DTC UI                    |
| 43edd0b | M1.1   | Upgrade to .NET 10                                        |
| 6577c0b | M1.2   | Fix NuGet build failures on .NET 10                       |
| 571b5b1 | M1.3   | Satisfy .NET 10 IDE style rules in build                  |
| 2954c03 | M1.4   | Drop unused MercedesDiag.Transport using                  |
| 8b5b090 | M1.5   | Fix Avalonia 11.2 XAML (no ColumnSpacing/RowSpacing)      |
| 1024256 | M2.0   | ISO-TP (ISO 15765-2) channel implementation               |
| a1d6bca | M1.6   | Expand ECU catalog + custom target address                |
| 713d67e | M2.1   | Fix ISO-TP CS4007 (ReadOnlyMemory across awaits)          |
| 7c0b04f | M2.2   | Drop unused Hal using in IsoTpChannelTests                |
| 20881c6 | M2.3   | KWP2000 client (ISO 14230) + 11 KWP tests                 |
| 0495c83 | M2.4   | Adapter + protocol selector UI, transport generalization  |
| d290c84 | M2.5   | Adapter auto-probe, ECU bus discovery, named custom, UI polish |
| 033f39e | M2.6   | Real PCAN-USB P/Invoke backend (Windows + Linux)          |
| 2210555 | M2.6f  | Fix CS0246 missing `using MercedesDiag.Hal` for IDoipAdapter |
| 932e9ba | M2.7   | Auto-detect DoIP vehicle + hide transport details behind Advanced expander |
| 4bfe0f8 | M2.8   | Real J2534 P/Invoke backend (Windows-only)                |
| bac8ace | M2.9   | Auto-discover installed J2534 PassThru devices via registry |
| 4b99028 | M2.9f  | Drop Microsoft.Win32.Registry pkg (NU1510 — framework now provides it) |

## What M2.7 added (UI simplification + DoIP auto-discovery)

- **DoIP vehicle detect** — a 'Detect vehicle' button (visible only for
  DoIP transport) calls `DoipDiscovery.DiscoverAsync` which broadcasts
  a UDP VehicleIdentificationRequest and waits 3 s for a
  VehicleAnnouncement. On success the vehicle IP/port and VIN are
  auto-populated into the settings fields; a small `DetectedVin` line
  shows under the transport summary.
- **Advanced expander** — all the 'inner plumbing' fields (vehicle IP,
  DoIP port, logical tester/ECU addresses, CAN bitrate, PCAN channel,
  CAN TX/RX IDs, J2534 DLL path, SDconnect host) moved inside an
  `<Expander Header="Advanced (manual overrides)">` that starts
  collapsed. The default view now shows only: Adapter → Re-probe →
  one-line `TransportSummary` → Detect button (DoIP) → Protocol →
  Target ECU + Scan bus → Custom target → Connect → VIN.
- **`TransportSummary` computed property** in MainWindowViewModel with
  `[NotifyPropertyChangedFor]` on every transport field so the summary
  auto-refreshes when the user tweaks Advanced.

## What M2.9 added (J2534 device auto-discovery)

- User reported that with Tactrix OpenPort 2.0 installed on the Windows
  PC, the app still prompted for a DLL path — which is the wrong UX.
  The J2534-04 spec standardises the registry location for PassThru
  DLLs, so all compliant vendors (Tactrix, PEAK, DrewTech Mongoose,
  Mongoose Plus, CarDAQ, etc.) can be enumerated without user input.
- **`src/MercedesDiag.Hal/J2534/J2534DeviceEnumerator.cs`** — reads
  `HKLM\SOFTWARE\PassThruSupport.04.04` in both `RegistryView.Registry64`
  and `RegistryView.Registry32` so a 64-bit host still sees the
  typically 32-bit-registered vendor DLLs. Returns a list of
  `J2534Device(Name, Vendor, DllPath)`. Deduplicated by DLL path.
  Platform-gated: returns empty on non-Windows.
- **`MercedesDiag.Hal.csproj`** — adds `Microsoft.Win32.Registry`
  5.0.0 (the ref-only package that exposes RegistryKey on net10.0).
- **`AdapterProbeService.ProbeJ2534`** — now reports e.g.
  `2 PassThru device(s) found: Tactrix OpenPort 2.0 J2534, PEAK
  PCAN-USB Pro FD`, or a clear install-your-driver message when empty.
- **`MainWindowViewModel`** — `J2534Devices` ObservableCollection,
  `SelectedJ2534Device` with a partial `OnSelectedJ2534DeviceChanged`
  that auto-sets `J2534DllPath`. `TryBuildSettings` falls back to
  the selected device's DLL path if the override field is empty.
  Re-probe refreshes both the transport probes and the J2534 device
  list, keeping the previous device selected if still present.
- **`MainWindow.axaml`** — when J2534 is the current transport, a
  top-level 'Device' dropdown shows installed PassThru devices.
  If the registry has no entries, a short hint explains the user
  can install a vendor driver or set the DLL manually in Advanced.
  The Advanced DLL path field is relabelled '(override)' and
  preceded by a hint so users know it's optional.

## What M2.8 added (J2534 PassThru backend)

- **`src/MercedesDiag.Hal/J2534/J2534Native.cs`** — J2534 P/Invoke
  layer. Because the DLL path is user-supplied at runtime,
  `[DllImport("…")]` won't work; instead `J2534Library` loads the DLL
  with `NativeLibrary.Load(dllPath)` and binds each PassThru function
  via `NativeLibrary.GetExport` + `Marshal.GetDelegateForFunctionPointer<T>`
  against `[UnmanagedFunctionPointer(CallingConvention.StdCall)]`
  delegates: `PassThruOpen/Close/Connect/Disconnect/ReadMsgs/WriteMsgs/
  StartMsgFilter/StopMsgFilter/Ioctl/GetLastError`. Includes the
  `PassThruMsg` struct (4128-byte inline `Data` via ByValArray),
  protocol/flag/ioctl/filter-type enums, and
  `J2534Errors.Describe(code)` mapping 0x00..0x1A to SAE-spec names.
- **`J2534Adapter.cs`** — replaces the throwing stub with a full
  `ICanAdapter`. `OpenAsync` guards Windows-only, loads the DLL, calls
  `PassThruOpen` → `PassThruConnect` on `Can` protocol at
  `BitrateKbps*1000`, installs a pass-all filter (required before RX
  flows), and starts a background pump reading into a bounded
  `Channel<CanFrame>(2048)` (DropOldest). `SendAsync` maps `CanFrame`
  → `PassThruMsg` with the 29-bit TX flag and 4-byte big-endian ID
  prefix. `CloseAsync` tears filter → channel → device down in order
  and disposes the library. macOS/Linux throw `PlatformNotSupported`
  up-front (no free PassThru DLLs outside Windows).

## Next session — first actions

User on his Mac (or Windows PC):
```
cd ~/normalize.css && git pull origin claude/clarify-project-requirements-Qz5IO
cd /Users/mohammedouchrif/Bench-mercedes   # (or the clone path on Windows)
git pull ~/normalize.css/artifacts/bench-mercedes-m2.8-to-m2.9.bundle main
git push origin main
dotnet restore && dotnet build && dotnet test
dotnet run --project src/MercedesDiag.App
```

(If behind M2.8, pull the previous bundles first in order:
`m2.3-to-m2.4`, `m2.4-to-m2.6`, `m2.6-to-m2.6fix`,
`m2.6fix-to-m2.8`, then this newest one.)

Expected after pull:
- The top of the sidebar is much cleaner: Adapter → Re-probe → single
  monospace `TransportSummary` line → Detect button (DoIP only) →
  Protocol → Target ECU → Connect.
- 'Detect vehicle' (DoIP) broadcasts a VIR, populates the vehicle
  IP/port and VIN from the car's announcement within ~3 s.
- All IP/port/CAN/PCAN/J2534 fine-tuning lives in the collapsed
  'Advanced (manual overrides)' expander.
- J2534: pointing the Advanced-expander 'J2534 DLL' field at a real
  vendor PassThru DLL on Windows (e.g. PEAK, Tactrix OpenPort 2.0,
  DrewTech Mongoose) + setting bitrate + IDs now actually opens the
  device, connects CAN, installs a pass filter, and sends/receives
  frames. macOS shows the J2534 option as unavailable.
- 32 tests still passing (no new unit tests in M2.7/M2.8 — both
  benefit most from live hardware integration tests; unit coverage
  for platform-gated backends lands later).

## Next milestone — M3 (live data + YAML coding)

- `src/MercedesDiag.Coding/Yaml/UserYamlProvider.cs` — user-supplied
  YAML coding definitions (`ecuName → did → bit/byte → featureName`).
- Periodic DID polling task with a live graph/gauge view in the UI.
- Coding tree UI (read-only values first; writes land in M4 behind a
  mandatory backup).

## Then — M4 (coding writes) and beyond

- `CodingWriteSafety` — every `0x2E WriteDataByIdentifier` preceded
  by a `0x22` read that gets persisted to a JSON backup file in the
  same session; one-click restore.
- Security access framework with pluggable seed/key from user-loaded
  DLLs/scripts.
- M5: `.aed` provider. M6: C3/C4 MUX passthrough + partial CBF reader.

## Open items

- Sandbox scope for `rohite1983/Bench-mercedes` still not granted,
  so the bundle workflow continues.
- `TransportSummary`'s DoIP line falls back to the default IP/port
  if Detect was never run — that's intentional; the Detect button
  is the auto path and manual fields in Advanced are the fallback.
- No unit tests yet for `AdapterProbeService`, `EcuDiscoveryService`,
  `PcanAdapter`, `J2534Adapter`, `DoipDiscovery`. All four gain the
  most value from real-hardware integration tests; simulator-backed
  unit tests can still be added on demand (e.g. fake `J2534Library`).
- UI language: English only; revisit multi-language in M3/M4.

## Known caveats still unresolved

- DoIP response-pending handling loops inside the outer timeout
  without bounding pending-count.
- `ReadDtcs` unconditionally enters extended session; some ECUs
  reject. Will add default-session fallback once we hit one.
- No security-access UI; API exists, UI lands M4.
- SDconnect remains unimplemented and will stay so until a real
  user need surfaces.
- J2534 backend is raw-CAN only (no KWP on K-line, no J1850). Fine
  for every Mercedes use case we target (all are CAN or DoIP).

## Sandbox signing note

Commits in the scratch repo at `/tmp/bench-mercedes` are unsigned
because the sandbox signing server rejects writes from that path
(`missing source`). Every M0..M2.8 commit follows the same pattern.
Signatures re-apply when the user pushes from his Mac.
