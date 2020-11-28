---
title: "Cross Compiled Freestanding Library For Embedded Target"
date: 2020-11-27T19:42:02-08:00
---

In this case we'll be compiling for an nRF52 Development Kit, which contains a Cortex-M4 processor with FPU. We use the freestanding OS tag since we are not using libc on our device. See [the Zig docs](https://ziglang.org/documentation/master/std/#std;Target) for a full list of supported targets

It will output a static library called `ziglaunch.a`. An existing C program compiled with `arm-none-eabi-gcc` can then call these functions by passing `-lziglaunch` to the linker.


## src/main.zig
```zig
const std = @import("std");
const testing = std.testing;
const c = @cImport({
    @cDefine("FLOAT_ABI_HARD", {});
    @cDefine("NRF52840_XXAA", {});
    @cDefine("BOARD_PCA10056", {});
//  use @cInclude to parse C header files for unions, typedefs, structs, etc
//  @cInclude("/path/to/sdk/headers");
});

export fn add(a: i32, b: i32) i32 {
    return a + b;
}

test "basic add functionality" {
    testing.expect(add(3, 7) == 10);
}
```

## build.zig
```zig
const std = @import("std");
const Builder = @import("std").build.Builder;

const target = std.zig.CrossTarget{
    .cpu_arch = .thumb,
    .os_tag = .freestanding,
    .abi = .gnueabihf,
    .cpu_model = std.zig.CrossTarget.CpuModel{ .explicit = &std.Target.arm.cpu.cortex_m4 },
};

pub fn build(b: *Builder) void {
    const mode = b.standardReleaseOptions();
    const lib = b.addStaticLibrary("ziglaunch", "src/main.zig");
    lib.addIncludeDir("/usr/arm-none-eabi/include");
    // Add other include directories here (SDKs etc)

    lib.setTarget(target);
    lib.setBuildMode(mode);
    lib.install();

    var main_tests = b.addTest("src/main.zig");
    main_tests.setBuildMode(mode);

    const test_step = b.step("test", "Run library tests");
    test_step.dependOn(&main_tests.step);
}

```
