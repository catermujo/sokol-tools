/*
    sokol-shdc main source file.
*/
#include "shdc.h"

using namespace shdc;

int main(int argc, const char** argv) {
    Shdc shdc;
    shdc.init();
    const Args args = Args::parse(argc, argv);
    if (args.debug_dump) {
        args.dump_debug();
    }
    if (!args.valid) {
        return args.exit_code;
    }
    int exit_code = shdc.run(args);
    shdc.deinit();
    return exit_code;
}
