//
//  HTMLInjection.swift
//  Kami
//
//  Created by Jon Alaniz on 12/22/24.
//

import Foundation

enum HTMLInjection {
    case customCSS
    case customJS
    case metaTag
    case testHTML

    func string() -> String {
        switch self {
        case .customCSS:
            return
                """
                <style>
                    body {
                        font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", Arial, sans-serif;
                        margin: 10;
                        padding: 10;
                        font-size: 16px;
                        color: #333;
                        background-color: #fff;
                    }
                    p, ul, ol, li {
                        margin: 0;
                        padding: 0 10px;
                        line-height: 1.5;
                    }
                    h2, h3 {
                        margin: 10px 0 5px;
                        padding: 0 10px;
                        font-size: 18px;
                        font-weight: bold;
                    }
                    img {
                        max-width: 100%;
                        height: auto;
                        display: block;
                    }
                    hr {
                        margin: 15px 0;
                        border: none;
                        border-top: 1px solid #ddd;
                    }
                    a {
                        color: #0066cc;
                        text-decoration: none;
                    }
                    a:hover {
                        text-decoration: underline;
                    }
                    /* Media Queries for smaller screens */
                    @media (max-width: 600px) {
                        body {
                            padding: 10px;
                        }
                        table {
                            width: 100% !important;
                            max-width: 100% !important;
                            box-sizing: border-box;
                        }
                        td {
                            width: 100% !important;
                            padding: 5px !important;
                        }
                    }
                </style>
                """
        case .customJS:
            return
                """
                (function() {
                    var body = document.body;
                    var html = document.documentElement;
                    return Math.min(body.offsetHeight, body.scrollHeight, html.offsetHeight, html.scrollHeight);
                })();
                """
        case .metaTag:
            return
                """
                <meta name='viewport' content='width=device-width, initial-scale=1, shrink-to-fit=yes'>
                """
        case .testHTML:
            return
                """
                <html>
                <body>
                    <p>This is a simple test paragraph.</p>
                    <img src="https://via.placeholder.com/300" alt="Test image">
                </body>
                </html>
                """
        }
    }
}
