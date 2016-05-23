"use strict";
var pages;
var lang = "sv";


listenForActionButtons();
listenForCommit();



function onStateChange(state) {
	switch(state.page) {

		case 'page':
		Content.load(state.id, lang);
		Content.show();
		Page.load(state.id);
		Page.show();
		PageList.select(state.id);
		break;

		case 'newPage': 
		Content.new();
		Content.hide();
		Page.new();
		Page.show();
		break;

		default:
		Content.hide();
		Page.hide();
	}
}

function listenForCommit() {
	var commitForm = document.querySelector(".commit-form");
	commitForm.addEventListener("submit", commitHelpPages, false);
}

function commitHelpPages(e) {
	e.preventDefault();
	var formData = new FormData(e.target);

	var url = "/release-to-source.php";
	var xhr = new XMLHttpRequest();
	xhr.addEventListener("load", commitCallback);
	xhr.open("POST", url);
	xhr.send(formData);

	function commitCallback(e) {
		console.log(e.target);
	}
}



function listenForActionButtons() {
	var actionButtons = document.querySelectorAll("button[data-action], li.tab[data-action]");
	for(var i=0; i<actionButtons.length; i++) {
		var button = actionButtons[i];
		button.addEventListener("click", actionButtonClicked, false);
	}
}


function actionButtonClicked(e) {
	var button = e.target;
	var action = button.dataset.action;

	switch(action) {
		case "newPage":
			Nav.goto("/newPage");
		break;

		case "newSubPage":
			Nav.goto("/newPage");
			Page.updateParentPageSelect(button.dataset.parentId);
		break;

		case "deletePage":
		console.warn("Delete not implemented");
		break;

		default:
			console.log("Unhandled action:", action);
	}

}



function getAllPages(callback) {
	var url = "/api/page.php";
	
	var xhr = new XMLHttpRequest();
	xhr.addEventListener("load", allPagesLoaded);
	xhr.responseType = "json";
	xhr.open("GET", url);
	xhr.send();

	function allPagesLoaded(e) {
		if(e.target.status === 200) {
			pages = e.target.response.pages;
			if(callback) callback();
			PageList.update();
		}
	}
}


