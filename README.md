# googletagmanager_finder
R code to check website pages for the presence of Google Tag Manager (GTM) in the &lt;head> tag

I wrote this code to check for pages on a website that are missing GTM. You tell it the sitemap and it will go through all links and look for GTM in the <head> tag. If a page is not found
it will also tell you that.

The code is not super fast, but takes about 5-10 min to run 2,000 pages. So for most sites, it will work well.
