var Nav = (function() {
	var activeState = null;
	var callback = function(){};

	function initNav(onChange) {
		addEventListener("popstate", popState, false);
		activeState = path2State(document.location.pathname);
		history.replaceState(activeState, null, null);
		callback = onChange;
		changeState(activeState);
	}

	function popState(e) {
  		console.log("StatePop", "location: " + document.location + ", state: " + JSON.stringify(e.state));
		changeState(e.state);
	}

	function changeState(state) {
		activeState = state;
		callback(state);
	}

	function loadState() {
		console.log("load state", activeState);
		Pages.open(activeState.page, activeState.id);
	}

	function path2State(path) {
		var info = path.substr(1).split('/');
		var state = {};
		if(info[0]) state.page = info[0];
		if(info[1])	state.id = info[1];
		return state;
	}

	function goto(url, state) {
		if(!state) state = path2State(url);
		if(activeState.page===state.page && activeState.id===state.id) return;

		history.pushState(state, null, url);
		changeState(state);
	}
	
	return {
		init: initNav,
		goto: goto
	};
}());