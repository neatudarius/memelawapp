memeApp.controller("memeControl", ["$scope", function($scope){

	$scope.currentMemes = [];
	$scope.start = 1;
	$scope.count = 5;


	$scope.LoadMemes = function (query){
		$scope.start = 1;
		$.ajax({
		    method: "GET",
		    url: "/query.json?q="+query+"&s="+$scope.start +"23&c=" + $scope.count,
		    success: function(data){
		    	$scope.start += $scope.count;
				data.forEach(function(meme){
					//meme.url = "http://sadmoment.com/wp-content/uploads/2013/11/Give-Me-Some-Of-That-Food-Cat-Meme.jpg";
					$scope.currentMemes.push(meme);
				});
		    }
		 });
		return false;
	}

	$scope.LoadMemes('money');
	$scope.RemoveNLoadMemes = function (query){
		$scope.newCurrentMemes = [];
		$.ajax({
		    method: "GET",
		    url: "/query.json?q="+query+"&s="+$scope.start +"23&c=" + $scope.count,
		    success: function(data){
		    	$scope.start += $scope.count;
				data.forEach(function(meme){
					//meme.url = "http://sadmoment.com/wp-content/uploads/2013/11/Give-Me-Some-Of-That-Food-Cat-Meme.jpg";
					$scope.newCurrentMemes.push(meme);
				});
				$scope.currentMemes = $scope.newCurrentMemes;
		    }
		 });
		return false;
	}

}]);