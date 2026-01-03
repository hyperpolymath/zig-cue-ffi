# Provenance

## Inspired By

**Repository**: [hyperpolymath/conflow](https://github.com/hyperpolymath/conflow)

## Challenge

conflow uses subprocess calls to the CUE CLI for configuration validation.

## Solution

This Zig FFI library provides direct bindings to libcue, enabling configuration validation without subprocess calls.

## How It Helps

| Before (subprocess) | After (FFI) |
|---------------------|-------------|
| ~50ms per cue call | ~2ms per libcue call |
| Text parsing required | Native struct access |
| Process spawn overhead | Single library load |
