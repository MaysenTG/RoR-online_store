/* On search input change, make a get request to the search endpoint */
console.log("TURBO LINKS ARE  YOU LOADING???");

document.addEventListener("DOMContentLoaded", function () {
  console.log("DOM loaded");
  document.querySelector("#modal-container").innerHTML = `
    <div class="modal fade" id="exampleModal" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title">Search</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
      </div>
      <div class="modal-body">
        <input class="form-control form-control w-100 rounded-2 border" type="text" placeholder="Search" aria-label="Search">
      </div>
      <div class="modal-body">
        <div hidden id="search-loading-spinner" class="spinner-border text-primary text-align-center" role="status">
          <span class="visually-hidden">Loading...</span>
        </div>
        <div id="products-results">
        </div>
        <div id="categories-results">
        </div>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
      </div>
    </div>
  </div>
  </div>`;

  document.querySelector("input").addEventListener("input", function () {
    document.getElementById("search-loading-spinner").hidden = false;
    var url = "/admin/search?search=" + document.querySelector("input").value;
    var xhr = new XMLHttpRequest();
    xhr.open("GET", url, true);
    xhr.onload = function () {
      if (xhr.status == 200) {
        var response = JSON.parse(xhr.responseText);
        let html = "";
        let cat_html = "";
        if (response["data"]["products"] != null) {
          response["data"]["products"].forEach(function (product) {
            html += `
  <a href="/admin/products/${product["id"]}/edit" class="list-group-item list-group-item-action" aria-current="true"><svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="feather feather-file align-text-bottom" aria-hidden="true"><path d="M13 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V9z"></path><polyline points="13 2 13 9 20 9"></polyline></svg> ${product["title"]} - ${product["price"]}</a>
  `;
            document.getElementById(
              "products-results"
            ).innerHTML = `<div class="container"><h5>Products</h5><div class="list-group">${html}</div></div>`;
          });
        } else {
          document.getElementById(
            "products-results"
          ).innerHTML = `<div class="container"><h5>Products</h5><div class="list-group">No results</div></div>`;
        }

        if (response["data"]["categories"] != null) {
          response["data"]["categories"].forEach(function (category) {
            cat_html += `<a href="/admin/categories/${category["id"]}/edit" class="list-group-item list-group-item-action" aria-current="true"><svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="feather feather-shopping-cart align-text-bottom" aria-hidden="true"><circle cx="9" cy="21" r="1"></circle><circle cx="20" cy="21" r="1"></circle><path d="M1 1h4l2.68 13.39a2 2 0 0 0 2 1.61h9.72a2 2 0 0 0 2-1.61L23 6H6"></path></svg> ${category["category"]}</a>`;
            document.getElementById(
              "categories-results"
            ).innerHTML = `<div class="container mt-3"><h5>Categories</h5><div class="list-group">${cat_html}</div></div>`;
          });
        } else {
          document.getElementById(
            "categories-results"
          ).innerHTML = `<div class="container mt-3"><h5>Categories</h5><div class="list-group">No results</div></div>`;
        }
      }
    };
    xhr.send();
    document.getElementById("search-loading-spinner").hidden = true;
  });
});
