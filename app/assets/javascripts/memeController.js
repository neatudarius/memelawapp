memeApp.controller("memeControl", ["$scope", function($scope){

	$scope.start = 1;
	$scope.count = 10;
	$scope.tags = [];
	$scope.memes = [];
	$scope.query_input="";
	$scope.isFetching = false;

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
		$scope.isFetching = true;
		console.log(1);
		$.ajax({
		    method: "GET",
		    url: "/query.json?q="+query+"&s="+ $scope.start +"&c=" + $scope.count,
		    success: function(data){
			    	data.forEach(function(meme){
						$scope.memes.push(meme);
			    		$scope.start++;
					});
					//if response is null, then never try to disturb me again
					//i mean request data
					if(data.length>0)
						$scope.isFetching = false;
					$scope.$apply();
				}
		
			});
	}

	$scope.RemoveNLoadMemes = function (query){
		$scope.start = 1;
		$scope.memes = [];
		$scope.LoadMemes(query);
	}

	$scope.memeFromMid = function(mid){
		var result = [];
		angular.forEach($scope.memes,function(value, key) {
  			if(value.id == mid){
  				result = value;
  			}
  				
		});
		return result;
	}

	$scope.currentlyExpanded = [];
	$scope.ExpandMeme = function(mid){
		
		$scope.currentlyExpanded.forEach(function(item){
			$scope.hideCollapse(item);
		});

		$("#meme"+mid).collapse('show');
		$("#memeitem"+mid).css({"height":"350px","width":"95%"});
		$("#memeimage"+mid).css({"height":"250px","width":"200px"});
		$("#memeitem"+mid).addClass("jumbotron");

		$scope.currentlyExpanded.push(mid);
		
		$scope.IncrementMeme(mid);
	}

	$scope.hideCollapse = function(mid){
		$("#meme"+mid).collapse('hide');
		$("#memeitem"+mid).css({"height":"200px","width":"150px"});
		$("#memeimage"+mid).css({"height":"200px","width":"150px"});
		$("#memeitem"+mid).removeClass("jumbotron");
		return 0;
	};

	$scope.IncrementMeme = function(mid){

		$.ajax({
		    method: "POST",
		    url: "/incr?mid=" + mid,
		    success: function(data){
		    	console.log("Success");
		    },
		    error: function(data, err){
		    	console.log(err);
		    }
		 });
	}

    
}]);

