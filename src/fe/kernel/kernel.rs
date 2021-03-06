// Copyright 2013 (c) Michael Williams, All rights reserved.
// The following code is licensed under the terms specified in LICENSE.md.

#[link(name = "iron",
       vers = "0.0.1",
       uuid = "e9266598-29a2-11e3-8162-49991300734c",
       url = "https://github.com/mtwilliams/iron")];

#[comment = "A microkernel built with Rust."];
#[license = "BSD"];

#[allow(ctypes)];
#[no_std];
#[no_core];

#[path = "../../../vendor/rust-core/core/mod.rs"]
mod core;

pub mod main;
