var Content = (function() {
	var editorForm = document.querySelector(".content-form");
	editorForm.addEventListener("submit", contentSave, false);
	var versionSelector = editorForm.elements.version;
	versionSelector.addEventListener("change", versionDropdownChange);


	var editor = tinymce.init({
		selector: '.help-page-content-editor',
		height: 400,
		entity_encoding: "raw",
		invalid_elements: 'h1,h2,h3,h4,h5,h6',
		plugins: 'table searchreplace code contextmenu',
		menubar: false,
		toolbar: "undo redo searchreplace | styleselect table | bold italic underline | alignleft aligncenter alignright alignjustify | bullist numlist outdent indent | link image | code",
		style_formats: [
			{ title: 'Heading 2', block: 'div', classes: 'help-heading2' },
			{ title: 'Heading 3', block: 'div', classes: 'help-heading3' },
			{ title: 'Heading 4', block: 'div', classes: 'help-heading4' },
			{ title: 'Snygg tabell', selector: 'table', classes: 'nice-table' },
			{ title: 'Developer comment', block: 'div', classes: 'from-developer' },
			{ title: 'Info box', block: 'div', classes: 'info-box' }
		],
		content_css: "/style/help-style.css"
	});



	function versionDropdownChange(e) {
		loadContent(
			editorForm.elements.pageId.value, 
			editorForm.elements.lang.value, 
			e.target.value
		);
	}

	function loadContent(pageId, lang, version) {
		var url = "/api/content.php?pageId="+pageId;
		if(lang) url += "&lang="+lang;
		if(version) url += "&version="+version;

		var xhr = new XMLHttpRequest();
		xhr.addEventListener("load", contentLoaded);
		xhr.responseType = "json";
		xhr.open("GET", url);
		xhr.send();
	

		function contentLoaded(e) {
			var data = e.target.response;
			console.log("Content loaded", data);

			var content = data.content;
			tinymce.get('content').setContent(content.content);
			editorForm.elements.title.value = content.title || "";
			editorForm.elements.lang.value = lang;
			editorForm.elements.pageId.value = pageId;

			versionSelector.innerHTML = "";
			if(data.availableVersions.length===0) {
				versionSelector.innerHTML = "<option>Första version</option>";
			} else {
				data.availableVersions.forEach(function(v) {
					var option = document.createElement("option");
					option.value = v.version;
					option.textContent = "v. " + v.version + " " + v.saved_by + " (" + v.saved.substr(0,16) + ")";
					if(v.published==="t") {
						option.textContent += " - publicerad";
					}
					if(v.version === content.version) {
						option.setAttribute("selected","");
					}
					versionSelector.appendChild(option);
				});
			}
		}
	}

	function newContent(pageId, lang) {
		editorForm.reset();
		versionSelector.innerHTML = "<option>Första version</option>";
		editorForm.elements.lang.value = pageId;
		editorForm.elements.pageId.value = lang;		
	}

	function hideEditor() {
		editorForm.style.display = "none";
	}

	function showEditor() {
		editorForm.style.display = "";
	}


	function contentSave(e) {
		e.preventDefault();
		tinymce.get('content').save();
		
		var form = e.target;
		var formData = new FormData(form);

		var xhr = new XMLHttpRequest();
		xhr.addEventListener("load", contentSaved);
		xhr.open("POST", "/api/content.php");
		xhr.send(formData);
	}


	function contentSaved(data) {
		console.log("Content saved", data);
	}


	return {
		hide: hideEditor,
		show: showEditor,
		new: newContent,
		load: loadContent
	}

}());
