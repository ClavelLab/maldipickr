<!-- Matomo -->
var _paq = window._paq = window._paq || [];
/* tracker methods like "setCustomDimension" should be called before "trackPageView" */
_paq.push(["setDocumentTitle", document.domain + "/" + document.title]);
_paq.push(['trackPageView']);
_paq.push(['enableLinkTracking']);
(function() {
var u="https://piwik.cebitec.uni-bielefeld.de/";
_paq.push(['setTrackerUrl', u+'matomo.php']);
_paq.push(['setSiteId', '24']);
var d=document, g=d.createElement('script'), s=d.getElementsByTagName('script')[0];
g.async=true; g.src=u+'matomo.js'; s.parentNode.insertBefore(g,s);
})();
<!-- End Matomo Code -->
