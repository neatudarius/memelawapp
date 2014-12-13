memeApp.controller("memeControl", ["$scope", function($scope){

	$scope.start = 1;
	$scope.count = 10;
	$scope.tags = [];
	$scope.memes = [];
	$scope.query_input="";

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
		    url: "/query.json?q="+query+"&s="+ $scope.start +"&c=" + $scope.count,
		    success: function(data){
			    	data.forEach(function(meme){
						//$scope.addMeme(meme);
						$scope.memes.push(meme);
			    		$scope.start++;
					});
					$scope.$apply();
				}
		
			});
	}

	$scope.RemoveNLoadMemes = function (query){
		$scope.start = 1;
		$scope.memes = [];
		$scope.LoadMemes(query);
	}

	$scope.IncrementMeme = function(mid){
		$.ajax({
		    method: "POST",
		    url: "/incr?mid="+mid,
		    success: function(data){
		    	console.log("Success");
		    },
		    error: function(data, err){
		    	console.log(err);
		    }
		 });
	}
	/*
	$scope.resetMeme = function(){
		$(".memelist").empty();
	}

	$scope.addMeme = function(meme){
		$(".memelist").append(
				'<li class="memeitem" ng-click="IncrementMeme('+ meme.id +')">'
		            +'<div class="bg">'
			            +'<div class="img-thumbnail image" style="background-image: url(\''
			            	+meme.url
			            +'\');"></div>'
		            +'</div>'
            	+'</li>'
		);
	}
	*/

}]);

