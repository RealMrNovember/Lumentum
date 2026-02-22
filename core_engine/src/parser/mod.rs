pub mod txt;
pub mod pdf;
pub mod epub;
pub mod web;

pub enum ContentType {
    Txt,
    Pdf,
    Epub,
    Web,
}

pub fn parse(content: &str, ctype: ContentType) -> String {
    match ctype {
        ContentType::Txt => txt::parse(content),
        ContentType::Pdf => pdf::parse(content),
        ContentType::Epub => epub::parse(content),
        ContentType::Web => web::parse(content),
    }
}
