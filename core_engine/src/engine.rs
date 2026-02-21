use crate::{orp, pacing, tokenizer};

pub struct Engine;

impl Engine {
    pub fn new() -> Self {
        Self
    }

    pub fn process(&self, text: &str) -> String {
        let tokens = tokenizer::tokenize(text);
        let mut out = Vec::new();
        for t in tokens {
            let idx = orp::focus_index(&t);
            let ms = pacing::pace_ms(&t);
            out.push(format!("{}|{}|{}", t, idx, ms));
        }
        out.join(" ")
    }
}
