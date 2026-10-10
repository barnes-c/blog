// Loaded as a file rather than Remark42's inline snippet, so the CSP needs no 'unsafe-inline'.
(function () {
  var root = document.getElementById("remark42");
  var html = document.documentElement;
  var theme = function () {
    return html.classList.contains("dark") ? "dark" : "light";
  };

  window.remark_config = {
    host: root.dataset.host,
    site_id: root.dataset.siteId,
    url: root.dataset.url,
    theme: theme(),
    components: ["embed"],
  };

  var script = document.createElement("script");
  script.type = "module";
  script.src = root.dataset.host + "/web/embed.mjs";
  document.head.appendChild(script);

  // Follow Blowfish's appearance switcher, which toggles the "dark" class on <html>.
  new MutationObserver(function () {
    if (window.REMARK42 && window.REMARK42.changeTheme) {
      window.REMARK42.changeTheme(theme());
    }
  }).observe(html, { attributes: true, attributeFilter: ["class"] });
})();
