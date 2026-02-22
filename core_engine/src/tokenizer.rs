pub fn tokenize(text: &str) -> Vec<String> {
    // Basic whitespace split but keeping Unicode in mind
    // In a more advanced version, we could use regex or a specialized library
    text.split_whitespace()
        .map(|s| s.to_string())
        .collect()
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_tokenize_basic() {
        let tokens = tokenize("Lumentum hızı artırır.");
        assert_eq!(tokens, vec!["Lumentum", "hızı", "artırır."]);
    }

    #[test]
    fn test_tokenize_unicode() {
        let tokens = tokenize("Göz yorgunluğu azalır 👁️");
        assert_eq!(tokens, vec!["Göz", "yorgunluğu", "azalır", "👁️"]);
    }
}
