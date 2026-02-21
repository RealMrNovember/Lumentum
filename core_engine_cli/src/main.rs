use lumentum_core::engine::Engine;
use std::env;

fn main() {
    let args: Vec<String> = env::args().collect();
    let text = if args.len() > 1 {
        args[1..].join(" ")
    } else {
        String::new()
    };
    let e = Engine::new();
    let result = e.process(&text);
    println!("{}", result);
}
