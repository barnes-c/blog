// Fills the view-count placeholders from GoatCounter's public counter.
(function () {
  var host = document.currentScript.dataset.host;
  document.querySelectorAll("[data-views-path]").forEach(function (node) {
    // A page with no recorded views is a 404 with a count of "0".
    fetch(host + "/counter/" + encodeURIComponent(node.dataset.viewsPath) + ".json")
      .then(function (r) {
        return r.json();
      })
      .then(function (data) {
        node.textContent = data.count;
        node.className = "";
      })
      .catch(function () {
        node.parentElement.hidden = true;
      });
  });
})();
