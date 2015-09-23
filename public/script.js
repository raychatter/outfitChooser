// TODO: Remove jQuery since you can't access SVG elements from it
$(document).ready(function(){
	
	if($('#top-main-color').text()) {
		var topImageSVG = document.getElementById("top-image");
		topImageSVG.addEventListener("load",function() {
			var topImageSVGDoc = topImageSVG.contentDocument;
			var insideTopSVGItem = topImageSVGDoc.getElementById("insideTop");
			insideTopSVGItem.setAttribute("fill", $('#top-main-color').text());
		});
	}

	if($('#bottom-main-color').text()) {
		var bottomImageSVG = document.getElementById("bottom-image");
		bottomImageSVG.addEventListener("load",function() {
			var bottomImageSVGDoc = bottomImageSVG.contentDocument;
			var insidePantsSVGItem = bottomImageSVGDoc.getElementById("InsidePants");
			insidePantsSVGItem.setAttribute("fill", $('#bottom-main-color').text());
		});
	}
});
 