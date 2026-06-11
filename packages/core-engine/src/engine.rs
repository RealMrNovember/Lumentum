use crate::{orp, pacing, tokenizer};

pub struct TokenData {
    pub token: String,
    pub focus_index: usize,
    pub pace_ms: u64,
}

pub struct Engine;

impl Engine {
    pub fn new() -> Self {
        Self
    }

    pub fn process(&self, text: &str) -> Vec<TokenData> {
        let tokens = tokenizer::tokenize(text);
        let mut out = Vec::new();
        for t in tokens {
            let idx = orp::focus_index(&t);
            let ms = pacing::pace_ms(&t);
            out.push(TokenData {
                token: t,
                focus_index: idx,
                pace_ms: ms,
            });
        }
        out
    }
}
