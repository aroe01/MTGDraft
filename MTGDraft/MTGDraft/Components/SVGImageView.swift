//
//  SVGImageView.swift
//  MTGDraft
//
//  Created by Adrian Roe on 2/28/26.
//

import SwiftUI
import WebKit

/// Renders a remote SVG URL using WKWebView.
/// Use this anywhere AsyncImage would be used if the source is an SVG.
struct SVGImageView: UIViewRepresentable {
    let url: URL

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.isOpaque = false
        webView.backgroundColor = .clear
        webView.scrollView.isScrollEnabled = false
        webView.scrollView.backgroundColor = .clear
        return webView
    }

    func updateUIView(_ webView: WKWebView, context: Context) {
        let html = """
        <html>
        <head>
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <style>
        * { margin: 0; padding: 0; }
        html, body { width: 100%; height: 100%; background: transparent; }
        img { width: 100%; height: 100%; object-fit: contain; }
        </style>
        </head>
        <body><img src="\(url.absoluteString)" /></body>
        </html>
        """
        webView.loadHTMLString(html, baseURL: URL(string: "https://svgs.scryfall.io"))
    }
}
