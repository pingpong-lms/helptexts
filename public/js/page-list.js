var PageList = (function() {
	var pageContainer = document.querySelector(".help-pages");
	var selectedId;

	getAllPages(function() {
		Nav.init(onStateChange);
	});


	pageContainer.addEventListener("click", function(e) {
		if(e.target.classList.contains("page-title")) {
			Nav.goto("/page/" + e.target.parentElement.dataset.pageId);
		}
	});

	function selectPageInMenu(pageId) {
		var selected = pageContainer.querySelector(".selected");
		if(selected) selected.classList.remove("selected");

		selectedId = pageId;
		var menuItem = pageContainer.querySelector("[data-page-id='"+pageId+"']");
		if(menuItem) {
			menuItem.classList.add("selected");

			var elem = menuItem;
			while(elem != pageContainer) {
				if(elem.classList.contains("page-children")) {
					elem.classList.add("open");
					elem.parentElement.querySelector(".icon").classList.add("open");
				}
				elem = elem.parentElement;
			}
		}

	}

	function updateList() {
		if(!pages['root']) return;
		var rootChildren = pages['root'].children;
		var fragment = document.createDocumentFragment();

		rootChildren.forEach(function(pageId) {
			fragment.appendChild(printPageItem(pageId));
		});
		pageContainer.innerHTML = "";
		pageContainer.appendChild(fragment);

		if(selectedId) selectPageInMenu(selectedId);
	}

	function printPageItem(pageId) {
		var page = pages[pageId],
			div = document.createElement("div"),
			info = document.createElement("div"),
			icon = document.createElement("div"),
			title = document.createElement("span");

		div.className = "page-item";

		info.className = "page-info";
		info.dataset.pageId = pageId;

		title.className = "page-title";
		title.textContent = page.titleSV || "inget namn";

		if(page.children) {
			icon.innerHTML = "&#9656;";
			icon.className = "icon folder";
		} else {
			icon.innerHTML = "&#9679;";
			icon.className = "icon leaf";
		}

		info.appendChild(icon);
		info.appendChild(title);
		div.appendChild(info);

		if(page.children) {
			var childContainer = document.createElement("div");

			icon.addEventListener("click", function(e) {
				if(icon.classList.contains("open")) {
					icon.classList.remove("open");
					childContainer.classList.remove("open");
				} else {
					icon.classList.add("open");
					childContainer.classList.add("open");
				}
			})

			childContainer.className = "page-children";
			page.children.forEach(function(pageId) {
				childContainer.appendChild(printPageItem(pageId));
			});
			div.appendChild(childContainer)
		}
		return div;
	}


	return {
		update: updateList,
		select: selectPageInMenu
	}
}())