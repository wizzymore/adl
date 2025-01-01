# 00002 - Migrate to Zig

## Abstract

The filesize of the Deno cli was starting to really bother me, so I decided to pursue rewriting this in Zig to reduce the filesize (and learn some more zig!).

## Context and Problem Statement

While Deno provided a lot to the CLI, it was effectively making the CLI a minimum of 50mb, which just feels excessive for what this project sets out to do. Originally, I evaluated other options and settled on Deno and while I don't think Deno is a _bad_ choice, I do believe it was the _wrong_ choice given my personal constraints imposed upon this project (specifically, filesize).

## Considered Options

- Rewrite in Zig
- Rewrite in Rust
- Rewrite in C
- Build Deno from source with specific Rust build flags to remove debug symbols and try to shrink the size of the compiled Deno runtime, then use that to build ADL.

## Decision Outcome

Zig is an interest of mine and this felt like a great opportunity to explore Zig more. I started rewriting this as a learning experience, but ultimately found that Zig aligned a bit more with the goals for this project so have decided to move the Zig version into the main branch as the primary implementation.