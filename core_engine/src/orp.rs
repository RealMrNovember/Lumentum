pub fn focus_index(word: &str) -> usize {
    let len = word.chars().count();
    if len <= 1 {
        0
    } else if len <= 4 {
        1
    } else if len <= 8 {
        2
    } else if len <= 12 {
        3
    } else {
        4
    }
}
