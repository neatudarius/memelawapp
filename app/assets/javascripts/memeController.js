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
	console.log($scope.memeFromMid(1));
	$scope.IncrementMeme = function(mid){

		var templ = '<div class="popover" role="tooltip" style="max-width:500px;"><div class="arrow"></div><h3 class="popover-title"></h3><div class="popover-content"></div></div>';
    	var myMeme = $scope.memeFromMid(mid);
    	console.log(myMeme);
        var content = '<img src="' + myMeme.url + '" width="450px">';
        //$('#meme'+myMeme.id).popover({placement: 'bottom', content: content, html: true, template:templ});
	    
	    
	               
	    $('html').on('mouseup', function(e) {
	        if(!$(e.target).closest('.popover').length) {
	            $('.popover').each(function(){
	                $(this.previousSibling).popover('hide');
	            });
	        }
	    });

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

