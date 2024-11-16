# 00000 - Use Deno

## Abstract

Deno is a JavaScript and TypeScript runtime focused on ease of use and security. Since this CLI has access to your file system, we appreciate the security prompts from Deno, as well as the ease of development, so we've decided to build this in Deno.

## Context and Problem Statement

Architecture decision records (ADRs) are important, but are often not maintained or written at all. When they are, they are often decoupled from the codebase, which is an unnecessary point of friction. We should build a tool to help manage ADRs. This tool will have access to the file system and should attempt to be as secure as possible, too.

## Considered Options
- Dart
- Deno
- Rust
- Zig
- C++

## Decision Outcome

Use Deno for development at this point in time.

<!-- Add additional information here, comparison of options, research, etc -->

### Dart

Dart was my original first choice, but the executable was bigger than I preferred (Deno also has this problem), and has less community adoption than JS/TS, and no extra security mechanisms.

### Deno

Deno is easy to use, produces a multiplatform binary, and has an emphasis on security. Deno is rapidly evolving and my assumption is that it will have a strong future in the JS ecosystem.

### Rust

Rust is an excellent choice for this, to be honest, but in the spirit of moving fast (at least for a prototype), Rust is never my language of choice. There may be a potential rewrite at some point in the future using Rust.

### Zig

Zig is also an excellent choice for this, but given Zig does not have a stable version and lack of quality of life features and tooling, the choice is, at this time, to not use Zig.

### C++

C++ was also evaluated, but I haven't written C++ in 10+ years and while it'd be fun to get back into it, this is a program that I need now and not something after 2+ weeks of relearning C++.

#### Notes

If you're reading this as an example of what an ADR can be, please know that they are generally more factual and less whim-driven than this :)
