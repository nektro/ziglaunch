---
title: "Hello World!"
date: 2020-11-22T14:50:08-08:00
---

The classic "Hello World!" program.

## src/main.zig
```zig
const std = @import("std");

pub fn main() anyerror!void {
    std.log.info("Hello World, from Zig!", .{});
}
```

## build.zig
```zig
const std = @import("std");
const Builder = std.build.Builder;

pub fn build(b: *Builder) void {
    const target = b.standardTargetOptions(.{});

    const mode = b.standardReleaseOptions();

    const exe = b.addExecutable("ziglaunch", "src/main.zig");
    exe.setTarget(target);
    exe.setBuildMode(mode);
    exe.install();

    const run_cmd = exe.run();
    run_cmd.step.dependOn(b.getInstallStep());
    if (b.args) |args| {
        run_cmd.addArgs(args);
    }

    const run_step = b.step("run", "Run the app");
    run_step.dependOn(&run_cmd.step);
}
```
