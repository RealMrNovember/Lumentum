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
        let total = tokens.len();

        for (i, t) in tokens.iter().enumerate() {
            let idx = orp::focus_index(t);
            let is_last = i == total - 1 || t.ends_with('.') || t.ends_with('!') || t.ends_with('?');
            let ms = pacing::pace_ms(t, is_last);

            out.push(TokenData {
                token: t.clone(),
                focus_index: idx,
                pace_ms: ms,
            });
        }
        out
    }
}
