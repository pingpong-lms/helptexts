var Page = (function() {

	var pageForm = document.querySelector(".page-form");
	pageForm.addEventListener("submit", pageSave, false);

	var btnNewSubPage = pageForm.querySelector(".new-sub-page");


	function loadPage(pageId) {
		var page = pages[pageId];

		if(!page) {
			console.warn("Sidan med id: '" + pageId + "' finns inte");
			Nav.goto("/");
			return;
		}

		pageForm.elements.pageId.value = pageId;
		pageForm.elements.newPageId.value = pageId;
		updateParentPageSelect(page.parentPageId);
		pageForm.elements.giverprop.value = page.giverprop;

		pageForm.elements.isFolder.checked = page.isFolder;
		pageForm.elements.underDevelopment.checked = page.underDevelopment;

		pageForm.elements.studentTopic.checked = page.studentTopic;
		pageForm.elements.teacherTopic.checked = page.teacherTopic;
		pageForm.elements.adminTopic.checked = page.adminTopic;

		btnNewSubPage.dataset.parentId = pageId;
	}


	function newPage() {
		pageForm.elements.pageId.value = "";
		pageForm.reset();
		updateParentPageSelect();
		pageForm.elements.newPageId.focus();
	}



	function pageSave(e) {
		e.preventDefault();
		
		var form = e.target;
		var formData = new FormData(form);

		var xhr = new XMLHttpRequest();
		xhr.addEventListener("load", pageSaved);
		xhr.responseType = "json";
		xhr.open("POST", "/api/page.php");
		xhr.send(formData);
	}


	function pageSaved(e) {
		if(e.target.status === 201 || e.target.status === 200) {
			var pageId = e.target.response.pageId;
			console.log("page saved", pageId);
			getAllPages(function() {
				Nav.goto("/page/" + pageId);
			});
		}
	}

	function updateParentPageSelect(selectedPageId) {
		var select = pageForm.elements.parentPageId;
		select.innerHTML = "<option></option>";
		//if(!pages['root']) return;
		pages['root'].children.forEach(function(pageId) {
			printOption(pageId, 0);
		});
		
		function printOption(pageId, level) {
			var page = pages[pageId];
			if(!page.isFolder || page.underDevelopment) return;
			var option = document.createElement("option");
			option.value = pageId;
			option.innerHTML = "&nbsp;".repeat(level*3) + page.titleSV;
			if(pageId===selectedPageId) {
				option.selected = "selected";
			}
			select.appendChild(option);
			if(page.children) {
				for(var i=0; i<page.children.length; i++) {
					printOption(page.children[i], level+1);
				}
			}

		}
	}

	function hidePage() {
		pageForm.style.display = "none";
	}

	function showPage() {
		pageForm.style.display = "";
	}

	return {
		hide: hidePage,
		show: showPage,
		new: newPage,
		load: loadPage,
		updateParentPageSelect: updateParentPageSelect
	}
}());