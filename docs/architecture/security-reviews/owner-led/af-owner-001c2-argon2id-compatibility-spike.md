---
evidence_id: AF-OWNER-001C.2
owner_review_id: AF-OWNER-001
evidence_status: COMPLETED
compatibility_status: DEMONSTRATED
independent_verification: NOT_PERFORMED
legal_review: NOT_PERFORMED
---

# AF-OWNER-001C.2: Argon2id Compatibility Spike

**Assessment type:** Isolated Owner-led, non-independent compatibility experiment  
**Date:** 2026-11-14  
**Candidate:** `argon2` Ruby gem `2.3.3`  
**Scope:** Dependency build and functional compatibility only; no production integration or capacity approval  
**Related:** [Password/PIN Technical Control Specification](../../after_four_identity_password_pin_control_specification.md) · [AF-OWNER-001 Assessment](af-owner-001-password-pin-security.md) · [Identity Technical Design](../../after_four_identity_technical_design.md) · [ADR-0002](../../adr/0002-ruby-rails-version-baseline.md) · [ADR-0006](../../adr/0006-authentication-session-topology.md)

This is design and experiment evidence, not production approval. It does not select a production gem or work-factor profile, establish capacity or denial-of-service resistance, close any AF-OWNER-001 finding, accept residual risk, accept ADR-0006, or authorize Milestone 2B.

## 1. Question and acceptance boundary

The spike asks whether the candidate can be built and used reproducibly with AFTER FOUR's exact Ruby 3.4.12 Docker runtime. Compatibility is demonstrated only if an isolated execution records the exact platform and dependencies and passes hash creation, correct/wrong verification, encoded-parameter variation, malformed/unsupported input handling, and repeated-run checks.

The spike explicitly does not answer:

- which algorithm profile, salt/tag size, or cost values should be used in production;
- latency, resident memory, throughput, concurrency, saturation, or safe admission limits;
- Rails credential integration, normalization, blocklist, pepper, rate limiting, device binding, or storage design;
- maintenance suitability over the project's lifetime or independent cryptographic assurance.

## 2. Primary-source candidate review

### 2.1 Release and dependency metadata

RubyGems identifies `argon2` `2.3.3` as the current source release, published 2026-01-10, requiring Ruby `>= 2.6.0`; it also records MFA-required publishing. The release is a source gem rather than a platform-specific precompiled package. [RubyGems release metadata](https://rubygems.org/gems/argon2/versions/2.3.3)

The upstream gemspec declares:

- `ffi ~> 1.15`;
- `ffi-compiler ~> 1.0`;
- native extension entry point `ext/argon2_wrap/extconf.rb`;
- Ruby `>= 2.6.0`.

The extension invokes Ruby `mkmf`, and the gem includes the Argon2 reference C implementation under `ext/phc-winner-argon2`. Consequently a source build requires a C toolchain, `make`, Ruby native-extension headers/configuration, and the FFI build toolchain. The exact compiler/libc artifacts must be captured from the executed project image rather than inferred. [Upstream gemspec](https://github.com/technion/ruby-argon2/blob/master/argon2.gemspec) · [Extension entry point](https://github.com/technion/ruby-argon2/blob/master/ext/argon2_wrap/extconf.rb) · [Vendored reference implementation](https://github.com/technion/ruby-argon2/tree/master/ext)

### 2.2 Declared and tested runtime/platform support

The current upstream CI matrix runs its C build/test and Ruby suite for Ruby `3.3`, `3.4`, and `4.0` on `ubuntu-latest` and `macos-latest`. That is positive upstream evidence for the Ruby 3.4 line and both operating-system families, but it does not establish Ruby 3.4.12, AFTER FOUR's image, libc/compiler combination, or macOS arm64 specifically because the workflow does not pin a macOS CPU architecture. [Current upstream CI workflow](https://github.com/technion/ruby-argon2/blob/master/.github/workflows/ruby.yml)

The README's older design text still says only MRI 2.7/3.0 are tested, while the current CI file tests later runtimes. This documentation mismatch is a maintenance limitation and is a reason to rely on an exact local execution rather than a declaration alone. The README describes macOS as supported and Windows as unsupported. [Upstream README](https://github.com/technion/ruby-argon2)

### 2.3 Maintenance signals and limitations

Positive signals are a 2026 release after releases in 2025 and 2023, current CI coverage of Ruby 3.3/3.4/4.0 on Ubuntu/macOS, MFA-required gem publishing, and use of the upstream reference C code. These signals support continued investigation; they are not a security guarantee. [RubyGems release history](https://rubygems.org/gems/argon2/versions/2.3.3) · [Current upstream CI workflow](https://github.com/technion/ruby-argon2/blob/master/.github/workflows/ruby.yml)

Limitations visible in primary sources:

- README tested-version language is stale relative to CI.
- The changelog currently documents releases only through 2.1.0 even though 2.3.3 is published.
- The README warns that default work values can change between releases, so callers must not treat defaults as a stable production policy.
- The README states the wrapper imposes work-factor maximums tighter than the reference implementation to reduce accidental denial of service.
- The README states Ruby-level copies mean secure memory wiping should not be assumed.
- No project-specific independent security review or macOS arm64 execution is supplied by this repository evidence.

[Upstream changelog](https://github.com/technion/ruby-argon2/blob/master/Changelog.md) · [Upstream README](https://github.com/technion/ruby-argon2)

## 3. API and parameter semantics from source

The public password API documented upstream is:

```ruby
hasher = Argon2::Password.new(profile: :rfc_9106_low_memory)
encoded = hasher.create(password)
matched = Argon2::Password.verify_password(password, encoded)
```

It also accepts explicit `t_cost:`, `m_cost:`, and `p_cost:` keyword arguments and an optional `secret:`. Version 2.x creates Argon2id hashes and can verify encoded hashes whose parameters differ from the constructor because the encoded string carries algorithm/version/cost/salt/hash fields. The experiment must confirm these behaviors for 2.3.3 rather than relying only on examples. [Upstream README usage](https://github.com/technion/ruby-argon2#usage)

The critical library-specific mapping is:

| Ruby argument | Library semantics | Encoded Argon2 field |
|---|---|---|
| `t_cost` | iteration/pass count | `t=<integer>` |
| `m_cost` | base-2 exponent, not KiB | `m=2^m_cost` KiB |
| `p_cost` | parallelism/lanes | `p=<integer>` |

The source profile `m_cost: 16` is annotated as 64 MiB and encodes `m=65536`; `m_cost: 21` is annotated as 2 GiB. Therefore the canonical `memory_kib` value must be converted to and validated against this exponent interface—passing `65536` as `m_cost` would be a dangerous unit error. The current low-memory named profile source is `t_cost: 3`, `m_cost: 16`, `p_cost: 4`. All profiles remain unapproved candidates. [Profile source](https://github.com/technion/ruby-argon2/blob/master/lib/argon2/profiles.rb)

The README says `verify_password` returns `true` or `false` for match/mismatch, while errors from the C interface are raised as exceptions. Exact malformed and unsupported-hash behavior is recorded below and must not become a public error contract. [Upstream README](https://github.com/technion/ruby-argon2)

## 4. Isolated execution procedure

The experiment used a directory created with `mktemp -d /private/tmp/after-four-argon2-spike.XXXXXX`. It contained only a two-line Gemfile, its isolated lockfile, the assertion script, and temporary bundle trees. The application Gemfile and lockfile were not write targets.

The reproducible Docker procedure, with `$SPIKE_DIR` standing for the temporary path, was:

```bash
docker compose run --rm \
  -v "$SPIKE_DIR:/spike" -w /spike backend \
  bundle _2.6.9_ install --gemfile /spike/Gemfile --path /spike/vendor/bundle

docker compose run --rm \
  -e BUNDLE_PATH=/spike/vendor/bundle \
  -v "$SPIKE_DIR:/spike" -w /spike backend \
  bundle _2.6.9_ exec ruby compatibility_check.rb
```

The macOS arm64 procedure used the same lockfile/script and an independent bundle:

```bash
RBENV_VERSION=3.4.12 \
BUNDLE_GEMFILE="$SPIKE_DIR/Gemfile" \
BUNDLE_PATH="$SPIKE_DIR/vendor/macos" \
rbenv exec bundle _2.6.9_ install

RBENV_VERSION=3.4.12 \
BUNDLE_GEMFILE="$SPIKE_DIR/Gemfile" \
BUNDLE_PATH="$SPIKE_DIR/vendor/macos" \
rbenv exec bundle _2.6.9_ exec ruby "$SPIKE_DIR/compatibility_check.rb"
```

The evidence artifact digests were:

- `compatibility_check.rb`: SHA-256 `1828119c67f3c641a8e2fb936c62f94d8d55d2acb0ebdf91a80e15e3ac298eb4`
- isolated `Gemfile.lock`: SHA-256 `8db308f29ebdba49d56480474852693cd2f39e725434ad948f47d76d63dfdd5b`

Two harness-only setup failures preceded the valid runs. A fresh container initially inherited the image's `/usr/local/bundle` path rather than the mounted temporary bundle, fixed by explicitly setting `BUNDLE_PATH`. The first script also imported `base64`, which Ruby 3.4 reports is no longer a default gem; that unnecessary dependency was removed. A later assertion was corrected to recognize that safe malformed-input rejection may be either `false` or `Argon2::ArgonHashFail`. These were spike-harness corrections, not successful library assertions and not suppressed candidate failures.

## 5. Executed environment and results

### 5.1 Exact environments

| Environment | Executed identity |
|---|---|
| Docker/Linux | Local `backend-backend:latest` image ID `d96eecc9a5c0`; `ruby 3.4.12 (2026-10-23 revision 366f5fdc00) +PRISM [aarch64-linux]`; Bundler 2.6.9; Debian Bookworm; LinuxKit kernel 7.0.12; aarch64; glibc 2.36; GCC and Make present |
| macOS host | `ruby 3.4.12 (2026-10-23 revision 366f5fdc00) +PRISM [arm64-darwin25]`; Bundler 2.6.9; Darwin 25.0.0 arm64; Apple clang 17.0.0 |

The Docker environment is the project's documented backend image from `ruby:3.4.12-bookworm`. PostgreSQL was running because Compose declares it as a backend dependency, but the standalone compatibility script did not use the database or Rails application.

### 5.2 Resolved and built dependencies

The isolated lock resolved:

| Dependency | Exact version/platform in executed environment |
|---|---|
| `argon2` | 2.3.3 source gem |
| `ffi` | 1.17.4 `aarch64-linux-gnu` and 1.17.4 `arm64-darwin` |
| `ffi-compiler` | 1.4.3 |
| `rake` | 13.4.2 |
| Bundler | 2.6.9 |

Both environments reported `Installing argon2 2.3.3 with native extensions`. The Linux artifact was an aarch64 ELF shared object linked only to glibc/its loader; SHA-256 `a1fb24585c45036cdd4fa0e39b5dda6928b9bfad61880c259b8447c985e5475f`. The macOS artifact was a Mach-O 64-bit arm64 bundle linked to `/usr/lib/libSystem.B.dylib`; SHA-256 `aef6c2d511f9efb2bc60f4b3d5c06df5d9ab9290fbb17c4c0fe4f5f03c8816ae`.

The current development image happens to include GCC, Make, and Ruby build configuration through its base image even though the Dockerfile does not install a compiler explicitly. A future production build must not rely on that incidental fact: it needs a controlled build stage with the Ruby headers/configuration, C compiler, Make, `ffi-compiler`, and vendored Argon2 source, then a runtime stage containing the architecture-specific extension, compatible `ffi`, and libc/system runtime.

### 5.3 Functional results

The full assertion script ran once with detailed output and twice more in fresh ephemeral Docker containers. It also ran twice as independent Ruby processes on the macOS arm64 host. Every run completed with `status=PASS`; every run executed 25 passing assertions.

| Behavior | Actual result |
|---|---|
| Hash creation | Created Argon2id v19 encoded hashes in both environments. |
| Correct secret | Returned `true`. |
| Incorrect secret | Returned `false`. |
| Generated salts | Library constant is 16 bytes; encoded salt was 22 unpadded Base64 characters; five repeated creations produced five distinct hashes. |
| Default encoded metadata | `m=65536,t=3,p=4`; encoded length observed as 97 bytes. This is an observed library default, not an approved production profile. |
| Different parameters | Hashes created with Ruby options `(t_cost: 1, m_cost: 3, p_cost: 1)` and `(2,4,2)` encoded as `(t=1,m=8,p=1)` and `(t=2,m=16,p=2)` and both verified successfully. |
| Parameter-aware verification | `Argon2::Password.verify_password` successfully verified both custom hashes without a separate verifier profile; the encoded hash supplied its version/costs. |
| Repeated execution | Three fresh Linux containers and two macOS Ruby processes produced the same pass/reject semantics. Hash bytes intentionally differed because salts were fresh. |

No latency, memory, throughput, concurrency, saturation, or capacity measurement was taken. The word “default” above describes library behavior only and does not recommend it.

### 5.4 Malformed and unsupported hashes

| Case | Actual 2.3.3 behavior |
|---|---|
| Non-Argon2 string | Raised `Argon2::ArgonHashFail` with `Invalid hash`. |
| Malformed `m=` field in an Argon2id-looking string | Returned `false`. |
| Unsupported `argon2x` variant | Raised `Argon2::ArgonHashFail` with `Invalid hash`. |
| Unsupported version changed to `v=999` | Returned `false`. |

The future Credential Protection Adapter must treat both `false` and `Argon2::ArgonHashFail` as one generic authentication rejection, without exposing parser detail. It must validate stored metadata/profile floors before calling the library and must not use exception messages as a public contract. The gem's `valid_hash?` implementation is a coarse regular-expression gate, so it is not sufficient policy validation by itself.

### 5.5 Verified API/parameter mapping

Execution and installed source agree:

- `Argon2::Password.create(secret, options)` and `Argon2::Password.new(options).create(secret)` create hashes; `Argon2::Password.verify_password(secret, encoded, optional_secret)` verifies.
- Ruby `m_cost` is a base-2 exponent. The wrapper passes `1 << m_cost` to native Argon2, whose value and encoded `m=` field are KiB. `m_cost: 16` therefore means 65,536 KiB, not 16 KiB and not 65,536 as an input argument.
- `t_cost` is passed as the iteration/pass count.
- `p_cost` is passed as lanes/parallelism.
- v2.3.3 creates Argon2id v19 and uses a 16-byte generated salt and 32-byte output constant.
- The library accepts a `secret:` parameter, but this spike did not approve or validate AFTER FOUR's separate PIN-pepper construction.

### 5.6 Advisory scan

`bundler-audit check /spike --update` scanned the isolated lockfile against `ruby-advisory-db` commit `305f8b079a23bf95d00c881842f366bb8db19f35` (1,359 advisories, last updated 2026-11-13) and reported `No vulnerabilities found`. This is point-in-time advisory evidence, not proof of cryptographic safety or future maintenance.

## 6. Docker and macOS implications

For the Docker image, the source build succeeded on aarch64 Bookworm and produced an ELF object linked only to glibc. A controlled multi-stage image should compile and test the native object, retain the exact architecture-specific `ffi` package and runtime libc, and exclude compilers/source from the final image where feasible. Rebuilding is required per target architecture; this spike did not execute x86_64 Linux or musl.

The host experiment demonstrated source build and runtime behavior on Ruby 3.4.12 `arm64-darwin25`. The precompiled `ffi` dependency supported arm64 Darwin, while `argon2` itself built its native wrapper from source. This supports the optional native developer workflow on the tested host only; it is not evidence for Intel macOS, older macOS, or other compiler/Ruby combinations.

## 7. Limitations, unresolved risks, and recommendation

Open questions after the executed spike:

- x86_64 Linux, musl, and any deployment image not identical to the tested aarch64 Bookworm image;
- Rails process boot/fork/thread interaction with the candidate and full application dependency resolution;
- known-answer vectors and a malformed/oversized encoded-hash corpus beyond the four tested cases;
- dependency/advisory response and upgrade procedure;
- benchmarked latency, memory, concurrent throughput, saturation, and admission limits;
- explicit canonical-to-library parameter conversion and minimum/maximum enforcement;
- release pinning and protection from future default-profile changes;
- whether `argon2` remains preferable to the separately maintained `argon2id` candidate after equivalent maintenance, API, and capacity comparison.

**Recommendation:** proceed to a separately authorized capacity-validation phase using `argon2` 2.3.3 as one candidate. Compatibility is demonstrated for the exact aarch64 Linux Docker runtime and the tested macOS arm64 host, but production selection remains blocked on the complete benchmark protocol, full Rails/dependency integration in an isolated branch or fixture, broader vector/error testing, release/upgrade policy, and explicit Owner review. The alternative `argon2id` gem should be considered if its platform-native packaging and clearer KiB API materially reduce operational/unit-conversion risk; it was researched but not installed or tested in this spike.

## 8. Status discipline

- AF-OWNER-001 FIND-001 and FIND-005 remain `OPEN`.
- All other AF-OWNER-001 findings remain unchanged and open.
- No residual risk is accepted.
- Independent verification and legal review remain `NOT_PERFORMED`.
- ADR-0006 remains Proposed.
- Milestone 2B remains unauthorized.
