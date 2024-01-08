/// runtime typeinfo
struct type_t {
private:
    size_t _size;
    string _ts;
public:
    size_t sizeof_() {
        return _size;
    }
}

/// creates runtime typeinfo
auto t(T)() {
    enum tis = T.mangleof;
    return type_t(T.sizeof, tis);
}

/// turns runtime typeinfo available at CTFE into a proper type
template r(type_t xt) {
    mixin("alias r = __traits(toType, `" ~ xt._ts ~"`);");
}

/*template r(type_t[] xts) {
    import std.algorithm;
    import std.array;
    import std.meta;
    mixin("alias r = AliasSeq!(" ~ xts.map!(t=>t._ts).array.join(",") ~");");
}*/

// use normal functions for type logic instead of template magic (basically a CTFE equivalant for type logic)
auto greater(type_t a, type_t b) {
    return a.sizeof_ > b.sizeof_ ? a : b;
}

struct Foo {
    struct Bar {
    }
}
void main() {
    enum XT = t!(Foo.Bar);
    alias T = r!(XT);
    pragma(msg, T);

    alias ST = r!(greater(t!short, t!int));
    pragma(msg, ST);
}
