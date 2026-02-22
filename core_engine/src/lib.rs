pub mod tokenizer;
pub mod orp;
pub mod pacing;
pub mod engine;
pub mod parser;

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn pipeline_basic() {
        let e = engine::Engine::new();
        let out = e.process("Lumentum okuma hızını artırır");
        assert!(!out.is_empty());
        assert_eq!(out[0].token, "Lumentum");
        assert!(out[0].pace_ms > 0);
    }

    #[test]
    fn parser_skeleton() {
        let txt = parser::parse("hello", parser::ContentType::Txt);
        assert_eq!(txt, "hello");
        let pdf = parser::parse("...", parser::ContentType::Pdf);
        assert!(pdf.contains("PDF"));
    }
}
