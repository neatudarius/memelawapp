memeApp.controller("memeControl", ["$scope", function($scope){

	$scope.currentMemes = [];
	$scope.start = 1;
	$scope.count = 5;


	$scope.LoadMemes = function (query){
		$.ajax({
		    method: "GET",
		    url: "/query.json?q="+query+"&s="+$scope.start +"&c=" + $scope.count,
		    success: function(data){
		    	console.log(data);
		    	$scope.start += $scope.count;
				data.forEach(function(meme){
					$scope.currentMemes.push(meme);
				});
		    }
		 });
		return false;
	}

	$scope.LoadMemes('money');

	$scope.RemoveNLoadMemes = function (query){
		$scope.start = 1;
		$scope.newCurrentMemes = [];
		$.ajax({
		    method: "GET",
		    url: "/query.json?q="+query+"&s="+$scope.start +"&c=" + $scope.count,
		    success: function(data){
		    	console.log(data);
		    	$scope.start += $scope.count;
				data.forEach(function(meme){
					$scope.newCurrentMemes.push(meme);
				});
				$scope.currentMemes = $scope.newCurrentMemes;
		    }
		 });
		return false;
	}

}]);