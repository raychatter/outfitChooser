// TODO: Remove jQuery since you can't access SVG elements from it
$(document).ready(function(){
	fillSVG('#top-main-color', "top-image", "insideTop");
	fillSVG('#bottom-main-color', 'bottom-image', 'InsidePants');
	fillSVG('#shoe-main-color', 'shoe-image-left', 'ShoeOutline');
	fillSVG('#shoe-main-color', 'shoe-image-right', 'ShoeOutline');
});

function fillSVG(colorId, objectId, selectorToFill) {
	if($(colorId).text()) {
		var SVGImage = document.getElementById(objectId);
		SVGImage.addEventListener("load",function() {
			var SVGDocument = SVGImage.contentDocument;
			var SVGItem = SVGDocument.getElementById(selectorToFill);
			SVGItem.setAttribute("fill", $(colorId).text());
		});
	}
}
 