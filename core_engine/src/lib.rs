pub mod tokenizer;
pub mod orp;
pub mod pacing;
pub mod engine;

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn pipeline_basic() {
        let e = engine::Engine::new();
        let out = e.process("Lumentum okuma hızını artırır");
        assert!(!out.is_empty());
    }
}
