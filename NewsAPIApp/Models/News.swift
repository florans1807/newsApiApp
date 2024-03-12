//
//  News.swift
//  NbaNetworkingApp
//
//  Created by Флоранс on 19.02.2024.
//

struct News: Decodable {
    let status: String
    let totalResults: Int
    let articles: [Article]
}

struct Article: Decodable {
    let source: Source?
    let author: String
    let title: String
    let description: String?
    let url: String
    let urlToImage: String?
    let publishedAt: String
    let content: String
    
    var descriptionInfo: String {
        """
        \(title)
        \n
        \(content)
        \n
        Was published at: \(publishedAt) by \(author)
        """
    }
    
    init(articleData: [String: Any]) {
        source = articleData["source"] as? Source
        author = articleData["author"] as? String ?? ""
        title = articleData["title"] as? String ?? ""
        description = articleData["description"] as? String
        url = articleData["url"] as? String ?? ""
        urlToImage = articleData["urlToImage"] as? String
        publishedAt = articleData["publishedAt"] as? String ?? ""
        content = articleData["content"] as? String ?? ""
    }
    
    static func getArticles(from value: Any) -> [Article] {
        guard let articleData = value as? [String: Any] else {
            return []
        }
        
        guard let articleList = articleData["articles"] as? [[String: Any]] else {
            return []
        }
        
        return articleList.map { Article(articleData: $0) }
    }
}

struct Source: Decodable {
    let id: String
    let name: String
    let description: String?
    let url: String?
    let category: String?
    let language: String?
    
    init(sourceData: [String: String]) {
        id = sourceData["id"] ?? ""
        name = sourceData["name"] ?? ""
        description = sourceData["description"]
        url = sourceData["url"]
        category = sourceData["category"]
        language = sourceData["language"]
    }
    
    static func getSources(from value: Any) -> [Source] {
        guard let sourceData = value as? [String: Any] else {
            return []
        }
        
        guard let sourceList = sourceData["sources"] as? [[String: String]] else {
            return []
        }
        
        return sourceList.map { Source(sourceData: $0) }
    }
}
