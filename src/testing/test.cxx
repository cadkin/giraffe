module;

#include <QWidget>

export module giraffe.testing;

import std;
import giraffe.core;

export class Widget : public QWidget {

};

auto main(int argc, char* argv[]) -> int {
    std::println("{}", test_function());

    return 0;
}
