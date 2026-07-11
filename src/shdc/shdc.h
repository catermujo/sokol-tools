#pragma once
#include "args.h"

namespace shdc {

struct Shdc {
    void init();
    void deinit();
    // note: returns exit code (e.g. 0 is success)
    int run(const Args& argc);
};

} // namespace shdc
