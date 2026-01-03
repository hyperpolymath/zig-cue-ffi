// SPDX-License-Identifier: AGPL-3.0-or-later
//! Zig FFI bindings for CUE configuration language
//! Inspired by: hyperpolymath/conflow

const std = @import("std");

pub const Error = error{
    ParseFailed,
    ValidationFailed,
    AllocationFailed,
};

/// CUE value types
pub const ValueKind = enum {
    null_kind,
    bool_kind,
    int_kind,
    float_kind,
    string_kind,
    bytes_kind,
    struct_kind,
    list_kind,
};

/// Parsed CUE document
pub const Document = struct {
    allocator: std.mem.Allocator,
    source: []const u8,

    pub fn parse(allocator: std.mem.Allocator, source: []const u8) Error!Document {
        // TODO: Link to libcue when available
        return Document{
            .allocator = allocator,
            .source = allocator.dupe(u8, source) catch return Error.AllocationFailed,
        };
    }

    pub fn deinit(self: *Document) void {
        self.allocator.free(self.source);
    }

    pub fn validate(self: *Document) Error!bool {
        _ = self;
        // TODO: Implement validation
        return true;
    }
};

// C FFI exports
var global_allocator: std.mem.Allocator = std.heap.c_allocator;

export fn cue_parse(source: [*:0]const u8) ?*Document {
    const doc = Document.parse(global_allocator, std.mem.span(source)) catch return null;
    const ptr = global_allocator.create(Document) catch return null;
    ptr.* = doc;
    return ptr;
}

export fn cue_validate(doc: *Document) bool {
    return doc.validate() catch false;
}

export fn cue_free(doc: *Document) void {
    doc.deinit();
    global_allocator.destroy(doc);
}

test "Document.parse" {
    var doc = try Document.parse(std.testing.allocator, "foo: 123");
    defer doc.deinit();
    try std.testing.expect(try doc.validate());
}
