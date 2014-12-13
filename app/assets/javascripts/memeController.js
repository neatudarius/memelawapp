memeApp.controller("memeControl", ["$scope", function($scope){

	$scope.text = "Laugh my ass off";

	$scope.currentMemes = [];
	$scope.LoadMemes = function (query, start, count){
		$.ajax({
		    method: "GET",
		    url: "/query.json?q="+query+"&s="+start +"23&c=" + count,
		    success: function(data){
		    	console.log(data);
				data.forEach(function(meme){
					$scope.currentMemes.push(meme);
				});
		    }
		 });
		return false;
	}

	$scope.LoadMemes("my query", 0, 20);
	//console.log($scope.currentMemes);
}]);