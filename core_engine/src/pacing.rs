pub fn pace_ms(word: &str, is_last_in_sentence: bool) -> u64 {
    let mut base = 250u64; // Base for average word at 240 WPM is ~250ms

    if is_conjunction(word) {
        base = 150;
    } else if word.len() > 10 {
        base = 400;
    } else if word.len() > 7 {
        base = 320;
    }

    // Punctuation pause
    if word.ends_with('.') || word.ends_with('!') || word.ends_with('?') {
        base += 300;
    } else if word.ends_with(',') || word.ends_with(';') || word.ends_with(':') {
        base += 150;
    }

    if is_last_in_sentence {
        base += 100;
    }

    base
}

fn is_conjunction(word: &str) -> bool {
    let w = word.to_lowercase();
    let w = w.trim_matches(|c: char| c.is_ascii_punctuation());
    matches!(w, "ve" | "ama" | "çünkü" | "fakat" | "veya" | "ile" | "ki" | "da" | "de")
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_pace_ms() {
        assert!(pace_ms("ve", false) < pace_ms("normal", false));
        assert!(pace_ms("bitiş.", true) > pace_ms("bitiş", false));
    }
}
