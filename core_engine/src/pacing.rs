fn is_conjunction(word: &str) -> bool {
    matches!(word.to_lowercase().as_str(), "ve" | "ama" | "çünkü")
}

pub fn pace_ms(word: &str) -> u64 {
    if is_conjunction(word) {
        return 20;
    }
    let len = word.chars().count();
    let mut base = 40u64;
    if len > 10 {
        base += 60;
    } else if len > 6 {
        base += 30;
    }
    if word.contains('-') || word.chars().any(|c| c.is_uppercase()) {
        base += 20;
    }
    base
}
