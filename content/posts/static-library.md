---
title: "Static Library"
date: 2020-11-22T15:09:25-08:00
---

Here, the `export` keyword is used to signify that the `add` function will be available post-compilation in a C ABI compatible way.

Additionally, we see `test` blocks being used to ensure that our function behaves correctly. These blocks are ran when using `zig test`.

## src/main.zig
```zig
const std = @import("std");
const testing = std.testing;

export fn add(a: i32, b: i32) i32 {
    return a + b;
}

test "basic add functionality" {
    testing.expect(add(3, 7) == 10);
}
```

## build.zig
```zig
const Builder = @import("std").build.Builder;

pub fn build(b: *Builder) void {
    const mode = b.standardReleaseOptions();
    const lib = b.addStaticLibrary("ziglaunch", "src/main.zig");
    lib.setBuildMode(mode);
    lib.install();

    var main_tests = b.addTest("src/main.zig");
    main_tests.setBuildMode(mode);

    const test_step = b.step("test", "Run library tests");
    test_step.dependOn(&main_tests.step);
}
```
