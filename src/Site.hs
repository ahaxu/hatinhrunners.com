{-# LANGUAGE OverloadedStrings #-}

import           Data.Monoid
import           Hakyll
import           Sitemap


config :: Configuration
config = defaultConfiguration
    { destinationDirectory = "docs"
    }

sitemapConfig :: SitemapConfiguration
sitemapConfig = def {
    sitemapBase     = "https://hatinhrunners.com/"
}

main :: IO ()
main = hakyllWith config $ do
    match "images/*" $ do
        route   idRoute
        compile copyFileCompiler

    match "pdfs/*" $ do
        route   idRoute
        compile copyFileCompiler

    match "css/*" $ do
        route   idRoute
        compile compressCssCompiler

    match (fromList ["about.markdown"]) $ do
        route   $ setExtension "html"
        compile $ pandocCompiler
            >>= loadAndApplyTemplate "templates/default.html" defaultContext
            >>= relativizeUrls

    -- build up tags
    tags <- buildTags "posts/*" (fromCapture "tags/*.html")
    tagsRules tags $ \tag pattern -> do
      let title = "Bài viết cùng tag: \"" <> tag <> "\""
      route idRoute
      compile $ do
          posts <- recentFirst =<< loadAll pattern
          let ctx =
                constField "title" title <>
                listField "posts" postCtx (return posts) <>
                defaultContext

          makeItem ""
              >>= loadAndApplyTemplate "templates/tag.html" ctx
              >>= loadAndApplyTemplate "templates/default.html" ctx
              >>= relativizeUrls

    match "posts/*" $ do
        route $ setExtension "html"
        compile $ pandocCompiler
            >>= loadAndApplyTemplate "templates/post.html"    (postCtxWithTags tags)
            >>= loadAndApplyTemplate "templates/default.html" (postCtxWithTags tags)
            >>= relativizeUrls

    create ["archive.html"] $ do
        route idRoute
        compile $ do
            posts <- recentFirst =<< loadAll "posts/*"
            let archiveCtx =
                    listField "posts" postCtx (return posts) <>
                    constField "title" "Archives"            <>
                    defaultContext

            makeItem ""
                >>= loadAndApplyTemplate "templates/archive.html" archiveCtx
                >>= loadAndApplyTemplate "templates/default.html" archiveCtx
                >>= relativizeUrls

    -- gen sitemap.xml
    create ["sitemap.xml"] $ do
        route   idRoute
        compile $ generateSitemap sitemapConfig

    -- index.html
    match "index.html" $ do
        route idRoute
        compile $ do
            posts <- fmap (take 10) . recentFirst =<< loadAll "posts/*"
            let indexCtx =
                    listField "posts" postCtx (return posts) <>
                    constField "title" "Home"                <>
                    defaultContext

            getResourceBody
                >>= applyAsTemplate indexCtx
                >>= loadAndApplyTemplate "templates/default.html" indexCtx
                >>= relativizeUrls

    match "templates/*" $ compile templateCompiler

    mapM_ static ["humans.txt", "robots.txt"]


postCtx :: Context String
postCtx =
    dateField "date" "%B %e, %Y" <>
    defaultContext

postCtxWithTags :: Tags -> Context String
postCtxWithTags tags = tagsField "tags" tags <> postCtx

static :: Pattern -> Rules ()
static f = match f $ do
    route   idRoute
    compile copyFileCompiler

directory :: (Pattern -> Rules a) -> String -> Rules a
directory act f = act $ fromGlob $ f ++ "/**"

