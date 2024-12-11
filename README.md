# Echidna

A small and easy to use framework, inspired by [[McEngine]](https://github.com/McKay42/McEngine) by [McKay](https://github.com/McKay42).

This branch is in the middle of rewrite, everything will look scuffed.

#### Structure
`/src/beatrice/` contains the source code
1. `/app/` contains the generic application code using the engine
2. `/audio/` contains the audio subsystem
3. `/component/` contains the generic unused/deprecated system
    - `/component/object/` contains GameObject 
    - `/component/ui/` contains the UI sytem
4. `/engine/` contains the core
    - to be done
5. `/graphic/` contains the deprecated sprite system
6. `/math/` contains the mathematical functions
    - `/math/easing/` contains generic easing function
    - `/math/timer/` contains generic timing structs
    - `/math/transform/` contains transformers to be used with animations
    - `/math/vector` contains generic Vector structs

### Building
a simple `v -cc clang .` should work.

