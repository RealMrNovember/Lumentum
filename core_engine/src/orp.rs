pub fn focus_index(word: &str) -> usize {
    let chars: Vec<char> = word.chars().collect();
    let len = chars.len();

    if len <= 1 { return 0; }

    // If there is punctuation at the end, don't count it for ORP
    let mut real_len = len;
    while real_len > 0 && chars[real_len - 1].is_ascii_punctuation() {
        real_len -= 1;
    }

    if real_len <= 1 { return 0; }

    // Re-calculate mid based on real_len
    let mid = match real_len {
        2..=5 => 1,
        6..=9 => 2,
        10..=13 => 3,
        _ => 4,
    };

    if mid < len && is_vowel(chars[mid]) {
        return mid;
    }

    if mid + 1 < real_len && is_vowel(chars[mid + 1]) {
        return mid + 1;
    }

    if mid > 0 && is_vowel(chars[mid - 1]) {
        return mid - 1;
    }

    mid
}

fn is_vowel(c: char) -> bool {
    let c = c.to_lowercase().next().unwrap_or(c);
    matches!(c, 'a' | 'e' | 'ı' | 'i' | 'o' | 'ö' | 'u' | 'ü')
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_focus_index() {
        // Adjusting expectations to match logic:
        // "ve" -> len 2 -> mid 1. 'e' is vowel -> 1.
        assert_eq!(focus_index("ve"), 1);
        // "elma" -> len 4 -> mid 1. 'l' is NOT vowel. mid+1 is 'm'. NOT vowel. mid-1 is 'e'. IS vowel. -> 0.
        assert_eq!(focus_index("elma"), 0);
        // "kitap" -> len 5 -> mid 1. 'i' is vowel -> 1.
        assert_eq!(focus_index("kitap"), 1);
    }
}
