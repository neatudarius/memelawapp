memeApp.controller("memeControl", ["$scope", function($scope){

	$scope.start = 1;
	$scope.count = 5;
	$scope.tags = [];

	$scope.LoadTags = function(start, count){
		$.ajax({
		    method: "GET",
		    url: "/tag.json?s=" + start + "c=" + count,
		    success: function(data){
		    	data.forEach(function(tag){
		    		$scope.tags.push(tag.tag);
		    	});
		    	$("#main_search").autocomplete({
                    source: $scope.tags
                });
		    }
		});
	}

	$scope.LoadMemes = function (query){
		$.ajax({
		    method: "GET",
		    url: "/query.json?q="+query+"&s="+$scope.start +"&c=" + $scope.count,
		    success: function(data){
		    	$scope.start += $scope.count;
				data.forEach(function(meme){
					$scope.addMeme(meme);
				});
		    }
		});
	}

	$scope.RemoveNLoadMemes = function (query){
		$scope.start = 1;
		$scope.resetMeme();
		$.ajax({
		    method: "GET",
		    url: "/query.json?q="+query+"&s="+$scope.start +"&c=" + $scope.count,
		    success: function(data){
		    	$scope.start += $scope.count;
				data.forEach(function(meme){
					$scope.addMeme(meme);
				});
		    }
		 });
	}

	$scope.resetMeme = function(){
		$(".memelist").empty();
	}

	$scope.addMeme = function(meme){
		$(".memelist").append(
			'<li class="memeitem">'
            +'<div class="bg">'
            +'<div class="img-thumbnail image" style="background-image: url(\''
            +meme.url
            +'\');"></div>'
            +'</div>'
            +'</li>'
		);
	}

}]);

