# Echidna

A small and easy to use framework, inspired by [[McEngine]](https://github.com/McKay42/McEngine) by [McKay](https://github.com/McKay42).

This engine is mostly for quick prototyping, no optimization has been done yet.

Not all graphic/os specific functions are implemented, it will be added only when I needed it.

#### Structure
`/src/beatrice/` contains the source code
1. `/app/` contains the generic application code using the engine
2. `/engine/` contains the core
    - `/font/` contains the font system
    - `/input/` contains input devices
    - `/platform/` contains platform wrappers
    - `/renderer/` contains renderer specific code
3. `/drawable/` contains basic drawable structs
    - `/common/` contains generic 2d object
    - `/sprite/` contains osu!-esque sprite struct and manager
    - `/ui/` contains deprecated ui system, do not use.
4. `/util/` contains the helper one-use functions/structs
    - `/math/easing/` contains generic easing function
    - `/math/timer/` contains generic timing structs
    - `/math/transform/` contains transformers to be used with animations
    - `/math/vector` contains generic Vector structs

#### Demos

https://github.com/xjunko/kyu-kurarin

![image](https://github.com/user-attachments/assets/3aba9954-5792-4681-81ba-afc37e3338bd)

## Building
- A simple `v -cc clang .` should work.

